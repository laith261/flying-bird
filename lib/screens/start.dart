import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:game/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/functions.dart';
import '../component/helpers/reward_helper.dart';
import 'Widgets/reword_ad.dart';
import '../component/helpers/daily_missions_helper.dart';
import 'Widgets/start_button.dart';
import 'Widgets/power_up_toggles.dart';
import '../configs/leaderboard_helper.dart';
import 'Widgets/record_gift_dialog.dart';

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
      congress();
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
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            constraints: BoxConstraints(minHeight: game.size.y),
            padding: const EdgeInsets.only(bottom: 100),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    context.l10n.appTitle,
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
                  const SizedBox(height: 30),
                  StartButton(
                    game: game,
                    text: game.ads.didGetRewarded
                        ? context.l10n.continueGame
                        : context.l10n.startGame,
                  ),
                  if (game.scorePoint > 0 && !game.ads.didGetRewarded) ...[
                    const SizedBox(height: 15),
                    RewardedAd(
                      game: game,
                      fun: () => setState(() {
                        game.ads.didGetRewarded = true;
                      }),
                    ),
                  ],
                  const SizedBox(height: 20),
                  PowerUpToggles(game: game),
                  const SizedBox(height: 20),
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
                                colors: challenge.isTopPlayer
                                    ? [
                                        Colors.amber.shade600.withAlpha(230),
                                        Colors.deepOrangeAccent.withAlpha(230),
                                      ]
                                    : [
                                        Colors.orange.withAlpha(204),
                                        Colors.deepOrange.withAlpha(204),
                                      ],
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: challenge.isTopPlayer
                                    ? Colors.yellowAccent.withAlpha(200)
                                    : Colors.white.withAlpha(128),
                                width: challenge.isTopPlayer ? 2.0 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: challenge.isTopPlayer
                                      ? Colors.amber.withAlpha(120)
                                      : Colors.orange.withAlpha(77),
                                  blurRadius: challenge.isTopPlayer ? 16 : 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  challenge.isTopPlayer
                                      ? Icons.emoji_events_rounded
                                      : Icons.stars_rounded,
                                  color: challenge.isTopPlayer
                                      ? Colors.yellowAccent
                                      : Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    challenge.isTopPlayer
                                        ? context.l10n.leaderboardTopPlayer
                                        : context.l10n.leaderboardChallengeText(
                                            challenge.targetScore,
                                            challenge.targetName,
                                          ),
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
                ],
              ),
            ),
          ),
        ),
        // Dock Station at bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildDockStation(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDockStation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Sound Toggle (Audio utility)
            _buildIconButton(
              onPressed: () {
                setState(() {
                  game.sound = !game.sound;
                  game.audio.setSound(game.sound);
                });
              },
              icon: game.sound ? Icons.volume_up : Icons.volume_off,
              color: Colors.orangeAccent,
              tooltip: context.l10n.sound,
            ),
            const SizedBox(width: 12),

            // 2. Shop
            _buildIconButton(
              onPressed: () {
                game.shopInitialTabIndex = 0;
                game.overlays.add('shop');
              },
              icon: Icons.store,
              color: Colors.green,
              tooltip: context.l10n.shop,
            ),
            const SizedBox(width: 12),

            // 3. Daily Missions (with badge)
            AnimatedBuilder(
              animation: DailyMissionsManager.instance,
              builder: (context, child) {
                final hasBadge =
                    DailyMissionsManager.instance.hasUnclaimedCompletedMission;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildIconButton(
                      onPressed: () {
                        if (!game.overlays.isActive('daily_missions')) {
                          game.overlays.add('daily_missions');
                        }
                      },
                      icon: Icons.assignment_turned_in_rounded,
                      color: Colors.pinkAccent,
                      tooltip: context.l10n.missions,
                    ),
                    if (hasBadge)
                      PositionedDirectional(
                        top: -2,
                        end: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: 12),

            // 4. Leaderboard
            _buildIconButton(
              onPressed: () => Functions.showScores(),
              icon: Icons.leaderboard,
              color: Colors.blueAccent,
              tooltip: context.l10n.leaderboard,
            ),
            const SizedBox(width: 12),

            // 5. Achievements
            _buildIconButton(
              onPressed: () => Functions.showAchievements(),
              icon: Icons.star_rounded,
              color: Colors.purpleAccent,
              tooltip: context.l10n.achievements,
            ),
            const SizedBox(width: 12),

            // 6. Language Menu (Locale action button menu)
            ValueListenableBuilder<Locale>(
              valueListenable: LanguageManager.currentLocale,
              builder: (context, locale, _) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withAlpha(77),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: PopupMenuButton<String>(
                        tooltip: context.l10n.language,
                        elevation: 8,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        position: PopupMenuPosition.over,
                        offset: const Offset(0, -160),
                        onSelected: (code) => LanguageManager.setLanguage(code),
                        itemBuilder: (context) => [
                          _buildLanguageMenuItem(
                            code: 'en',
                            name: 'English',
                            isSelected: locale.languageCode == 'en',
                          ),
                          _buildLanguageMenuItem(
                            code: 'ar',
                            name: 'العربية',
                            isSelected: locale.languageCode == 'ar',
                          ),
                          _buildLanguageMenuItem(
                            code: 'es',
                            name: 'Español',
                            isSelected: locale.languageCode == 'es',
                          ),
                        ],
                        icon: const Icon(
                          Icons.language_rounded,
                          color: Colors.teal,
                          size: 26,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: -2,
                      end: -2,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            locale.languageCode.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildLanguageMenuItem({
    required String code,
    required String name,
    required bool isSelected,
  }) {
    return PopupMenuItem<String>(
      value: code,
      height: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              code.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.teal.shade800 : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.teal,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    String? tooltip,
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
        iconSize: 26,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        tooltip: tooltip,
      ),
    );
  }

  void congress() {
    if (!game.newHighest) return;
    game.newHighest = false;
    game.audio.playWin();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
      RecordGiftDialog.show(
        context,
        game: game,
        score: game.highest.value,
        onCollected: () {
          if (mounted) setState(() {});
        },
      );
    });
    Future.delayed(const Duration(milliseconds: 800), () async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final int lastReviewTimestamp =
          prefs.getInt('last_in_app_review_time') ?? 0;
      final int now = DateTime.now().millisecondsSinceEpoch;
      const int tenDaysInMillis = 10 * 24 * 60 * 60 * 1000;

      if (now - lastReviewTimestamp >= tenDaysInMillis) {
        final InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();
          await prefs.setInt('last_in_app_review_time', now);
        }
      }
    });
    game.analytics.logEvent(
      name: 'new_highest',
      parameters: {'score': game.highest},
    );
  }
}
