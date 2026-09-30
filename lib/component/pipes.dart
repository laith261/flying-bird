import 'dart:math';

import 'package:flame/components.dart';
import 'package:game/component/coin.dart';
import 'package:game/component/gift.dart';
import 'package:game/component/pipe.dart';

import '../configs/const.dart';
import '../main.dart';
import 'helpers/ghost_helper.dart';

class Pipes extends PositionComponent with HasGameReference<MyWorld> {
  Pipes();

  late int space = ((game.size.y - Consts.gap) / 4).toInt();
  late Sprite twoWayPipe;
  late Sprite pipePop;
  var isTwoWay = 0;
  late Sprite pipe;
  late double lastGapY = game.size.y / 2;
  int pipeSpawnCount = 0;

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

    double coinY = (lastGapY + currentGapY) / 2;

    lastGapY = currentGapY;

    final item = _createItem(coinX, coinY, withCoin);

    if (isStandard) {
      List<Component> components = [
        Pipe(true, isUp, spaceVal, pipePop, false),
        Pipe(false, isUp, spaceVal, pipe, false),
      ];

      if (item != null) {
        components.add(item);
      }

      addAll(components);
      isTwoWay += Random().nextBool() ? 1 : 0;

      return;
    }
    // For TwoWay pipe, the gap is in the middle
    add(Pipe(false, false, 0, twoWayPipe, true));
    if (item != null) {
      add(item);
    }
    isTwoWay = 0;
  }

  Component? _createItem(double coinX, double coinY, bool withCoin) {
    if (!withCoin) return null;
    pipeSpawnCount++;
    final bool isEvery10thPipe = (pipeSpawnCount % 10 == 0);
    final double giftChance = game.playerData.giftChance / 100.0;

    if (isEvery10thPipe && Random().nextDouble() < giftChance) {
      game.playerData.incrementGiftChance();

      return Gift(position: Vector2(coinX, coinY));
    } else if (Random().nextDouble() < 0.3 || game.isLuckyDayActive.value) {
      return Coin(position: Vector2(coinX, coinY));
    }

    return null;
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
    final sprites = await Future.wait([
      Sprite.load("two_way_pipe.png"),
      Sprite.load("pipe_top.png"),
      Sprite.load("pipe.png"),
    ]);
    twoWayPipe = sprites[0];
    pipePop = sprites[1];
    pipe = sprites[2];
  }

  void addPoint() {
    if (firstChild<Pipe>() == null) return;
    if (firstChild<Pipe>()!.position.x > game.player.x) return;
    if (firstChild<Pipe>()!.gotPoint) return;
    firstChild<Pipe>()!.gotPoint = true;

    game.scorePoint++;
    game.updateScore();

    // Ghost Skin Ability: 1/10 chance when passing a pipe
    if (game.player.skin.skin.isGhost &&
        !game.player.isGhostMode &&
        !game.player.isInvincible) {
      if (Random().nextInt(7) == 0) {
        GhostHelper.activateGhostMode(game.player);
      }
    }
  }

  void reset() {
    pipeSpawnCount = 0;
    removeWhere((element) => element is Pipe);
    lastGapY = game.size.y / 2;
    addPipe(withCoin: false);
  }

  int getSize() => Random().nextInt(space);
}
