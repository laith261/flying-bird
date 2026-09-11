import 'package:flutter/material.dart';
import 'package:game/configs/trail_painter_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui' as ui;

void main() {
  test('TrailPainterHelper benchmarking', () {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(800, 600);
    final center = const Offset(400, 300);

    // Warmup
    for (int i = 0; i < 1000; i++) {
      TrailPainterHelper.drawRectTrail(canvas, size, center, true);
      TrailPainterHelper.drawCircleTrail(canvas, size, center, true);
      TrailPainterHelper.drawStarTrail(canvas, size, center, true);
      TrailPainterHelper.drawLightningTrail(canvas, size, center, true);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 50000; i++) {
      TrailPainterHelper.drawRectTrail(canvas, size, center, true);
      TrailPainterHelper.drawCircleTrail(canvas, size, center, true);
      TrailPainterHelper.drawStarTrail(canvas, size, center, true);
      TrailPainterHelper.drawLightningTrail(canvas, size, center, true);
    }
    stopwatch.stop();

    print('Benchmark completed in ${stopwatch.elapsedMilliseconds} ms');
  });
}
