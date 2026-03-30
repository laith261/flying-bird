import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:game/main.dart';

class Wing extends SpriteAnimationComponent
    with TapCallbacks, HasGameReference<MyWorld>, CollisionCallbacks {
  Wing() : super(size: Vector2(60*.5, 50*.5), anchor: Anchor.center, priority: 2);

  @override
  Future<void> onLoad() async {
    List<Sprite> redBirdSprites = [
      await Sprite.load("bird/wing/1.png"),
      await Sprite.load("bird/wing/2.png"),
      await Sprite.load("bird/wing/3.png"),
    ];
    animation = SpriteAnimation.spriteList(redBirdSprites, stepTime: 0.2);
  }


  @override
  update(double dt) {
    position = game.player.position+Vector2(-1,1);
    angle = game.player.angle;
    
    // Hide or show wing based on skin property
    opacity = game.player.skin.skin.hasWings ? 1 : 0;
    
    super.update(dt);
  }

}
