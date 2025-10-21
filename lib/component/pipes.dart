import 'dart:math';

import 'package:flame/components.dart';
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

  @override
  Future<void> onLoad() async {
    await initSprite();
    addPipe();
    return super.onLoad();
  }

  Future<void> addPipe() async {
    if (isTwoWay != 3) {
      var isUp = Random().nextBool();
      var space = getSize();
      addAll([
        Pipe(true, isUp, space, pipePop, false),
        Pipe(false, isUp, space, pipe, false),
      ]);
      isTwoWay += Random().nextBool() ? 1 : 0;
      return;
    }
    add(Pipe(false, false, 0, twoWayPipe, true));
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
    game.audio.playPoint();
    game.scorePoint++;
    game.updateScore();
  }

  void reset() {
    removeWhere((element) => element is Pipe);
    addPipe();
  }

  int getSize() => Random().nextInt(space);
}
