import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:game/component/pipe.dart';
import 'package:game/main.dart';

import '../configs/const.dart';

class Player extends SpriteAnimationComponent
    with TapCallbacks, HasGameReference<MyWorld>, CollisionCallbacks {
  Player() : super(size: Vector2(46, 29), anchor: Anchor.center, priority: 2);

  final Vector2 gravity = Vector2(0, Consts.gravity);
  final Vector2 jump = Vector2(0, Consts.jump);
  Vector2 velocity = Vector2.zero();

  @override
  Future<void> onLoad() async {
    setPlayerPosition();
    List<Sprite> redBirdSprites = [
      await Sprite.load("bird/1.png"),
      await Sprite.load("bird/2.png"),
      await Sprite.load("bird/3.png"),
    ];
    animation = SpriteAnimation.spriteList(redBirdSprites, stepTime: 0.2);
    add(CircleHitbox());
  }

  void setPlayerPosition() =>
      position = Vector2(50, game.size.y / 2 - size.y / 2);

  void goDown(double dt) {
    if (!game.isStarted) return;

    velocity += gravity * dt;
    position += velocity;
    gameOver();
    if ((angle * 180) / pi > 45) return;
    rotate();
  }

  Future<void> goUp() async {
    if (!game.isStarted) return;

    game.audio.playFly();
    velocity = jump;
    rotate();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (game.isStarted && other is Pipe) {
      game.gameOver();
    }
  }

  rotate() => angle = (velocity.y * 10) * pi / 180;

  void gameOver() {
    if (game.isStarted && (y > game.size.y || y < 0)) {
      game.gameOver();
    }
  }

  void reset() {
    velocity = Vector2.zero();
    rotate();
    setPlayerPosition();
  }

  @override
  update(double dt) {
    goDown(dt);
    super.update(dt);
  }
}
