import 'dart:math';
import 'package:flutter/material.dart';
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
import 'skins/skin_enum.dart';
import 'helpers/collision_helper.dart';
import 'helpers/glow_helper.dart';
import 'helpers/shield_helper.dart';
import 'trailes/game_trail.dart';

class TheBird extends SpriteComponent
    with TapCallbacks, HasGameReference<MyWorld>, CollisionCallbacks {
  TheBird()
    : super(
        size: Vector2(150 * .45, 90 * .45),
        anchor: Anchor.center,
        priority: 2,
      );

  final Vector2 gravity = Vector2(0, Consts.gravity);
  final Vector2 jump = Vector2(0, Consts.jump);
  Vector2 velocity = Vector2.zero();
  Skins skin = Skins.bird;

  final LineTrail _lineTrail = LineTrail();
  final CircleTrail _circleTrail = CircleTrail();
  final RotateRectTrail _rotateRectTrail = RotateRectTrail();
  final StarTrail _starTrail = StarTrail();
  final LightningTrail _lightningTrail = LightningTrail();
  late final Map<String, GameTrail> _trails = {
    'line': _lineTrail,
    'circle': _circleTrail,
    'rect': _rotateRectTrail,
    'star': _starTrail,
    'lightning': _lightningTrail,
  };

  String _selectedTrail = 'none';
  double _trailTimer = 0;
  final double _trailInterval = 0.05;
  bool isInvincible = false;
  bool hasActiveShield = false;
  bool isGhostMode = false;

  @override
  Future<void> onLoad() async {
    setPlayerPosition();
    sprite = skin.sprite;
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

  Future<void> updateSkin(Skins newSkin) async {
    skin = newSkin;
    sprite = skin.sprite;
  }

  void _updateTrailConfig(String trailId) {
    bool isPro = trailId.endsWith('_pro');
    String baseKey = trailId.endsWith('_pro')
        ? trailId.substring(0, trailId.length - 4)
        : trailId;
    _trails[baseKey]?.isPro = isPro;
  }

  void _resetAllTrails() {
    for (var trail in _trails.values) {
      trail.reset();
    }
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
      if (CollisionHelper.handlePipeCollision(this, other)) {
        game.gameOver();
      }
    } else if (other is Coin) {
      if (other.collect()) {
        game.audio.playPoint();
        game.playerData.runBatched([() => game.playerData.addCoins(1)]);
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
    isInvincible = false;
    // hasActiveShield = false; // Logic handled in startGame
  }

  @override
  void render(Canvas canvas) {
    // Check if we should render (visibility toggle for flashing)
    bool isVisible = true;
    if (isInvincible) {
      isVisible =
          (DateTime.now().millisecondsSinceEpoch / 100).floor() % 2 == 0;
    }

    if (!isVisible) return; // Don't render anything if flashing invisible

    bool showShield =
        (hasActiveShield ||
            (!game.isStarted &&
                game.isShieldEnabled &&
                game.playerData.shields > 0)) &&
        !isInvincible;

    if (showShield) {
      ShieldHelper.drawShield(canvas, this, angle);
    } else if (isInvincible) {
      // No orbiting effect during flash as requested
    }

    if (isGhostMode && !isInvincible) {
      GlowHelper.drawGlow(canvas, this);
    }
    super.render(canvas); // Draw bird on top
    if (isGhostMode && !isInvincible) {
      canvas.restore();
    }
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

          _trails[baseTrail]?.addPoint(position);
        }
      }
    }

    skin.skin.ability(this, dt);

    // Update trails opacity using collection loop
    double targetOpacity = isGhostMode ? 0.6 : 1.0;
    for (var trail in _trails.values) {
      trail.opacity = targetOpacity;
    }

    super.update(dt);
  }
}
