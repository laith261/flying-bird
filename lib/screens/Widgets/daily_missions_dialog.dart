import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/player_data.dart';
import '../../component/helpers/daily_missions_helper.dart';

class DailyMissionsDialog extends StatefulWidget {
  final PlayerInfo playerData;

  const DailyMissionsDialog({super.key, required this.playerData});

  @override
  State<DailyMissionsDialog> createState() => _DailyMissionsDialogState();
}

class _DailyMissionsDialogState extends State<DailyMissionsDialog> {
  @override
  void initState() {
    super.initState();
    DailyMissionsManager.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DailyMissionsManager.instance,
      builder: (context, child) {
        final manager = DailyMissionsManager.instance;
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Daily Missions",
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 32,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Resets every day!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildMissionRow(
                    context,
                    title: "Coin Collector",
                    desc: "Collect 10 coins in gameplay",
                    icon: Icons.monetization_on,
                    iconColor: Colors.amber,
                    progress: manager.coinsProgress,
                    target: 10,
                    claimed: manager.coinsClaimed,
                    reward: 10,
                    onClaim: () => manager.claimCoinsReward(widget.playerData),
                  ),
                  const SizedBox(height: 15),
                  _buildMissionRow(
                    context,
                    title: "High Flyer",
                    desc: "Reach a score of 15",
                    icon: Icons.emoji_events,
                    iconColor: Colors.orange,
                    progress: manager.scoreProgress,
                    target: 15,
                    claimed: manager.scoreClaimed,
                    reward: 15,
                    onClaim: () => manager.claimScoreReward(widget.playerData),
                  ),
                  const SizedBox(height: 15),
                  _buildMissionRow(
                    context,
                    title: "Survivor",
                    desc: "Play 3 games",
                    icon: Icons.videogame_asset,
                    iconColor: Colors.blue,
                    progress: manager.gamesPlayed,
                    target: 3,
                    claimed: manager.gamesClaimed,
                    reward: 10,
                    onClaim: () => manager.claimGamesReward(widget.playerData),
                  ),
                  const SizedBox(height: 15),
                  _buildMissionRow(
                    context,
                    title: "Daily Login Tracker",
                    desc: "Consecutive daily login streak (Weekly reset)",
                    icon: Icons.calendar_month_rounded,
                    iconColor: Colors.purple,
                    progress: widget.playerData.rewardProgress,
                    target: 7,
                    claimed: false,
                    reward: 0,
                    onClaim: () {},
                    isTrackerOnly: true,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Got it!",
                  style: GoogleFonts.luckiestGuy(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMissionRow(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required int progress,
    required int target,
    required bool claimed,
    required int reward,
    required VoidCallback onClaim,
    bool isTrackerOnly = false,
  }) {
    bool isCompleted = progress >= target;
    double progressPercent = (progress / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withAlpha(100)
              : Colors.grey.withAlpha(50),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Part: Icon, Title, Description
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      desc,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom Part: Progress bar and Claim button in the same row
          Row(
            children: [
              // Progress Bar & text
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.grey.withAlpha(50),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? Colors.green : iconColor,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$progress/$target",
                      style: GoogleFonts.luckiestGuy(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: isCompleted ? Colors.green : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action Button / Tracker Indicator
              isTrackerOnly
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Tracking",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _buildActionButton(
                      claimed: claimed,
                      isCompleted: isCompleted,
                      reward: reward,
                      onClaim: onClaim,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required bool claimed,
    required bool isCompleted,
    required int reward,
    required VoidCallback onClaim,
  }) {
    if (claimed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(40),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
            SizedBox(width: 4),
            Text(
              "Claimed",
              style: TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isCompleted) {
      return SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: onClaim,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Claim",
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "+$reward 🪙",
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(40),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Progress",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
