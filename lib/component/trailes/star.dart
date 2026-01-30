import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../configs/const.dart';

class StarParticle {
  Vector2 position;
  Vector2 velocity;
  double age;
  final double lifespan;
  double size;
  double rotation;
  double rotationSpeed;

  StarParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    this.age = 0,
    this.lifespan = 1.0,
  });
}

class StarTrail extends PositionComponent {
  final List<StarParticle> _particles = [];
  bool isPro = false;
  double _time = 0;
  final Random _rnd = Random();

  StarTrail() : super(priority: 1);

  void addPoint(Vector2 point) {
    // Generate star params similar to old logic
    double size = _rnd.nextDouble() * 15 + 10;
    double rotationSpeed = (_rnd.nextDouble() - 0.5) * 4;
    double lifespan = 0.5 + _rnd.nextDouble() * 0.5;

    Vector2 basePos =
        point.clone() + Vector2(0, (_rnd.nextDouble() - 0.5) * 10); // Jitter
    Vector2 velocity = Vector2(
      -Consts.pipeSpeed * (0.8 + _rnd.nextDouble() * 0.4),
      (_rnd.nextDouble() - 0.5) * 50,
    );

    _particles.add(
      StarParticle(
        position: basePos,
        velocity: velocity,
        size: size,
        rotation: 0,
        rotationSpeed: rotationSpeed,
        lifespan: lifespan,
      ),
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
      p.position += p.velocity * dt;
      p.rotation += p.rotationSpeed * dt;

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
      _drawStar(canvas, p, glowPaint, currentColor, isGlow: true);
    }

    // Core Pass
    for (final p in _particles) {
      _drawStar(canvas, p, corePaint, Colors.white, isGlow: false);
    }
  }

  void _renderStandard(Canvas canvas) {
    // Matching orange/amber style
    // Old code: isPro ? white/amber mixed : Colors.white (actually code said Colors.white but in shop it was distinct)
    // Let's use Orange for standard to look "Fire-y"
    final paint = Paint()..style = PaintingStyle.fill;
    _particles.forEach((p) {
      _drawStar(canvas, p, paint, Colors.orange);
    });
  }

  void _drawStar(
    Canvas canvas,
    StarParticle p,
    Paint paint,
    Color baseColor, {
    bool isGlow = false,
  }) {
    double progress = p.age / p.lifespan;
    double currentSize = p.size * (1 - progress);
    double alpha = (1 - progress).clamp(0.0, 1.0);

    if (isGlow) {
      paint.color = baseColor.withValues(alpha: alpha * 0.6);
    } else {
      paint.color = baseColor.withValues(alpha: alpha);
    }

    final path = Path();
    double angle = -pi / 2;
    final double step = pi / 5;
    final double outerRadius = currentSize / 2;
    final double innerRadius = currentSize / 4;

    path.moveTo(outerRadius * cos(angle), outerRadius * sin(angle));
    for (int i = 0; i < 5; i++) {
      angle += step;
      path.lineTo(innerRadius * cos(angle), innerRadius * sin(angle));
      angle += step;
      path.lineTo(outerRadius * cos(angle), outerRadius * sin(angle));
    }
    path.close();

    canvas.save();
    canvas.translate(p.position.x, p.position.y);
    canvas.rotate(p.rotation);
    canvas.drawPath(path, paint);
    canvas.restore();
  }
}
