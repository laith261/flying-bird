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
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'component/pipes.dart';
import 'component/player.dart';
import 'configs/audio_helper.dart';
import 'configs/functions.dart';
import 'models/player_data.dart';
import 'screens/main_widget.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  MobileAds.instance.initialize();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();
  await dotenv.load();
  await PlayerData.init();
  final game = MyWorld();
  runApp(MainWidget(game: game));
}

class MyWorld extends FlameGame with TapCallbacks, HasCollisionDetection {
  MyWorld() : super();

  // objects
  late TextComponent score = buildScore();
  final AudioHelper audio = AudioHelper();
  final AdmobAds ads = AdmobAds();
  final Player player = Player();
  final Clouds clouds = Clouds();
  final Pipes pipes = Pipes();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // states
  bool newHighest = false;
  bool isStarted = false;
  ValueNotifier<bool> isLuckyDayActive = ValueNotifier<bool>(false);
  bool isShieldEnabled = false;
  int scorePoint = 0;
  bool sound = true;
  int deadTimes = 0;
  PlayerData playerData = PlayerData();
  ValueNotifier<int> coins = ValueNotifier<int>(0);
  ValueNotifier<int> highest = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    // debugMode = true;
    playerData = await PlayerData.load();
    coins.value = playerData.coins;
    highest.value = playerData.highScore;
    player.updateTrail(playerData.selectedTrail);

    addAll({clouds, player, pipes, score});
    updateScore();

    // Initial overlays
    overlays.add('start');
    overlays.add('coin_display');
    playerData.addCoins(50);
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
        playerData.useLuckyDay();
      } else {
        isLuckyDayActive.value = false;
      }
    }

    // Check Shield usage
    if (isShieldEnabled) {
      if (playerData.shields > 0) {
        playerData.useShield();
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

  void gameOver() {
    if (tempTrail != null) {
      player.updateTrail(playerData.selectedTrail); // Use saved data
      tempTrail = null;
    }

    Functions.addScore(scorePoint);
    audio.playHit();
    Functions.vibration(isStarted);
    checkHighest();
    showingAd();
    isStarted = false;
    audio.setStarted(isStarted);
    overlays.add("end");
  }

  void checkHighest() {
    if (scorePoint <= playerData.highScore) return;
    playerData.updateHighScore(scorePoint);
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
