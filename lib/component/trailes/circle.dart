import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../configs/const.dart';

class CircleParticle {
  Vector2 position;
  double age;
  final double lifespan;

  CircleParticle({required this.position, this.age = 0, this.lifespan = 0.5});
}

class CircleTrail extends PositionComponent {
  final List<CircleParticle> _particles = [];
  bool isPro = false;
  double _time = 0;

  CircleTrail() : super(priority: 1);

  void addPoint(Vector2 point) {
    _particles.add(CircleParticle(position: point.clone() + Vector2(-2, 0)));
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

    // Update particles
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.age += dt;
      p.position.x -= Consts.pipeSpeed * dt;

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

    // Smooth color interpolation
    double t = (_time * 1.0) % neonColors.length;
    int idx1 = t.floor();
    int idx2 = (idx1 + 1) % neonColors.length;
    double tBr = t - idx1;
    Color currentColor = Color.lerp(neonColors[idx1], neonColors[idx2], tBr)!;

    // Paints
    final glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final corePaint = Paint()..style = PaintingStyle.fill;

    // Batch 1: Glows
    for (final p in _particles) {
      double progress = p.age / p.lifespan;
      double alpha = (1 - progress).clamp(0.0, 1.0);

      glowPaint.color = currentColor.withValues(alpha: alpha * 0.5);

      // Draw Center only
      canvas.drawCircle(
        p.position.toOffset(),
        (10 * (1 - progress)) + 4,
        glowPaint,
      );
    }

    // Batch 2: Cores
    corePaint.color = Colors.white;
    for (final p in _particles) {
      double progress = p.age / p.lifespan;
      double alpha = (1 - progress).clamp(0.0, 1.0);

      corePaint.color = Colors.white.withValues(alpha: alpha);

      // Draw Center only
      canvas.drawCircle(p.position.toOffset(), 10 * (1 - progress), corePaint);
    }
  }

  void _renderStandard(Canvas canvas) {
    final paint = Paint()..style = PaintingStyle.fill;
    final colors = [Colors.white, Colors.white, Colors.white];

    for (final p in _particles) {
      double progress = p.age / p.lifespan;

      // Draw 1 circle (Center)
      paint.color = colors[1].withValues(alpha: (1 - progress) * 0.8);
      canvas.drawCircle(p.position.toOffset(), 10 * (1 - progress), paint);
    }
  }
}
