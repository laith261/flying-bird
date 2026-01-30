import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:game/main.dart';
import '../configs/const.dart';

class Coin extends SpriteComponent with HasGameReference<MyWorld> {
  Coin({super.position}) : super(size: Vector2.all(25), anchor: Anchor.center);

  double _timer = 0.0;

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('coin_no_bg.png');
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!game.isStarted) return;

    // Move coin
    x -= Consts.pipeSpeed * dt;
    if (x < -100) removeFromParent();

    // Rotate coin (visual effect)
    if (!_collected) {
      _timer += dt;
      scale.x = cos(_timer * 3); // 3 is rotation speed
    }

    super.update(dt);
  }

  bool _collected = false;

  bool collect() {
    if (_collected) return false;
    _collected = true;

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
