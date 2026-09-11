import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../../component/helpers/daily_missions_helper.dart';

import '../../main.dart';

class DailyMissionsDialog extends StatefulWidget {
  final MyWorld game;

  const DailyMissionsDialog({super.key, required this.game});

  @override
  State<DailyMissionsDialog> createState() => _DailyMissionsDialogState();
}

class _DailyMissionsDialogState extends State<DailyMissionsDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    DailyMissionsManager.instance.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: DailyMissionsManager.instance,
        builder: (context, child) {
          final manager = DailyMissionsManager.instance;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Missions",
                          style: GoogleFonts.luckiestGuy(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 32),
                          onPressed: () {
                            widget.game.overlays.remove('daily_missions');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.orangeAccent,
                    indicatorWeight: 4,
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: GoogleFonts.luckiestGuy(fontSize: 20),
                    unselectedLabelStyle: GoogleFonts.luckiestGuy(fontSize: 18),
                    tabs: const [
                      Tab(text: "Daily"),
                      Tab(text: "Weekly / Other"),
                    ],
                  ),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Daily Tab
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(
                              "Resets every day!",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
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
                              onClaim: () => manager.claimCoinsReward(widget.game.playerData),
                            ),
                            const SizedBox(height: 16),
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
                              onClaim: () => manager.claimScoreReward(widget.game.playerData),
                            ),
                            const SizedBox(height: 16),
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
                              onClaim: () => manager.claimGamesReward(widget.game.playerData),
                            ),
                          ],
                        ),

                        // Weekly Tab
                        ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(
                              "Long term trackers",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            _buildGiftInventory(context),
                            const SizedBox(height: 16),
                            _buildMissionRow(
                              context,
                              title: "Daily Login Tracker",
                              desc: "Consecutive daily login streak (Weekly reset)",
                              icon: Icons.calendar_month_rounded,
                              iconColor: Colors.purple,
                              progress: widget.game.playerData.rewardProgress,
                              target: 7,
                              claimed: false,
                              reward: 0,
                              onClaim: () {},
                              isTrackerOnly: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGiftInventory(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.game.playerData,
      builder: (context, _) {
        int gifts = widget.game.playerData.gifts;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.pinkAccent.withAlpha(80),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Gift Inventory",
                          style: GoogleFonts.luckiestGuy(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          "Open gifts for random coin rewards!",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Owned: ",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                        Text(
                          "$gifts",
                          style: GoogleFonts.luckiestGuy(
                            textStyle: const TextStyle(color: Colors.pinkAccent, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gifts > 0
                      ? SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              _openGift();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Open",
                              style: GoogleFonts.luckiestGuy(
                                textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Find one!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openGift() async {
    int currentGifts = widget.game.playerData.gifts;
    if (currentGifts > 0) {
      int rand = Random().nextInt(100);
      String prizeText = "";
      IconData prizeIcon = Icons.card_giftcard;
      Color prizeColor = Colors.white;

      List<Future<void> Function()> actions = [
        () => widget.game.playerData.addGift(-1),
      ];

      if (rand < 10) {
        actions.add(() => widget.game.playerData.addShield(1));
        prizeText = "1x Shield!";
        prizeIcon = Icons.security;
        prizeColor = Colors.blueAccent;
      } else if (rand < 20) {
        actions.add(() => widget.game.playerData.addLuckyDay(1));
        prizeText = "1x Lucky Day!";
        prizeIcon = Icons.star;
        prizeColor = Colors.orangeAccent;
      } else {
        List<int> coins = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
        List<int> weights = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        int totalWeight = weights.fold(0, (sum, w) => sum + w);
        int coinRand = Random().nextInt(totalWeight);
        int currentWeight = 0;
        int rewardCoins = 5;
        for (int i = 0; i < coins.length; i++) {
          currentWeight += weights[i];
          if (coinRand < currentWeight) {
            rewardCoins = coins[i];
            break;
          }
        }
        actions.add(() => widget.game.playerData.addCoins(rewardCoins));
        prizeText = "$rewardCoins Coins!";
        prizeIcon = Icons.monetization_on;
        prizeColor = Colors.amber;
      }

      await widget.game.playerData.runBatched(actions);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black87,
          builder: (context) {
            return _GiftOpeningOverlay(
              prizeText: prizeText,
              prizeIcon: prizeIcon,
              prizeColor: prizeColor,
            );
          },
        );
      }
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withAlpha(150)
              : Colors.white.withAlpha(30),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      desc,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bottom Part: Progress bar and Claim button in the same row
          Row(
            children: [
              // Progress Bar & text
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.white.withAlpha(30),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? Colors.green : iconColor,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "$progress/$target",
                      style: GoogleFonts.luckiestGuy(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: isCompleted ? Colors.greenAccent : Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Action Button / Tracker Indicator
              isTrackerOnly
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(60),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Tracking",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(60),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 18),
            SizedBox(width: 6),
            Text(
              "Claimed",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isCompleted) {
      return SizedBox(
        height: 36,
        child: ElevatedButton(
          onPressed: onClaim,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Claim",
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "+$reward 🪙",
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Progress",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _GiftOpeningOverlay extends StatefulWidget {
  final String prizeText;
  final IconData prizeIcon;
  final Color prizeColor;

  const _GiftOpeningOverlay({
    required this.prizeText,
    required this.prizeIcon,
    required this.prizeColor,
  });

  @override
  State<_GiftOpeningOverlay> createState() => _GiftOpeningOverlayState();
}

class _GiftOpeningOverlayState extends State<_GiftOpeningOverlay> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _bounceController;
  bool _showPrize = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
      if (status == AnimationStatus.forward || status == AnimationStatus.reverse) {
        Vibration.hasVibrator().then((hasVibrator) {
          if (hasVibrator) {
            Vibration.vibrate(duration: 30, amplitude: 60);
          }
        });
      }
    })..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _shakeController.stop();
        _bounceController.stop();
        Vibration.hasVibrator().then((hasVibrator) {
          if (hasVibrator) {
            Vibration.vibrate(duration: 100);
          }
        });
        setState(() {
          _showPrize = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
          },
          child: _showPrize
              ? Column(
                  key: const ValueKey('prize'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.prizeIcon, color: widget.prizeColor, size: 100),
                    const SizedBox(height: 16),
                    Text(
                      widget.prizeText,
                      style: GoogleFonts.luckiestGuy(
                        color: Colors.white,
                        fontSize: 32,
                        shadows: [
                          const Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text("Awesome!", style: GoogleFonts.luckiestGuy(color: Colors.white, fontSize: 24)),
                    ),
                  ],
                )
              : AnimatedBuilder(
                  key: const ValueKey('gift'),
                  animation: Listenable.merge([_shakeController, _bounceController]),
                  builder: (context, child) {
                    final dx = sin(_shakeController.value * pi * 2) * 4;
                    final dy = sin(_bounceController.value * pi) * -15;
                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/images/gift_glow.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
      ),
    );
  }
}
