import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../configs/const.dart';

class RotateRectParticle {
  Vector2 position;
  double age;
  final double lifespan;
  double angle;

  RotateRectParticle({
    required this.position,
    this.age = 0,
    this.lifespan = 1.0,
    this.angle = 0,
  });
}

class RotateRectTrail extends PositionComponent {
  final List<RotateRectParticle> _particles = [];
  bool isPro = false;
  double _time = 0;

  RotateRectTrail() : super(priority: 1);

  void addPoint(Vector2 point) {
    _particles.add(
      RotateRectParticle(position: point.clone() + Vector2(-2, 0)),
    );
  }

  void reset() {
    _particles.clear();
    _time = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPro) {
      _time += dt;
    }

    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.age += dt;
      p.position.x -= Consts.pipeSpeed * dt;
      // Rotate 0 to 2pi over lifespan
      p.angle = (p.age / p.lifespan) * 2 * pi;

      if (p.age >= p.lifespan) {
        _particles.removeAt(i);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_particles.isEmpty) return;

    if (isPro) {
      _renderPro(canvas);
    } else {
      _renderStandard(canvas);
    }
  }

  void _renderPro(Canvas canvas) {
    final neonColors = [
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.limeAccent,
    ];

    double t = (_time * 1.0) % neonColors.length;
    int idx1 = t.floor();
    int idx2 = (idx1 + 1) % neonColors.length;
    double tBr = t - idx1;
    Color currentColor = Color.lerp(neonColors[idx1], neonColors[idx2], tBr)!;

    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final corePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    // Glow Pass
    for (final p in _particles) {
      double progress = p.age / p.lifespan;
      double size = 13 * (1 - progress);
      double alpha = (1 - progress).clamp(0.0, 1.0);

      glowPaint.color = currentColor.withValues(alpha: alpha * 0.5);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.rotate(p.angle);

      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size, height: size),
        glowPaint,
      );

      canvas.restore();
    }

    // Core Pass
    for (final p in _particles) {
      double progress = p.age / p.lifespan;
      double size = 13 * (1 - progress);
      double alpha = (1 - progress).clamp(0.0, 1.0);

      corePaint.color = Colors.white.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.rotate(p.angle);

      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size, height: size),
        corePaint,
      );

      canvas.restore();
    }
  }

  void _renderStandard(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Matching orange style
    Color color = Colors.white;

    for (final p in _particles) {
      double progress = p.age / p.lifespan;
      double size = 13 * (1 - progress);
      double alpha = (1 - progress).clamp(0.0, 1.0);

      paint.color = color.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.rotate(p.angle);

      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size, height: size),
        paint,
      );

      canvas.restore();
    }
  }
}
