import 'package:flutter_soloud/flutter_soloud.dart';

class AudioHelper {
  final soloud = SoLoud.instance;
  late AudioSource _fly;
  late AudioSource _hit;
  late AudioSource _point;
  late AudioSource _win;

  bool isStarted = false;
  bool sound = true;

  AudioHelper() {
    init();
  }

  Future<void> init() async {
    await soloud.init();
    _fly = await soloud.loadAsset('assets/audio/fly.mp3');
    _hit = await soloud.loadAsset('assets/audio/collision.mp3');
    _point = await soloud.loadAsset('assets/audio/point.mp3');
    _win = await soloud.loadAsset('assets/audio/win.mp3');
  }

  void playFly() => _playAudio(_fly);

  void playHit() => _playAudio(_hit);

  void playPoint() => _playAudio(_point);

  void playWin() => _playAudio(_win, playSound: true);

  void setStarted(bool isStarted) => this.isStarted = isStarted;

  void setSound(bool sound) => this.sound = sound;

  void _playAudio(AudioSource audio, {bool playSound = false}) {
    if (sound && (playSound || isStarted)) {
      soloud.play(audio);
    }
  }
}
