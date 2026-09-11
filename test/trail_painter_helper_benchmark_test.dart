import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/configs/trail_painter_helper.dart';

void main() {
  test('TrailPainterHelper drawCircleTrail benchmark', () {
    print('Testing performance of drawCircleTrail');

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(100, 100);
    final center = const Offset(50, 50);

    // Warm up
    for (int i = 0; i < 1000; i++) {
      TrailPainterHelper.drawCircleTrail(canvas, size, center, true);
    }

    // Benchmark
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      TrailPainterHelper.drawCircleTrail(canvas, size, center, true);
    }
    stopwatch.stop();
    print('drawCircleTrail 100,000 iterations: ${stopwatch.elapsedMilliseconds} ms / ${stopwatch.elapsedMicroseconds} us');
  });
}
