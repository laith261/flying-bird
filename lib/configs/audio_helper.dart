import 'package:flutter_soloud/flutter_soloud.dart';

class AudioHelper {
  final soloud = SoLoud.instance;
  late AudioSource _fly;
  late AudioSource _hit;
  late AudioSource _point;
  late AudioSource _win;
  late AudioSource _brake;

  bool isStarted = false;
  bool sound = true;

  AudioHelper() {
    init();
  }

  Future<void> init() async {
    await soloud.init();
    final assets = await Future.wait([
      soloud.loadAsset('assets/audio/fly.mp3'),
      soloud.loadAsset('assets/audio/hit.mp3'),
      soloud.loadAsset('assets/audio/point.mp3'),
      soloud.loadAsset('assets/audio/win.mp3'),
      soloud.loadAsset('assets/audio/brake.mp3'),
    ]);

    _fly = assets[0];
    _hit = assets[1];
    _point = assets[2];
    _win = assets[3];
    _brake = assets[4];
  }

  void playFly() => _playAudio(_fly);

  void playHit() => _playAudio(_hit);

  void playPoint() => _playAudio(_point);

  void playBrake() => _playAudio(_brake);

  void playWin() => _playAudio(_win, playSound: true);

  void setStarted(bool isStarted) => this.isStarted = isStarted;

  void setSound(bool sound) => this.sound = sound;

  void _playAudio(AudioSource audio, {bool playSound = false}) {
    if (sound && (playSound || isStarted)) {
      soloud.play(audio);
    }
  }
}
