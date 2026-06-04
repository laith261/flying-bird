import 'package:flutter/material.dart';
import 'package:game/models/player_data.dart';
import 'package:game/screens/Widgets/daily_reward_dialog.dart';

class RewardHelper {
  static Future<void> checkDailyRewardProgress(
    BuildContext context,
    PlayerInfo playerData,
  ) async {
    final now = DateTime.now();
    final lastLogin = playerData.lastLoginDate;

    // Check if it's a new day
    bool isNewDay =
        now.year != lastLogin.year ||
        now.month != lastLogin.month ||
        now.day != lastLogin.day;

    // For testing/first run, if lastLogin is epoch 0, it counts as a new day
    if (isNewDay) {
      final today = DateTime(now.year, now.month, now.day);
      final prevLoginDay = DateTime(
        lastLogin.year,
        lastLogin.month,
        lastLogin.day,
      );
      final diffDays = today.difference(prevLoginDay).inDays;

      int currentProgress = playerData.rewardProgress;

      if (diffDays == 1 || lastLogin.year == 1970) {
        currentProgress += 1;
      } else if (diffDays > 1) {
        currentProgress = 1; // Reset if missed a day
      }

      bool isRewardDay = currentProgress >= 7;

      await playerData.runBatched([
        () async {
          if (isRewardDay) {
            await playerData.addCoins(10);
            await playerData.updateRewardProgress(0);
          } else {
            await playerData.updateRewardProgress(currentProgress);
          }
        },
        () => playerData.updateLastLoginDate(now),
      ]);

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DailyRewardDialog(
            playerData: playerData,
            isRewardDay: isRewardDay,
          ),
        );
      }
    }
  }
}
