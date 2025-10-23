import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/component/clouds.dart';
import 'package:game/configs/ads.dart';
import 'package:game/configs/data_mange.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'component/pipes.dart';
import 'component/player.dart';
import 'configs/audio_helper.dart';
import 'configs/functions.dart';
import 'screens/main_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly();
  await dotenv.load();
  final game = MyWorld();
  runApp(MainWidget(game: game));
}

class MyWorld extends FlameGame with TapCallbacks, HasCollisionDetection {
  MyWorld() : super();

  // objects
  late TextComponent score = buildScore();
  final AudioHelper audio = AudioHelper();
  final DataMange prefs = DataMange();
  final AdmobAds ads = AdmobAds();
  final Player player = Player();
  final Clouds clouds = Clouds();
  final Pipes pipes = Pipes();

  // states
  bool newHighest = false;
  bool isStarted = false;
  int scorePoint = 0;
  bool sound = true;
  int deadTimes = 0;
  int highest = 0;

  @override
  Future<void> onLoad() async {
    // debugMode = true;
    updateScore();
    getHighest();
    addAll({clouds, player, pipes, score});
  }

  @override
  void onTapDown(TapDownEvent event) => player.goUp();

  TextComponent buildScore() {
    return TextComponent(
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      priority: 2,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.orangeAccent,
          fontSize: 40,
          fontFamily: 'game',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> getHighest() async =>
      highest = await prefs.getDataInt('Highest');

  void setHighest() => prefs.setDataInt('Highest', scorePoint);

  void startGame({bool withRewarded = false}) {
    player.reset();
    pipes.reset();
    getHighest();
    newHighest = false;
    scorePoint = withRewarded ? scorePoint : 0;
    updateScore();
    isStarted = true;
    audio.setStarted(isStarted);
    if (!withRewarded) return;
    ads.didGetRewarded = false;
  }

  void gameOver() {
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
    if (scorePoint < highest) return;

    setHighest();
    highest = scorePoint;
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
