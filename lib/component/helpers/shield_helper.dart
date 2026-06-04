import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game/component/player.dart';

class ShieldHelper {
  static void drawShield(Canvas canvas, TheBird player, double angle) {
    canvas.save();
    // Counter-rotate the shield around the center of the bird
    canvas.translate(player.width / 2, player.height / 2);
    canvas.rotate(-angle);
    canvas.translate(-player.width / 2, -player.height / 2);

    // Enhanced "Orbiting Plasma" Shield with Trails
    double time = DateTime.now().millisecondsSinceEpoch / 1000;
    double orbitRadius = player.width * 0.75;

    // Draw subtle rotating energy ring
    final ringPaint = Paint()
      ..color = Colors.cyan.withAlpha(38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Rotate the ring slowly opposite to satellites
    canvas.save();
    canvas.translate(player.width / 2, player.height / 2);
    canvas.rotate(-time * 0.5);
    canvas.drawCircle(Offset.zero, orbitRadius, ringPaint);
    canvas.restore();

    // Draw 3 orbiting satellites with trails
    for (int i = 0; i < 3; i++) {
      double angleVal = (time * 2.5) + (i * (2 * pi / 3));

      // Draw Trail (multiple smaller circles fading out)
      for (int j = 1; j <= 5; j++) {
        double trailAngle = angleVal - (j * 0.15); // Lag behind
        double trailX = (player.width / 2) + orbitRadius * cos(trailAngle);
        double trailY = (player.height / 2) + orbitRadius * sin(trailAngle);

        canvas.drawCircle(
          Offset(trailX, trailY),
          4.0 - (j * 0.6), // Shrinking size
          Paint()
            ..color = Colors.cyanAccent.withAlpha(
              ((0.5 - (j * 0.08)) * 255).toInt(),
            ),
        );
      }

      // Main Satellite
      double satelliteX = (player.width / 2) + orbitRadius * cos(angleVal);
      double satelliteY = (player.height / 2) + orbitRadius * sin(angleVal);

      canvas.drawCircle(
        Offset(satelliteX, satelliteY),
        5,
        Paint()
          ..color = Colors.white
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
    canvas.restore(); // Restore counter-rotation
  }
}
