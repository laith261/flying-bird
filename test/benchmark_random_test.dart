import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Benchmark Random instantiation', () {
    final int iterations = 1000000;

    final stopwatch1 = Stopwatch()..start();
    for (int i = 0; i < iterations; i++) {
      int r = Random().nextInt(100);
    }
    stopwatch1.stop();
    final timeWithNewInstances = stopwatch1.elapsedMilliseconds;

    final Random cachedRandom = Random();
    final stopwatch2 = Stopwatch()..start();
    for (int i = 0; i < iterations; i++) {
      int r = cachedRandom.nextInt(100);
    }
    stopwatch2.stop();
    final timeWithCachedInstance = stopwatch2.elapsedMilliseconds;

    print('Time with new instances: ${timeWithNewInstances}ms');
    print('Time with cached instance: ${timeWithCachedInstance}ms');
    print('Improvement: ${(timeWithNewInstances - timeWithCachedInstance) / timeWithNewInstances * 100}%');
  });
}
