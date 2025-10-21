import 'package:vibration/vibration.dart';

class Functions {
  static void vibration(bool isStarted) async {
    if (await Vibration.hasVibrator()) {
      if (isStarted) {
        Vibration.vibrate();
      }
    }
  }
}
