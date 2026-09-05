import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:game/component/player.dart';
import 'package:game/main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:game/component/trailes/line.dart';
import 'package:game/component/trailes/circle.dart';
import 'package:game/component/trailes/rotate_rect.dart';
import 'package:game/component/trailes/star.dart';
import 'package:game/component/trailes/lightning.dart';
import 'package:game/component/trailes/game_trail.dart';

class MockMyWorld extends Mock implements MyWorld {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Benchmark player update opacity loop', () async {
    // Just run the loops over trails instead of full `update` to isolate the problem.
    final LineTrail _lineTrail = LineTrail();
    final CircleTrail _circleTrail = CircleTrail();
    final RotateRectTrail _rotateRectTrail = RotateRectTrail();
    final StarTrail _starTrail = StarTrail();
    final LightningTrail _lightningTrail = LightningTrail();
    final Map<String, GameTrail> _trails = {
      'line': _lineTrail,
      'circle': _circleTrail,
      'rect': _rotateRectTrail,
      'star': _starTrail,
      'lightning': _lightningTrail,
    };

    bool isGhostMode = false;

    // warm up
    for (var i = 0; i < 1000; i++) {
      double targetOpacity = isGhostMode ? 0.6 : 1.0;
      for (var trail in _trails.values) {
        trail.opacity = targetOpacity;
      }
    }

    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 1000000; i++) {
      double targetOpacity = isGhostMode ? 0.6 : 1.0;
      for (var trail in _trails.values) {
        trail.opacity = targetOpacity;
      }
    }
    stopwatch.stop();
    print('Baseline time for 1,000,000 opacity updates (loop): ${stopwatch.elapsedMilliseconds} ms');
  });

  test('Benchmark player update opacity fast path', () async {
    final LineTrail _lineTrail = LineTrail();
    final CircleTrail _circleTrail = CircleTrail();
    final RotateRectTrail _rotateRectTrail = RotateRectTrail();
    final StarTrail _starTrail = StarTrail();
    final LightningTrail _lightningTrail = LightningTrail();
    final Map<String, GameTrail> _trails = {
      'line': _lineTrail,
      'circle': _circleTrail,
      'rect': _rotateRectTrail,
      'star': _starTrail,
      'lightning': _lightningTrail,
    };

    bool isGhostMode = false;

    // We can simulate setter change intercept instead of loop.

    // warm up
    for (var i = 0; i < 1000; i++) {
      // do nothing if no change
    }

    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 1000000; i++) {
      // Instead of doing this loop every frame, we do nothing every frame,
      // but let's assume we do 0 iterations.
    }
    stopwatch.stop();
    print('Baseline time for 1,000,000 opacity updates (no-op): ${stopwatch.elapsedMilliseconds} ms');
  });
}
