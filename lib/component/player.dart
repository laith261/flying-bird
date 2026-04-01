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
      canvas.save();
      // Counter-rotate the shield around the center of the bird
      canvas.translate(width / 2, height / 2);
      canvas.rotate(-angle);
      canvas.translate(-width / 2, -height / 2);

      // Enhanced "Orbiting Plasma" Shield with Trails
      double time = DateTime.now().millisecondsSinceEpoch / 1000;
      double orbitRadius = width * 0.75;

      // Draw subtle rotating energy ring
      final ringPaint = Paint()
        ..color = Colors.cyan.withAlpha(38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      // Rotate the ring slowly opposite to satellites
      canvas.save();
      canvas.translate(width / 2, height / 2);
      canvas.rotate(-time * 0.5);
      // Draw a dashed ring (simulated by drawing arcs or just a circle for now)
      canvas.drawCircle(Offset.zero, orbitRadius, ringPaint);
      canvas.restore();

      // Draw 3 orbiting satellites with trails
      for (int i = 0; i < 3; i++) {
        double angleVal = (time * 2.5) + (i * (2 * pi / 3));

        // Draw Trail (multiple smaller circles fading out)
        for (int j = 1; j <= 5; j++) {
          double trailAngle = angleVal - (j * 0.15); // Lag behind
          double trailX = (width / 2) + orbitRadius * cos(trailAngle);
          double trailY = (height / 2) + orbitRadius * sin(trailAngle);

          canvas.drawCircle(
            Offset(trailX, trailY),
            4.0 - (j * 0.6), // Shrinking size
            Paint()
              ..color = Colors.cyanAccent.withAlpha(
                ((0.5 - (j * 0.08)) * 255).toInt(),
              ),
          );
        }

        // Main Satellite
        double satelliteX = (width / 2) + orbitRadius * cos(angleVal);
        double satelliteY = (height / 2) + orbitRadius * sin(angleVal);

        canvas.drawCircle(
          Offset(satelliteX, satelliteY),
          5,
          Paint()
            ..color = Colors.white
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
      canvas.restore(); // Restore counter-rotation
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

    skin.skin.ability(this, dt);

    // Update trails opacity
    double targetOpacity = isGhostMode ? 0.6 : 1.0;
    _lineTrail.opacity = targetOpacity;
    _circleTrail.opacity = targetOpacity;
    _rotateRectTrail.opacity = targetOpacity;
    _starTrail.opacity = targetOpacity;
    _lightningTrail.opacity = targetOpacity;

    super.update(dt);
  }
}
