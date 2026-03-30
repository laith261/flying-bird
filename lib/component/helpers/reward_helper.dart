import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/models/player_data.dart';

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
        showProgressDialog(context, playerData, isRewardDay: isRewardDay);
      }
    }
  }

  static void showProgressDialog(
    BuildContext context,
    PlayerInfo playerData, {
    bool isRewardDay = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          int progress = isRewardDay ? 7 : playerData.rewardProgress;
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: Text(
              isRewardDay ? "Weekly Reward Claimed!" : "Daily Progress",
              textAlign: TextAlign.center,
              style: GoogleFonts.luckiestGuy(
                textStyle: TextStyle(
                  color: isRewardDay ? Colors.green : Colors.orange,
                  fontSize: 28,
                ),
              ),
            ),
            content: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: Column(
                key: ValueKey(isRewardDay),
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isRewardDay) ...[
                    Image.asset(
                      'assets/images/coin_no_bg.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Congratulations!\nYou've reached Day 7 and earned 10 coins!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "Day $progress of 7",
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        bool isCompleted = index < progress;
                        bool isCurrent = index == progress - 1;
                        return _buildProgressIndicator(
                          index,
                          isCompleted,
                          isCurrent,
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Come back tomorrow for Day ${progress + 1}!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRewardDay ? Colors.green : Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isRewardDay ? "Awesome!" : "Got it!",
                    style: GoogleFonts.luckiestGuy(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildProgressIndicator(
    int index,
    bool isCompleted,
    bool isCurrent,
  ) {
    return SizedBox(
      key: ValueKey('reward_day_$index'),
      width: 35,
      height: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle and border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withAlpha(50),
              border: Border.all(
                color: isCurrent
                    ? Colors.orange
                    : (isCompleted ? Colors.orange : Colors.grey),
                width: 2,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: Colors.orange.withAlpha(100),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          // Animated fill
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            width: isCompleted ? 35 : 0,
            height: isCompleted ? 35 : 0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),
          // Check icon
          Center(
            child: AnimatedScale(
              scale: isCompleted ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
