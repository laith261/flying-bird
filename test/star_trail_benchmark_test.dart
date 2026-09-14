import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/component/trailes/star.dart';
import 'package:flutter/material.dart';

class MockCanvas implements Canvas {
  @override
  void save() {}
  @override
  void restore() {}
  @override
  void translate(double dx, double dy) {}
  @override
  void rotate(double radians) {}
  @override
  void scale(double sx, [double? sy]) {}
  @override
  void drawPath(Path path, Paint paint) {}
  @override
  void saveLayer(Rect? bounds, Paint paint) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Benchmark StarTrail render', () {
    final canvas = MockCanvas();
    final starTrail = StarTrail();

    // Add 100 particles to simulate an active trail
    for (int i = 0; i < 100; i++) {
      starTrail.addPoint(Vector2(0, 0));
    }

    // Warmup
    for (int i = 0; i < 100; i++) {
      starTrail.render(canvas);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 10000; i++) {
      starTrail.render(canvas);
    }
    stopwatch.stop();
    print(
      'Optimized time for 10,000 StarTrail renders (100 particles each): ${stopwatch.elapsedMilliseconds} ms',
    );
  });
}
