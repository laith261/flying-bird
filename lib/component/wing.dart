import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:game/main.dart';

class Wing extends SpriteAnimationComponent
    with TapCallbacks, HasGameReference<MyWorld>, CollisionCallbacks {
  Wing() : super(size: Vector2(60*.4, 50*.4), anchor: Anchor.center, priority: 2);

  @override
  Future<void> onLoad() async {
    setPlayerPosition();
    List<Sprite> redBirdSprites = [
      await Sprite.load("bird/wing/1.png"),
      await Sprite.load("bird/wing/2.png"),
      await Sprite.load("bird/wing/3.png"),
    ];
    animation = SpriteAnimation.spriteList(redBirdSprites, stepTime: 0.2);

  }

  void setPlayerPosition() =>
      position = Vector2(60, game.size.y / 2 - size.y / 2);

  @override
  update(double dt) {
    position = game.player.position;
    angle = game.player.angle;
    super.update(dt);
  }
}
