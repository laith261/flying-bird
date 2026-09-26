import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:game/component/trailes/rotate_rect.dart';

void main() {
  test('Benchmark RotateRectTrail render method', () {
    final trail = RotateRectTrail();
    trail.isPro = true;
    trail.opacity = 0.5;

    // Add some particles
    for (int i = 0; i < 100; i++) {
      trail.addPoint(Vector2(i.toDouble(), i.toDouble()));
      trail.update(0.016); // Advance some time to get different ages
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Warm up
    for (int i = 0; i < 100; i++) {
      trail.render(canvas);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 10000; i++) {
      trail.render(canvas);
    }
    stopwatch.stop();

    print('Baseline time for 10000 renders of RotateRectTrail (isPro=true): ${stopwatch.elapsedMilliseconds} ms');

    trail.isPro = false;
    final stopwatch2 = Stopwatch()..start();
    for (int i = 0; i < 10000; i++) {
      trail.render(canvas);
    }
    stopwatch2.stop();
    print('Baseline time for 10000 renders of RotateRectTrail (isPro=false): ${stopwatch2.elapsedMilliseconds} ms');
  });
}
