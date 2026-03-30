import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/component/clouds.dart';
import 'package:game/configs/ads.dart';
import 'package:games_services/games_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'component/wing.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'component/pipes.dart';
import 'component/player.dart';
import 'configs/audio_helper.dart';
import 'configs/functions.dart';
import 'firebase_options.dart';
import 'models/player_data.dart';
import 'screens/main_widget.dart';
import 'configs/leaderboard_helper.dart';
import 'package:game/component/skins/skin_enum.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await MobileAds.instance.initialize();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();
  await dotenv.load();
  await PlayerInfo.init();
  final game = MyWorld();
  runApp(MainWidget(game: game));
}

class MyWorld extends FlameGame with TapCallbacks, HasCollisionDetection {
  MyWorld() : super();

  // objects
  late TextComponent score = buildScore();
  final AudioHelper audio = AudioHelper();
  final AdmobAds ads = AdmobAds();
  final TheBird player = TheBird();
  final Clouds clouds = Clouds();
  final Pipes pipes = Pipes();
  final Wing wing = Wing();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // states
  bool newHighest = false;
  bool isStarted = false;
  ValueNotifier<bool> isLuckyDayActive = ValueNotifier<bool>(false);
  bool isShieldEnabled = false;
  int scorePoint = 0;
  bool sound = true;
  int deadTimes = 0;
  PlayerInfo playerData = PlayerInfo();
  ValueNotifier<int> coins = ValueNotifier<int>(0);
  ValueNotifier<int> highest = ValueNotifier<int>(0);
  final ValueNotifier<ChallengeData?> leaderboardChallenge = ValueNotifier<ChallengeData?>(null);
  bool hasShownChallengeAnimation = false;

  @override
  Future<void> onLoad() async {
    // debugMode = true;
    playerData = await PlayerInfo.load();
    coins.value = playerData.coins;
    highest.value = playerData.highScore;

    playerData.addListener(() {
      coins.value = playerData.coins;
      highest.value = playerData.highScore;
    });

    // Sync leaderboard score and fetch challenge once
    LeaderboardHelper.syncHighScore(playerData);
    LeaderboardHelper.fetchChallengeData(playerData.highScore).then((data) {
      leaderboardChallenge.value = data;
    });

    player.updateTrail(playerData.selectedTrail);
    player.skin = playerData.selectedSkin;


    // Listen for account changes
    GameAuth.player.listen((isAuthenticated) async {
      if (isAuthenticated != null) {
        final newData = await PlayerInfo.load();
        if (playerData.playerId != newData.playerId) {
          playerData.runBatched([() async => playerData.updateFrom(newData)]);
          // Re-sync game state
          LeaderboardHelper.syncHighScore(playerData);
          player.updateTrail(playerData.selectedTrail);
          await player.updateSkin(playerData.selectedSkin);
          updateScore();
          
          // Re-fetch challenges for new account
          LeaderboardHelper.fetchChallengeData(playerData.highScore).then((data) {
            leaderboardChallenge.value = data;
          });
        }
      }
    });

    addAll({clouds, player, pipes, score, wing});
    updateScore();

    // Initial overlays
    overlays.add('start');
    overlays.add('coin_display');
  }

  @override
  void onTapDown(TapDownEvent event) => player.goUp();

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      priority: 2,
      textRenderer: TextPaint(
        style: GoogleFonts.luckiestGuy(
          textStyle: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> getHighest() async => highest.value = playerData.highScore;

  void setHighest() {} // Deprecated, handled by PlayerData

  void startGame({bool withRewarded = false}) {
    player.reset();
    pipes.reset();
    newHighest = false;
    scorePoint = withRewarded ? scorePoint : 0;
    updateScore();
    isStarted = true;

    // Check Lucky Day usage
    if (isLuckyDayActive.value) {
      if (playerData.luckyDay > 0) {
        playerData.runBatched([() => playerData.useLuckyDay()]);
      } else {
        isLuckyDayActive.value = false;
      }
    }

    // Check Shield usage
    if (isShieldEnabled) {
      if (playerData.shields > 0) {
        playerData.runBatched([() => playerData.useShield()]);
        player.hasActiveShield = true;
      } else {
        isShieldEnabled = false;
        player.hasActiveShield = false;
      }
    } else {
      player.hasActiveShield = false;
    }

    audio.setStarted(isStarted);
    if (!withRewarded) return;
    ads.didGetRewarded = false;
  }

  String? tempTrail;
  Skins? tempSkin;

  void gameOver() {
    if (tempTrail != null) {
      player.updateTrail(playerData.selectedTrail); // Use saved data
      tempTrail = null;
    }
    if (tempSkin != null) {
      player.updateSkin(playerData.selectedSkin);
      tempSkin = null;
    }

    Functions.addScore(scorePoint);
    audio.playHit();
    Functions.vibration(isStarted);
    checkHighest();
    showingAd();
    isStarted = false;
    audio.setStarted(isStarted);
    overlays.add("start");
  }

  void checkHighest() {
    if (scorePoint <= playerData.highScore) return;
    playerData.runBatched([() => playerData.updateHighScore(scorePoint)]);
    highest.value = scorePoint;
    newHighest = true;
  }

  void showingAd() {
    if (deadTimes == 2) {
      ads.showInterstitialAd();
      deadTimes = 0;
      return;
    }
    deadTimes++;
  }

  void updateScore() => score.text = 'Score: $scorePoint';
}
