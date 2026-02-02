import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../configs/const.dart';

class LightningParticle {
  Vector2 position;
  final Path path;
  double age;
  final double lifespan;

  LightningParticle({
    required this.position,
    required this.path,
    this.age = 0,
    this.lifespan = 0.5,
  });
}

class LightningTrail extends PositionComponent {
  final List<LightningParticle> _particles = [];
  bool isPro = false;
  double _time = 0;
  final Random _rnd = Random();

  LightningTrail() : super(priority: 1);

  void addPoint(Vector2 point) {
    final path = Path();
    double startX = 0;
    double startY = 0;
    path.moveTo(startX, startY);

    for (int i = 0; i < 3; i++) {
      startX -= 3 + _rnd.nextDouble() * 4;
      startY += (_rnd.nextBool() ? 1 : -1) * (2 + _rnd.nextDouble() * 6);
      path.lineTo(startX, startY);
    }

    _particles.add(
      LightningParticle(position: point.clone() + Vector2(-2, 0), path: path),
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
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    // Glow Pass
    for (final p in _particles) {
      double alpha = (1 - p.age / p.lifespan).clamp(0.0, 1.0);
      glowPaint.color = currentColor.withValues(alpha: alpha * 0.6);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.drawPath(p.path, glowPaint);
      canvas.restore();
    }

    // Core Pass
    for (final p in _particles) {
      double alpha = (1 - p.age / p.lifespan).clamp(0.0, 1.0);
      corePaint.color = Colors.white.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.drawPath(p.path, corePaint);
      canvas.restore();
    }
  }

  void _renderStandard(Canvas canvas) {
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.6);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    for (final p in _particles) {
      double alpha = (1 - p.age / p.lifespan).clamp(0.0, 1.0);

      glowPaint.color = Colors.white.withValues(alpha: alpha * 0.6);
      corePaint.color = Colors.white.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.drawPath(p.path, glowPaint);
      canvas.drawPath(p.path, corePaint);
      canvas.restore();
    }
  }
}
