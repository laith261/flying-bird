import 'dart:math';

import 'package:flame/components.dart';
import 'package:game/component/coin.dart';
import 'package:game/component/pipe.dart';

import '../configs/const.dart';
import '../main.dart';

class Pipes extends PositionComponent with HasGameReference<MyWorld> {
  Pipes();

  late int space = ((game.size.y - Consts.gap) / 4).toInt();
  late Sprite twoWayPipe;
  late Sprite pipePop;
  var isTwoWay = 0;
  late Sprite pipe;
  late double lastGapY = game.size.y / 2;

  @override
  Future<void> onLoad() async {
    await initSprite();
    addPipe(withCoin: false);
    return super.onLoad();
  }

  Future<void> addPipe({bool withCoin = true}) async {
    // Calculate position for Coin (between columns)
    double coinX = (Consts.pipeAddAt + game.size.x + 100) / 2;

    // Prepare pipe data
    bool isStandard = isTwoWay != 3;
    bool isUp = Random().nextBool();
    int spaceVal = getSize();

    // Calculate current gap Y based on pipe type
    double currentGapY;
    if (isStandard) {
      currentGapY = game.size.y / 2 + (isUp ? -spaceVal : spaceVal);
    } else {
      currentGapY = game.size.y / 2;
    }

    // Interpolate coinY
    double coinY = (lastGapY + currentGapY) / 2;

    // Update lastGapY for next pipe
    lastGapY = currentGapY;

    if (isStandard) {
      List<Component> components = [
        Pipe(true, isUp, spaceVal, pipePop, false),
        Pipe(false, isUp, spaceVal, pipe, false),
      ];

      if (withCoin &&
          (Random().nextDouble() < 0.3 || game.isLuckyDayActive.value)) {
        components.add(Coin(position: Vector2(coinX, coinY)));
      }

      addAll(components);
      isTwoWay += Random().nextBool() ? 1 : 0;
      return;
    }
    // For TwoWay pipe, the gap is in the middle
    add(Pipe(false, false, 0, twoWayPipe, true));
    if (withCoin &&
        (Random().nextDouble() < 0.3 || game.isLuckyDayActive.value)) {
      add(Coin(position: Vector2(coinX, coinY)));
    }
    isTwoWay = 0;
  }

  @override
  void update(double dt) {
    addPipeInGame();
    addPoint();
    super.update(dt);
  }

  void addPipeInGame() {
    if (lastChild<Pipe>() == null) return;
    if (lastChild<Pipe>()!.x > Consts.pipeAddAt) return;
    addPipe();
  }

  Future<void> initSprite() async {
    twoWayPipe = await Sprite.load("two_way_pipe.png");
    pipePop = await Sprite.load("pipe_top.png");
    pipe = await Sprite.load("pipe.png");
  }

  void addPoint() {
    if (firstChild<Pipe>() == null) return;
    if (firstChild<Pipe>()!.position.x > game.player.x) return;
    if (firstChild<Pipe>()!.gotPoint) return;
    firstChild<Pipe>()!.gotPoint = true;

    game.scorePoint++;
    game.updateScore();
  }

  void reset() {
    removeWhere((element) => element is Pipe || element is Coin);
    lastGapY = game.size.y / 2;
    addPipe(withCoin: false);
  }

  int getSize() => Random().nextInt(space);
}
