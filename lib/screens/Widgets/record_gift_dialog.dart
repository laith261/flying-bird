import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/functions.dart';
import '../../main.dart';

class RecordGiftDialog extends StatefulWidget {
  final MyWorld game;
  final int score;
  final VoidCallback? onCollected;

  const RecordGiftDialog({
    super.key,
    required this.game,
    required this.score,
    this.onCollected,
  });

  static Future<void> show(
    BuildContext context, {
    required MyWorld game,
    required int score,
    VoidCallback? onCollected,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RecordGiftDialog(
        game: game,
        score: score,
        onCollected: onCollected,
      ),
    );
  }

  @override
  State<RecordGiftDialog> createState() => _RecordGiftDialogState();
}

class _RecordGiftDialogState extends State<RecordGiftDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _collected = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleCollect() async {
    if (_collected) return;
    _collected = true;

    // Award the gift and persist it
    await widget.game.playerData.addGift(1);

    // Audio & haptic feedback
    widget.game.audio.playPoint();
    Functions.vibration(true);

    widget.onCollected?.call();

    if (!mounted) return;

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.card_giftcard, color: Colors.amberAccent),
            const SizedBox(width: 8),
            Text(
              context.l10n.giftCollectedTotal(widget.game.playerData.gifts),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleCollect();
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade900.withAlpha(240),
                    Colors.black.withAlpha(240),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.amberAccent, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withAlpha(80),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Text(
                    "🏆 ${context.l10n.newRecordTitle} 🏆",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.luckiestGuy(
                      textStyle: const TextStyle(
                        fontSize: 26,
                        color: Colors.amberAccent,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.score(widget.score).toUpperCase(),
                    style: GoogleFonts.luckiestGuy(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Animated Bouncing Gift
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final double offset =
                          sin(_animController.value * 2 * pi) * 8;
                      final double scale =
                          1.0 + (sin(_animController.value * 2 * pi) * 0.04);

                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/gift_glow.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.card_giftcard,
                        size: 100,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Gift Reward Callout
                  Text(
                    context.l10n.freeGiftEarned,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.luckiestGuy(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.orange,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.addedToGiftInventory,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Collect Button
                  GestureDetector(
                    onTap: _handleCollect,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD500),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        context.l10n.collect.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.luckiestGuy(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
