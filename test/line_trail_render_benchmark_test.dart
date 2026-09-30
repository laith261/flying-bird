import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'package:game/component/trailes/line.dart';

void main() {
  test('LineTrail render benchmark', () {
    final trail = LineTrail();
    for (int i = 0; i < 25; i++) {
      trail.addPoint(Vector2(i.toDouble(), i.toDouble()));
    }
    trail.opacity = 0.5;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Warm up
    for (int i = 0; i < 1000; i++) {
      trail.render(canvas);
      trail.isPro = true;
      trail.render(canvas);
      trail.isPro = false;
    }

    // Benchmark standard
    final standardStopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      trail.render(canvas);
    }
    standardStopwatch.stop();

    // Benchmark pro
    trail.isPro = true;
    final proStopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      trail.render(canvas);
    }
    proStopwatch.stop();

    print('LineTrail standard render: ${standardStopwatch.elapsedMilliseconds} ms / ${standardStopwatch.elapsedMicroseconds} us');
    print('LineTrail pro render: ${proStopwatch.elapsedMilliseconds} ms / ${proStopwatch.elapsedMicroseconds} us');
  });
}
