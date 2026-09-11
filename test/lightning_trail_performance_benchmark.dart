import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/configs/trail_painter_helper.dart';
import 'dart:ui' as ui;

void main() {
  test('drawLightningTrail performance benchmark', () {
    print('Testing performance of drawLightningTrail');

    // Create a mock canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(100, 100);
    final center = const Offset(50, 50);

    // Warm up
    for (int i = 0; i < 1000; i++) {
      TrailPainterHelper.drawLightningTrail(canvas, size, center, true);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 50000; i++) {
      TrailPainterHelper.drawLightningTrail(canvas, size, center, true);
    }
    stopwatch.stop();

    print('drawLightningTrail benchmark: ${stopwatch.elapsedMilliseconds} ms');
  });
}
