import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game_trail.dart';
import '../../configs/const.dart';

class LineTrail extends PositionComponent implements GameTrail {
  final List<Vector2> _points = [];
  bool isPro = false;
  double opacity = 1.0;

  final Paint _layerPaint = Paint();

  final Paint _glowPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

  final Paint _corePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;

  final Paint _standardPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;

  LineTrail() : super(priority: 1);

  void addPoint(Vector2 point) {
    _points.add(point.clone());
  }

  void reset() => _points.clear();

  double _time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (isPro) {
      _time += dt;
    }
    // Move all points left
    for (var point in _points) {
      point.x -= Consts.pipeSpeed * dt;
    }

    // Limit trail length to shorten it
    if (_points.length > 25) {
      _points.removeRange(0, _points.length - 25);
    }
  }

  @override
  void render(Canvas canvas) {
    if (_points.isEmpty || _points.length < 2) return;

    if (opacity < 1.0) {
      _layerPaint.color = Colors.white.withAlpha((opacity * 255).toInt());
      canvas.saveLayer(null, _layerPaint);
    }

    if (isPro) {
      _renderPro(canvas);
    } else {
      _renderStandard(canvas);
    }

    if (opacity < 1.0) {
      canvas.restore();
    }
  }

  void _renderPro(Canvas canvas) {
    final neonColors = [
      Colors.cyanAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.limeAccent,
    ];

    // Smooth color interpolation
    // Speed factor 1.0 means 1 second per color transition
    double t = (_time * 1.0) % neonColors.length;
    int idx1 = t.floor();
    int idx2 = (idx1 + 1) % neonColors.length;
    double tBr = t - idx1;
    Color currentColor = Color.lerp(neonColors[idx1], neonColors[idx2], tBr)!;

    // Draw Glow Pass
    for (int i = 0; i < _points.length - 1; i++) {
      double opacity = (i / _points.length).clamp(0.0, 1.0);
      _glowPaint.color = currentColor.withValues(alpha: opacity * 0.8);
      canvas.drawLine(
        _points[i].toOffset(),
        _points[i + 1].toOffset(),
        _glowPaint,
      );
    }

    // Draw Core Pass
    for (int i = 0; i < _points.length - 1; i++) {
      double opacity = (i / _points.length).clamp(0.0, 1.0);
      _corePaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawLine(
        _points[i].toOffset(),
        _points[i + 1].toOffset(),
        _corePaint,
      );
    }
  }

  void _renderStandard(Canvas canvas) {
    for (int i = 0; i < _points.length - 1; i++) {
      double opacity = (i / _points.length).clamp(0.0, 1.0);
      _standardPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawLine(
        _points[i].toOffset(),
        _points[i + 1].toOffset(),
        _standardPaint,
      );
    }
  }
}
