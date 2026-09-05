import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:game/component/trailes/line.dart';

void main() {
  test('LineTrail points removal benchmark', () {
    print('Testing performance of LineTrail update for massive points');

    final trail1 = LineTrail();
    // Warm up
    for (int i = 0; i < 1000; i++) {
      trail1.addPoint(Vector2(i.toDouble(), i.toDouble()));
      trail1.update(0.016);
    }
    trail1.reset();

    // Baseline code pattern benchmark
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 10000; i++) {
      // Add a lot of points to simulate heavy load
      for (int j = 0; j < 50; j++) {
        trail1.addPoint(Vector2(i.toDouble(), j.toDouble()));
      }
      trail1.update(0.016);
    }
    stopwatch.stop();
    print('LineTrail updates with massive point additions: ${stopwatch.elapsedMilliseconds} ms / ${stopwatch.elapsedMicroseconds} us');
  });
}
