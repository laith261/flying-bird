import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/animation.dart';
import 'package:game/component/pipe.dart';
import 'package:game/main.dart';

import '../configs/const.dart';

class Player extends SpriteComponent
    with TapCallbacks, HasGameReference<MyWorld>, CollisionCallbacks {
  Player() : super(size: Vector2(46, 29), anchor: Anchor.center, priority: 2);

  final Vector2 gravity = Vector2(0, Consts.gravity);
  final Vector2 jump = Vector2(0, Consts.jump);
  Vector2 velocity = Vector2.zero();
  double targetAngle = 0.0;

  @override
  Future<void> onLoad() async {
    setPlayerPosition();
    sprite = await game.loadSprite("bird.png");
    add(CircleHitbox());
  }

  void setPlayerPosition() =>
      position = Vector2(50, game.size.y / 2 - size.y / 2);

  void goDown(double dt) {
    if (!game.isStarted) return;

    velocity += gravity * dt;
    position += velocity;
    gameOver();
    if (velocity.y < 2) return;
    rotate((tau / 13));
  }

  Future<void> goUp() async {
    if (!game.isStarted) return;

    game.audio.playFly();
    velocity = jump;
    await rotate(-(tau / 13));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (game.isStarted && other is Pipe) {
      game.gameOver();
    }
  }

  Future<void> rotate(double theAngle) async {
    if (theAngle == targetAngle) return;

    targetAngle = theAngle;
    var effect = RotateEffect.to(
      theAngle,
      EffectController(duration: 0.1, curve: Curves.linear),
    );
    await add(effect);
  }

  void gameOver() {
    if (game.isStarted && (y > game.size.y || y < 0)) {
      game.gameOver();
    }
  }

  void reset() {
    velocity = Vector2.zero();
    rotate(0.0);
    setPlayerPosition();
  }

  @override
  update(double dt) {
    goDown(dt);
    super.update(dt);
  }
}
