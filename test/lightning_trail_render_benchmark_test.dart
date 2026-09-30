import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:game/component/trailes/lightning.dart';

void main() {
  test('LightningTrail render performance benchmark', () {
    print('Testing performance of LightningTrail.render');

    // Create a mock canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final trail = LightningTrail();
    // Add some points so it has something to render
    for (int i = 0; i < 50; i++) {
      trail.addPoint(Vector2(i * 10.0, i * 10.0));
    }
    trail.update(0.1);

    // Warm up
    for (int i = 0; i < 1000; i++) {
      trail.render(canvas);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      trail.render(canvas);
    }
    stopwatch.stop();

    print(
      'LightningTrail.render (Standard) benchmark: ${stopwatch.elapsedMilliseconds} ms',
    );

    trail.isPro = true;

    // Warm up
    for (int i = 0; i < 1000; i++) {
      trail.render(canvas);
    }

    final stopwatchPro = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      trail.render(canvas);
    }
    stopwatchPro.stop();

    print(
      'LightningTrail.render (Pro) benchmark: ${stopwatchPro.elapsedMilliseconds} ms',
    );
  });
}
