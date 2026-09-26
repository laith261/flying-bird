import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_trail.dart';
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

class LightningTrail extends PositionComponent implements GameTrail {
  final List<LightningParticle> _particles = [];
  bool isPro = false;
  double _time = 0;
  final Random _rnd = Random();
  double opacity = 1.0;

  final Paint _proGlowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

  final Paint _proCorePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;

  final Paint _standardGlowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round
    ..color = Colors.white.withValues(alpha: 0.6);

  final Paint _standardCorePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;

  final Paint _layerPaint = Paint();

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

    if (opacity < 1.0) {
      _layerPaint.color = Colors.white.withAlpha((opacity * 255).toInt());
      canvas.saveLayer(null, _layerPaint);
    }

    if (isPro) {
      _renderPro(canvas);
    } else {
      _renderStandard(canvas);
    }

    if (opacity < 1.0) {
      canvas.restore();
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

    // Glow Pass
    for (final p in _particles) {
      double alpha = (1 - p.age / p.lifespan).clamp(0.0, 1.0);
      _proGlowPaint.color = currentColor.withValues(alpha: alpha * 0.6);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.drawPath(p.path, _proGlowPaint);
      canvas.restore();
    }

    // Core Pass
    for (final p in _particles) {
      double alpha = (1 - p.age / p.lifespan).clamp(0.0, 1.0);
      _proCorePaint.color = Colors.white.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.drawPath(p.path, _proCorePaint);
      canvas.restore();
    }
  }

  void _renderStandard(Canvas canvas) {
    for (final p in _particles) {
      double alpha = (1 - p.age / p.lifespan).clamp(0.0, 1.0);

      _standardGlowPaint.color = Colors.white.withValues(alpha: alpha * 0.6);
      _standardCorePaint.color = Colors.white.withValues(alpha: alpha);

      canvas.save();
      canvas.translate(p.position.x, p.position.y);
      canvas.drawPath(p.path, _standardGlowPaint);
      canvas.drawPath(p.path, _standardCorePaint);
      canvas.restore();
    }
  }
}
