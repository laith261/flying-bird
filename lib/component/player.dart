import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:game/component/coin.dart';
import 'package:game/component/pipe.dart';
import 'package:game/component/trailes/circle.dart';
import 'package:game/component/trailes/line.dart';
import 'package:game/component/trailes/lightning.dart';
import 'package:game/component/trailes/rotate_rect.dart';
import 'package:game/component/trailes/star.dart';

import 'package:game/main.dart';

import '../configs/const.dart';

class Player extends SpriteAnimationComponent
    with TapCallbacks, HasGameReference<MyWorld>, CollisionCallbacks {
  Player() : super(size: Vector2(46, 29), anchor: Anchor.center, priority: 2);

  final Vector2 gravity = Vector2(0, Consts.gravity);
  final Vector2 jump = Vector2(0, Consts.jump);
  Vector2 velocity = Vector2.zero();

  final LineTrail _lineTrail = LineTrail();
  final CircleTrail _circleTrail = CircleTrail();
  final RotateRectTrail _rotateRectTrail = RotateRectTrail();
  final StarTrail _starTrail = StarTrail();
  final LightningTrail _lightningTrail = LightningTrail();

  String _selectedTrail = 'none';
  double _trailTimer = 0;
  final double _trailInterval = 0.05;

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

    // Add all trails to game
    game.add(_lineTrail);
    game.add(_circleTrail);
    game.add(_rotateRectTrail);
    game.add(_starTrail);
    game.add(_lightningTrail);

    // Load saved trail
    _selectedTrail = game.playerData.selectedTrail;
    _updateTrailConfig(_selectedTrail);
  }

  void updateTrail(String trailId) {
    _selectedTrail = trailId;
    _resetAllTrails();
    _updateTrailConfig(trailId);
  }

  void _updateTrailConfig(String trailId) {
    bool isPro = trailId.endsWith('_pro');
    if (trailId.startsWith('line')) _lineTrail.isPro = isPro;
    if (trailId.startsWith('circle')) _circleTrail.isPro = isPro;
    if (trailId.startsWith('rect')) _rotateRectTrail.isPro = isPro;
    if (trailId.startsWith('star')) _starTrail.isPro = isPro;
    if (trailId.startsWith('lightning')) _lightningTrail.isPro = isPro;
  }

  void _resetAllTrails() {
    _lineTrail.reset();
    _circleTrail.reset();
    _rotateRectTrail.reset();
    _starTrail.reset();
    _lightningTrail.reset();
  }

  void setPlayerPosition() =>
      position = Vector2(60, game.size.y / 2 - size.y / 2);

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
    if (!game.isStarted) return;

    if (other is Pipe) {
      game.gameOver();
    } else if (other is Coin) {
      if (other.collect()) {
        game.scorePoint++;
        game.updateScore();
        game.audio.playPoint();
        game.playerData.addCoins(1);
        game.coins.value = game.playerData.coins;
      }
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
    _resetAllTrails();
  }

  @override
  update(double dt) {
    goDown(dt);

    if (game.isStarted && _selectedTrail != 'none') {
      if (_selectedTrail.startsWith('line')) {
        _lineTrail.addPoint(position.clone() + Vector2(-2, 0));
      } else {
        _trailTimer += dt;
        if (_trailTimer >= _trailInterval) {
          _trailTimer = 0;
          String baseTrail = _selectedTrail.endsWith('_pro')
              ? _selectedTrail.substring(0, _selectedTrail.length - 4)
              : _selectedTrail;

          switch (baseTrail) {
            case 'circle':
              _circleTrail.addPoint(position);
              break;
            case 'rect':
              _rotateRectTrail.addPoint(position);
              break;
            case 'star':
              _starTrail.addPoint(position);
              break;
            case 'lightning':
              _lightningTrail.addPoint(position);
              break;
          }
        }
      }
    }

    super.update(dt);
  }
}
