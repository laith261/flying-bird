import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:game/configs/trail_painter_helper.dart';

void main() {
  test('Benchmark drawStarTrail', () {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final size = const ui.Size(100, 100);
    final center = const ui.Offset(50, 50);

    // Warm up
    for (int i = 0; i < 1000; i++) {
      TrailPainterHelper.drawStarTrail(canvas, size, center, true);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      TrailPainterHelper.drawStarTrail(canvas, size, center, true);
    }
    stopwatch.stop();

    print('drawStarTrail baseline: ${stopwatch.elapsedMilliseconds} ms');
  });
}
