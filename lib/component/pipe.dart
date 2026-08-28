import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/main.dart';

import '../configs/const.dart';

class Pipe extends SpriteComponent with HasGameReference<MyWorld> {
  Pipe(this.isTop, this.isUp, this.space, this.image, this.isTwoWay)
    : super(size: Vector2(50, 350), anchor: Anchor.center, sprite: image);

  // class variables
  late double upBarer = ((game.size.y / 4) / 2);
  late double downBarer = game.size.y - upBarer;
  late bool movingUp = Random().nextBool();
  bool gotPoint = false;
  double yPosition = 0;
  double halfSize = 0;

  // class properties
  final bool isTwoWay;
  final Sprite image;
  final bool isTop;
  final bool isUp;
  final int space;

  @override
  Future<void> onLoad() async {
    doublePipe();
    twoWayPipe();
    add(RectangleHitbox());
  }

  void doublePipe() {
    if (isTwoWay) return;
    size.y = (game.size.y / 2) - Consts.gap;
    if (isUp) {
      size.y = isTop ? size.y - space : size.y + space;
    } else {
      size.y = isTop ? size.y + space : size.y - space;
    }
    halfSize = size.y / 2;
    yPosition = isTop ? halfSize : game.size.y - halfSize;
    position = Vector2(game.size.x + 100, yPosition);
    add(RectangleHitbox());
  }

  void goLeft(double dt) {
    if (!game.isStarted) return;
    x -= Consts.pipeSpeed * dt;
  }

  void removePipe() {
    if ((x + size.x) > 0) return;
    removeFromParent();
  }

  @override
  update(double dt) {
    goLeft(dt);
    upAndDown(dt);
    removePipe();
  }

  void twoWayPipe() {
    if (!isTwoWay) return;
    size.y = game.size.y / 2;
    yPosition = game.size.y / 2;
    position = Vector2(game.size.x + 100, yPosition);
  }

  void upAndDown(double dt) {
    if (!isTwoWay || !game.isStarted) return;
    y = movingUp
        ? (y - (Consts.pipeMoveSpeed * dt))
        : (y + (Consts.pipeMoveSpeed * dt));
    var upPosition = y - (size.y / 2);
    var downPosition = y + (size.y / 2);
    if (upPosition <= upBarer || downPosition >= downBarer) {
      movingUp = !movingUp;
    }
  }
}
