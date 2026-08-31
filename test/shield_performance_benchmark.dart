import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/component/helpers/shield_helper.dart';
import 'package:game/component/player.dart';

class MockCanvas implements Canvas {
  @override
  void save() {}
  @override
  void restore() {}
  @override
  void translate(double dx, double dy) {}
  @override
  void rotate(double radians) {}
  @override
  void drawCircle(Offset c, double radius, Paint paint) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Benchmark ShieldHelper.drawShield', () {
    final canvas = MockCanvas();
    final player = TheBird();
    player.size = Vector2(100, 100);

    // Warmup
    for (int i = 0; i < 1000; i++) {
      ShieldHelper.drawShield(canvas, player, 0.0, 1.0);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 100000; i++) {
      ShieldHelper.drawShield(canvas, player, 0.0, 1.0);
    }
    stopwatch.stop();
    print(
      'Optimized time for 100,000 renders: ${stopwatch.elapsedMilliseconds} ms',
    );
  });
}
