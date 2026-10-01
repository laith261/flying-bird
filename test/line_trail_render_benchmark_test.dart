import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'package:game/component/trailes/line.dart';

void main() {
  test('LineTrail render benchmark', () {
    print(
      'Testing performance of LineTrail render (Paint object allocation overhead)',
    );

    final trail = LineTrail();
    trail.isPro = true;
    for (int i = 0; i < 25; i++) {
      trail.addPoint(Vector2(i.toDouble(), i.toDouble()));
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Warm up
    for (int i = 0; i < 1000; i++) {
      trail.render(canvas);
    }

    // Benchmark
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      trail.render(canvas);
    }
    stopwatch.stop();
    print(
      'LineTrail render (100,000 iterations): ${stopwatch.elapsedMilliseconds} ms',
    );
  });
}
