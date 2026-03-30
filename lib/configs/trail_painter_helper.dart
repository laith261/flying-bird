import 'dart:math';
import 'package:flutter/material.dart';

class TrailPainterHelper {
  static void drawRectTrail(Canvas canvas, Size size, Offset center, bool isPro) {
    final paint = Paint()..style = PaintingStyle.fill;
    final int count = 5;
    final double spacing = 15.0;
    // Shift center forward to accommodate trail
    // final Offset drawCenter = center + const Offset(30, 0);

    for (int i = 0; i < count; i++) {
      double progress = i / count;
      double invProgress = 1.0 - progress;
      double rectSize = 13.0 * invProgress;
      double alpha = invProgress.clamp(0.0, 1.0);
      double angle = progress * 2 * pi;

      Offset pos = center + Offset(-i * spacing, 0);

      if (isPro) {
        final neonColors = [
          Colors.cyanAccent,
          Colors.purpleAccent,
          Colors.pinkAccent,
          Colors.limeAccent,
        ];
        Color currentColor = neonColors[i % neonColors.length];
        
        // Glow
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = currentColor.withValues(alpha: alpha * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(angle);
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: (rectSize * 1.5) + 4, height: (rectSize * 1.5) + 4),
          glowPaint,
        );
        canvas.restore();

        paint.color = Colors.white.withValues(alpha: alpha);
      } else {
        paint.color = Colors.orange.withValues(alpha: alpha);
      }

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: rectSize * 1.5, height: rectSize * 1.5),
        paint,
      );
      canvas.restore();
    }
  }

  static void drawCircleTrail(Canvas canvas, Size size, Offset center, bool isPro) {
    final paint = Paint()..style = PaintingStyle.fill;
    final int count = 6;
    final double spacing = 12.0;
    final Offset drawCenter = center + const Offset(25, 0);

    for (int i = 0; i < count; i++) {
      double progress = i / count;
      double invProgress = 1.0 - progress;
      double radius = 10.0 * invProgress;
      double alpha = invProgress.clamp(0.0, 1.0);

      Offset pos = drawCenter + Offset(-i * spacing, (i % 2 == 0 ? 5 : -5));

      if (isPro) {
        final neonColors = [
          Colors.cyanAccent,
          Colors.purpleAccent,
          Colors.pinkAccent,
          Colors.limeAccent,
        ];
        Color currentColor = neonColors[i % neonColors.length];

        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = currentColor.withValues(alpha: alpha * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        canvas.drawCircle(pos, radius + 3, glowPaint);
        paint.color = Colors.white.withValues(alpha: alpha);
      } else {
        paint.color = Colors.orange.withValues(alpha: alpha);
      }

      canvas.drawCircle(pos, radius * 1.5, paint);
    }
  }

  static void drawStarTrail(Canvas canvas, Size size, Offset center, bool isPro) {
    final paint = Paint()..style = PaintingStyle.fill;
    final int count = 5;
    final double spacing = 18.0;
    final Offset drawCenter = center + const Offset(35, 0);

    for (int i = 0; i < count; i++) {
      double progress = i / count;
      double invProgress = 1.0 - progress;
      double starSize = 15.0 * invProgress;
      double alpha = invProgress.clamp(0.0, 1.0);
      double rotation = i * pi / 4;

      Offset pos = drawCenter + Offset(-i * spacing, (i % 2 == 0 ? 3 : -3));

      if (isPro) {
        final neonColors = [
          Colors.cyanAccent,
          Colors.purpleAccent,
          Colors.pinkAccent,
          Colors.limeAccent,
        ];
        Color currentColor = neonColors[i % neonColors.length];

        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = currentColor.withValues(alpha: alpha * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        _drawStarShape(canvas, pos, starSize + 4, rotation, glowPaint);
        paint.color = Colors.white.withValues(alpha: alpha);
      } else {
        paint.color = Colors.orange.withValues(alpha: alpha);
      }

      _drawStarShape(canvas, pos, starSize * 1.5, rotation, paint);
    }
  }

  static void drawLightningTrail(Canvas canvas, Size size, Offset center, bool isPro) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final int count = 3;
    final double spacing = 20.0;
    // final Offset drawCenter = center + const Offset(20, 0);

    for (int i = 0; i < count; i++) {
      double progress = i / count;
      double invProgress = 1.0 - progress;
      double alpha = invProgress.clamp(0.0, 1.0);

      Offset pos = center + Offset(-i * spacing, 0);
      Path bolt = Path();
      bolt.moveTo(0, -10 * invProgress);
      bolt.lineTo(-5 * invProgress, 2 * invProgress);
      bolt.lineTo(2 * invProgress, 0);
      bolt.lineTo(-3 * invProgress, 10 * invProgress);

      if (isPro) {
        final neonColors = [
          Colors.cyanAccent,
          Colors.purpleAccent,
          Colors.pinkAccent,
          Colors.limeAccent,
        ];
        Color currentColor = neonColors[i % neonColors.length];

        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..color = currentColor.withValues(alpha: alpha * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.drawPath(bolt, glowPaint);
        canvas.restore();

        paint.color = Colors.white.withValues(alpha: alpha);
      } else {
        paint.color = Colors.orange.withValues(alpha: alpha);
      }

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.scale(1.5);
      canvas.drawPath(bolt, paint);
      canvas.restore();
    }
  }

  static void drawLineTrail(Canvas canvas, Size size, Offset center, bool isPro) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final double length = size.width * 0.7;
    final Offset start = center + Offset(-length / 2, 0);
    final Offset end = center + Offset(length / 2, 0);

    if (isPro) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..color = Colors.orange.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      canvas.drawLine(start, end, glowPaint);

      final shader = const LinearGradient(
        colors: Colors.primaries,
      ).createShader(Rect.fromPoints(start, end));
      paint.shader = shader;
    } else {
      paint.color = Colors.orange;
    }

    canvas.drawLine(start, end, paint);
  }

  static void _drawStarShape(Canvas canvas, Offset center, double size, double rotation, Paint paint) {
    final path = Path();
    double angle = -pi / 2;
    final double step = pi / 5;
    final double outerRadius = size / 2;
    final double innerRadius = size / 4;

    path.moveTo(outerRadius * cos(angle), outerRadius * sin(angle));
    for (int i = 0; i < 5; i++) {
      angle += step;
      path.lineTo(innerRadius * cos(angle), innerRadius * sin(angle));
      angle += step;
      path.lineTo(outerRadius * cos(angle), outerRadius * sin(angle));
    }
    path.close();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  static void drawNone(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey;
    canvas.drawCircle(center, 15, paint);
    canvas.drawLine(
      center + const Offset(-10, -10),
      center + const Offset(10, 10),
      paint,
    );
  }
}
