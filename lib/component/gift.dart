import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import 'package:game/main.dart';
import '../configs/const.dart';

class Gift extends SpriteComponent with HasGameReference<MyWorld> {
  Gift({super.position}) : super(size: Vector2.all(50), anchor: Anchor.center);

  double _timer = 0.0;

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('gift.png');
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!game.isStarted) return;

    // Move gift
    x -= Consts.pipeSpeed * dt;
    if (x < -100) removeFromParent();

    // Rotate gift slightly (visual effect)
    if (!_collected) {
      _timer += dt;
      angle = sin(_timer * 3) * 0.1; // Gentle rocking
    }

    super.update(dt);
  }

  bool _collected = false;

  bool collect() {
    if (_collected) return false;
    _collected = true;

    final random = Random();
    final particles = ParticleSystemComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 1.0,
        generator: (i) {
          final color = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple][random.nextInt(5)];
          return AcceleratedParticle(
            acceleration: Vector2(0, 400),
            speed: Vector2(
              random.nextDouble() * 300 - 150,
              random.nextDouble() * -300 - 100,
            ),
            position: absolutePosition.clone(),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final paint = Paint()..color = color.withOpacity(1 - particle.progress);
                canvas.drawRect(Rect.fromLTWH(-4, -4, 8, 8), paint);
              },
            ),
          );
        },
      ),
    );
    game.add(particles);

    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.5),
        onComplete: () => removeFromParent(),
      ),
    );
    add(OpacityEffect.fadeOut(EffectController(duration: 0.5)));
    return true;
  }
}
