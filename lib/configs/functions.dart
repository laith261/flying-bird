import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:games_services/games_services.dart';
import 'package:vibration/vibration.dart';

import 'const.dart';

class Functions {
  static void vibration(bool isStarted) async {
    if (await Vibration.hasVibrator()) {
      if (isStarted) {
        Vibration.vibrate();
      }
    }
  }

  static Future<void> showScores() async {
    if (await singIn()) {
      Leaderboards.showLeaderboards(androidLeaderboardID: Consts.leaderBoard);
    } else {
      singInToast();
    }
  }

  static Future<void> addScore(int scorePoint) async {
    if (await GameAuth.isSignedIn == false) return;
    Leaderboards.submitScore(
      score: Score(androidLeaderboardID: Consts.leaderBoard, value: scorePoint),
    );
    Achievements.increment(
      achievement: Achievement(
        androidID: Consts.achievements50,
        steps: scorePoint,
      ),
    );
    Achievements.increment(
      achievement: Achievement(
        androidID: Consts.achievements500,
        steps: scorePoint,
      ),
    );
    // Achievements.increment(
    //   achievement: Achievement(
    //     androidID: Consts.achievements5000,
    //     steps: scorePoint,
    //   ),
    // );
    // Achievements.increment(
    //   achievement: Achievement(
    //     androidID: Consts.achievements10000,
    //     steps: scorePoint,
    //   ),
    // );
  }

  static Future<bool> singIn() async {
    if (await GameAuth.isSignedIn == true) return true;
    await GameAuth.signIn();
    return await GameAuth.isSignedIn;
  }

  static Future<void> showAchievements() async {
    if (await singIn()) {
      Achievements.showAchievements();
    } else {
      singInToast();
    }
  }

  static void singInToast() {
    Fluttertoast.showToast(
      msg: "you need to sign in first",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
