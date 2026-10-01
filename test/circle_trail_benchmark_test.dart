import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/component/trailes/circle.dart';

void main() {
  test('CircleTrail render performance benchmark', () {
    final trail = CircleTrail();
    trail.isPro = true;

    // Add multiple particles
    for (int i = 0; i < 100; i++) {
      trail.addPoint(Vector2(i.toDouble(), i.toDouble()));
    }

    // Warmup
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    for (int i = 0; i < 1000; i++) {
      trail.update(0.016);
      trail.render(canvas);
    }

    // Measure
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 50000; i++) {
      trail.update(0.016);
      trail.render(canvas);
    }
    stopwatch.stop();

    print('CircleTrail benchmark (baseline): ${stopwatch.elapsedMilliseconds} ms');
  });
}
