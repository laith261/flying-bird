import 'package:flutter_test/flutter_test.dart';
import 'package:game/component/trailes/line.dart';
import 'package:game/component/trailes/circle.dart';
import 'package:game/component/trailes/rotate_rect.dart';
import 'package:game/component/trailes/star.dart';
import 'package:game/component/trailes/lightning.dart';
import 'package:game/component/trailes/game_trail.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Benchmark player update opacity loop', () async {
    final lineTrail = LineTrail();
    final circleTrail = CircleTrail();
    final rotateRectTrail = RotateRectTrail();
    final starTrail = StarTrail();
    final lightningTrail = LightningTrail();
    final trails = <String, GameTrail>{
      'line': lineTrail,
      'circle': circleTrail,
      'rect': rotateRectTrail,
      'star': starTrail,
      'lightning': lightningTrail,
    };

    var isGhostMode = false;

    // warm up
    for (var i = 0; i < 1000; i++) {
      isGhostMode = i.isOdd;
      final targetOpacity = isGhostMode ? 0.6 : 1.0;
      for (final trail in trails.values) {
        trail.opacity = targetOpacity;
      }
    }

    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 1000000; i++) {
      isGhostMode = i.isOdd;
      final targetOpacity = isGhostMode ? 0.6 : 1.0;
      for (final trail in trails.values) {
        trail.opacity = targetOpacity;
      }
    }
    stopwatch.stop();
    print(
      'Baseline time for 1,000,000 opacity updates (loop): ${stopwatch.elapsedMilliseconds} ms',
    );
  });

  test('Benchmark player update opacity fast path', () async {
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
    print(
      'Baseline time for 1,000,000 opacity updates (no-op): ${stopwatch.elapsedMilliseconds} ms',
    );
  });
}
