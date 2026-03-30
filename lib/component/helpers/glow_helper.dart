import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game/component/player.dart';

class GlowHelper {
  static void drawGlow(Canvas canvas, TheBird player) {
    final double time = DateTime.now().millisecondsSinceEpoch / 1000.0;

    // Pulsating effect for size and opacity
    final double pulse = (sin(time * 5.0) + 1.0) / 2.0; // 0.0 to 1.0
    final double glowRadius = player.width * (0.8 + 0.2 * pulse);
    final double opacity = 0.3 + 0.2 * pulse;

    final Paint glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(
      Offset(player.width / 2, player.height / 2),
      glowRadius,
      glowPaint,
    );
  }
}
