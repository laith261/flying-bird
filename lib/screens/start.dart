import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:game/main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/functions.dart';
import '../component/helpers/reward_helper.dart';
import 'Widgets/hieh_score.dart';
import 'Widgets/reword_ad.dart';
import 'shop.dart';
import 'Widgets/start_button.dart';
import 'Widgets/power_up_toggles.dart';
import '../configs/leaderboard_helper.dart';

class StartWidget extends StatefulWidget {
  const StartWidget({super.key, required this.game});

  final MyWorld game;

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  late MyWorld game = widget.game;

  @override
  void initState() {
    super.initState();
    game.playerData.addListener(_onPlayerDataChanged);
    // Check for daily reward progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RewardHelper.checkDailyRewardProgress(context, game.playerData);
    });
  }

  @override
  void dispose() {
    game.playerData.removeListener(_onPlayerDataChanged);
    super.dispose();
  }

  void _onPlayerDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    congress();
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: game.size.y),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  "Flying Bird",
                  style: GoogleFonts.luckiestGuy(
                    textStyle: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.orange,
                          offset: Offset(0, 5),
                        ),
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                HighestScore(game: game),
                const SizedBox(height: 40),
                StartButton(
                  game: game,
                  text: game.ads.didGetRewarded ? "continue" : "Start Game",
                ),
                if (game.ads.rewardedAd != null && !game.ads.didGetRewarded) ...[
                  const SizedBox(height: 15),
                  RewardedAd(
                    game: game,
                    fun: () => setState(() {
                      game.ads.didGetRewarded = true;
                    }),
                  ),
                ],
                const SizedBox(height: 40),
                // Action Buttons Container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withAlpha(128), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIconButton(
                        onPressed: () {
                          setState(() {
                            game.sound = !game.sound;
                            game.audio.setSound(game.sound);
                          });
                        },
                        icon: game.sound ? Icons.volume_up : Icons.volume_off,
                        color: Colors.orangeAccent,
                      ),
                      const SizedBox(width: 15),
                      _buildIconButton(
                        onPressed: () => Functions.showScores(),
                        icon: Icons.leaderboard,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 15),
                      _buildIconButton(
                        onPressed: () => Functions.showAchievements(),
                        icon: Icons.star_rounded,
                        color: Colors.purpleAccent,
                      ),
                      const SizedBox(width: 15),
                      _buildIconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShopScreen(game: game),
                          ),
                        ),
                        icon: Icons.store,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Leaderboard Challenge Widget
                ValueListenableBuilder<ChallengeData?>(
                  valueListenable: game.leaderboardChallenge,
                  builder: (context, challenge, _) {
                    if (challenge == null) return const SizedBox.shrink();
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: game.hasShownChallengeAnimation ? 1.0 : 0.0,
                        end: 1.0,
                      ),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      onEnd: () => game.hasShownChallengeAnimation = true,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.withAlpha(204),
                                Colors.deepOrange.withAlpha(204),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withAlpha(128),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withAlpha(77),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "You need ${challenge.targetScore} score to beat ${challenge.targetName}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Power Up Toggles
                PowerUpToggles(game: game),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        iconSize: 28,
      ),
    );
  }
  void congress() {
    if (!game.newHighest) return;
    game.newHighest = false;
    game.audio.playWin();
    Future.delayed(
      Duration.zero,
          () {
        if (!mounted) return;
        Confetti.launch(
          context,
          options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
        );
      },
    );
    game.analytics.logEvent(
      name: 'new_highest',
      parameters: {'score': game.highest},
    );
  }
}
