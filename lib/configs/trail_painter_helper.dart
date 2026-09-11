import 'dart:math';
import 'package:flutter/material.dart';

class StarParams {
  final Offset center;
  final double size;
  final double rotation;

  const StarParams({
    required this.center,
    required this.size,
    required this.rotation,
  });
}

class TrailPainterHelper {
  static final Paint _rectPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _rectGlowPaint = Paint()
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  static final Paint _circlePaint = Paint()..style = PaintingStyle.fill;
  static final Paint _circleGlowPaint = Paint()
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  static final Paint _starPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _starGlowPaint = Paint()
    ..style = PaintingStyle.fill
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  static final Paint _lightningPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;
  static final Paint _lightningGlowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  static final Paint _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..strokeCap = StrokeCap.round;
  static final Paint _lineGlowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..color = Colors.orange.withValues(alpha: 0.4)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

  static final Paint _nonePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = Colors.grey;

  static final List<Color> _neonColors = [
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.limeAccent,
  ];

  static void drawRectTrail(
    Canvas canvas,
    Size size,
    Offset center,
    bool isPro,
  ) {
    final int count = 5;
    final double spacing = 15.0;

    for (int i = 0; i < count; i++) {
      double progress = i / count;
      double invProgress = 1.0 - progress;
      double rectSize = 13.0 * invProgress;
      double alpha = invProgress.clamp(0.0, 1.0);
      double angle = progress * 2 * pi;

      Offset pos = center + Offset(-i * spacing, 0);

      if (isPro) {
        Color currentColor = _neonColors[i % _neonColors.length];

        _rectGlowPaint.color = currentColor.withValues(alpha: alpha * 0.4);

        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(angle);
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: (rectSize * 1.5) + 4,
            height: (rectSize * 1.5) + 4,
          ),
          _rectGlowPaint,
        );
        canvas.restore();

        _rectPaint.color = Colors.white.withValues(alpha: alpha);
      } else {
        _rectPaint.color = Colors.orange.withValues(alpha: alpha);
      }

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: rectSize * 1.5,
          height: rectSize * 1.5,
        ),
        _rectPaint,
      );
      canvas.restore();
    }
  }

  static void drawCircleTrail(
    Canvas canvas,
    Size size,
    Offset center,
    bool isPro,
  ) {
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
        Color currentColor = _neonColors[i % _neonColors.length];

        _circleGlowPaint.color = currentColor.withValues(alpha: alpha * 0.4);

        canvas.drawCircle(pos, radius + 3, _circleGlowPaint);
        _circlePaint.color = Colors.white.withValues(alpha: alpha);
      } else {
        _circlePaint.color = Colors.orange.withValues(alpha: alpha);
      }

      canvas.drawCircle(pos, radius * 1.5, _circlePaint);
    }
  }

  static void drawStarTrail(
    Canvas canvas,
    Size size,
    Offset center,
    bool isPro,
  ) {
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
        Color currentColor = _neonColors[i % _neonColors.length];

        _starGlowPaint.color = currentColor.withValues(alpha: alpha * 0.4);

        _drawStarShape(
          canvas,
          StarParams(center: pos, size: starSize + 4, rotation: rotation),
          _starGlowPaint,
        );
        _starPaint.color = Colors.white.withValues(alpha: alpha);
      } else {
        _starPaint.color = Colors.orange.withValues(alpha: alpha);
      }

      _drawStarShape(
        canvas,
        StarParams(center: pos, size: starSize * 1.5, rotation: rotation),
        _starPaint,
      );
    }
  }

  static void drawLightningTrail(
    Canvas canvas,
    Size size,
    Offset center,
    bool isPro,
  ) {
    final int count = 3;
    final double spacing = 20.0;

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
        Color currentColor = _neonColors[i % _neonColors.length];

        _lightningGlowPaint.color = currentColor.withValues(alpha: alpha * 0.4);

        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.drawPath(bolt, _lightningGlowPaint);
        canvas.restore();

        _lightningPaint.color = Colors.white.withValues(alpha: alpha);
      } else {
        _lightningPaint.color = Colors.orange.withValues(alpha: alpha);
      }

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.scale(1.5);
      canvas.drawPath(bolt, _lightningPaint);
      canvas.restore();
    }
  }

  static void drawLineTrail(
    Canvas canvas,
    Size size,
    Offset center,
    bool isPro,
  ) {
    final double length = size.width * 0.7;
    final Offset start = center + Offset(-length / 2, 0);
    final Offset end = center + Offset(length / 2, 0);

    if (isPro) {
      canvas.drawLine(start, end, _lineGlowPaint);

      final shader = const LinearGradient(
        colors: Colors.primaries,
      ).createShader(Rect.fromPoints(start, end));
      _linePaint.shader = shader;
    } else {
      _linePaint.color = Colors.orange;
      _linePaint.shader = null;
    }

    canvas.drawLine(start, end, _linePaint);
  }

  static void _drawStarShape(Canvas canvas, StarParams params, Paint paint) {
    final path = Path();
    double angle = -pi / 2;
    final double step = pi / 5;
    final double outerRadius = params.size / 2;
    final double innerRadius = params.size / 4;

    path.moveTo(outerRadius * cos(angle), outerRadius * sin(angle));
    for (int i = 0; i < 5; i++) {
      angle += step;
      path.lineTo(innerRadius * cos(angle), innerRadius * sin(angle));
      angle += step;
      path.lineTo(outerRadius * cos(angle), outerRadius * sin(angle));
    }
    path.close();

    canvas.save();
    canvas.translate(params.center.dx, params.center.dy);
    canvas.rotate(params.rotation);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  static void drawNone(Canvas canvas, Size size, Offset center) {
    canvas.drawCircle(center, 15, _nonePaint);
    canvas.drawLine(
      center + const Offset(-10, -10),
      center + const Offset(10, 10),
      _nonePaint,
    );
  }
}
