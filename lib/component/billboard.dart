import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/main.dart';

enum BillboardState {
  movingToCenter,
  stoppedAtCenter,
  movingToLeft,
  waitingInterval,
}

/// Represents the background billboard component positioned between the city and bushes.
/// Handles timed horizontal movement and interval loops.
class Billboard extends SpriteComponent with HasGameReference<MyWorld> {
  Billboard() : super(priority: 0);

  BillboardState _state = BillboardState.movingToCenter;
  double _moveTimer = 0.0;
  double _stopTimer = 0.0;
  double _moveLeftTimer = 0.0;
  double _intervalTimer = 0.0;

  late double _startX;
  late double _centerX;
  late double _endX;
  late double _leftStartX;

  bool isAdLoaded = false;
  final ValueNotifier<Rect?> widgetRectNotifier = ValueNotifier<Rect?>(null);

  @override
  Future<void> onLoad() async {
    try {
      final loadedSprite = await Sprite.load("billboard.png");
      sprite = loadedSprite;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading billboard sprite: $e");
      }
    }

    _updateSize();
    anchor = Anchor.center;
    _initializePositions();
    position = Vector2(_startX, game.size.y * 0.70);
    _state = BillboardState.movingToCenter;
    _updateWidgetRect();
  }

  /// Updates the size to 0.5 of the screen width while preserving aspect ratio.
  void _updateSize() {
    double targetWidth = game.size.x * 0.5;
    if (sprite != null && sprite!.srcSize.y > 0) {
      double aspectRatio = sprite!.srcSize.x / sprite!.srcSize.y;
      size = Vector2(targetWidth, targetWidth / aspectRatio);
    } else {
      size = Vector2(targetWidth, targetWidth);
    }
  }

  /// Calculates boundary positions based on the current game dimensions.
  void _initializePositions() {
    _startX = game.size.x + (size.x / 2);
    _centerX = game.size.x / 2;
    _endX = -(size.x / 2);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) {
      _updateSize();
      _initializePositions();
      y = game.size.y * 0.70;
      if (_state == BillboardState.stoppedAtCenter) {
        x = _centerX;
      } else if (_state == BillboardState.waitingInterval) {
        x = _endX;
      }
      _updateWidgetRect();
    }
  }

  @override
  void update(double dt) {
    if (!game.isStarted || !isAdLoaded) {
      _updateWidgetRect();
      return;
    }
    super.update(dt);

    switch (_state) {
      case BillboardState.movingToCenter:
        _moveTimer += dt;
        if (_moveTimer >= 3.0) {
          x = _centerX;
          _state = BillboardState.stoppedAtCenter;
          _stopTimer = 0.0;
        } else {
          double progress = _moveTimer / 3.0;
          x = _startX - (_startX - _centerX) * progress;
        }
        break;

      case BillboardState.stoppedAtCenter:
        _stopTimer += dt;
        if (_stopTimer >= 15.0) {
          _state = BillboardState.movingToLeft;
          _moveLeftTimer = 0.0;
          _leftStartX = x;
        }
        break;

      case BillboardState.movingToLeft:
        _moveLeftTimer += dt;
        if (_moveLeftTimer >= 3.0) {
          x = _endX;
          _state = BillboardState.waitingInterval;
          _intervalTimer = 0.0;
        } else {
          double progress = _moveLeftTimer / 3.0;
          x = _leftStartX - (_leftStartX - _endX) * progress;
        }
        break;

      case BillboardState.waitingInterval:
        _intervalTimer += dt;
        if (_intervalTimer >= 60.0) {
          reset();
        }
        break;
    }

    _updateWidgetRect();
  }

  /// Resets movement variables to start a new animation cycle from the right edge.
  void reset() {
    _state = BillboardState.movingToCenter;
    _moveTimer = 0.0;
    _stopTimer = 0.0;
    _moveLeftTimer = 0.0;
    _intervalTimer = 0.0;
    x = _startX;
    _updateWidgetRect();
  }

  /// Updates the rectangle bounds for the Flutter overlay widget
  /// to match the board face of the billboard sprite.
  void _updateWidgetRect() {
    double spriteLeft = x - (size.x / 2);
    double spriteTop = y - (size.y / 2);

    double boardLeft = spriteLeft + (size.x * 0.04);
    double boardTop = spriteTop + (size.y * 0.03);
    double boardWidth = size.x * 0.92;
    double boardHeight = size.y * 0.52;

    widgetRectNotifier.value = Rect.fromLTWH(
      boardLeft,
      boardTop,
      boardWidth,
      boardHeight,
    );
  }
}
