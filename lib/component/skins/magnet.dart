import 'dart:math' as math;
import 'package:game/component/coin.dart';
import 'package:game/component/player.dart';
import 'package:game/component/skins/skin.dart';

class Magnet extends Skin {
  const Magnet({required super.image, required super.name});

  @override
  void ability(TheBird player, double dt) {
    final game = player.game;
    if (!game.isStarted) return;

    final coins = game.pipes.children.whereType<Coin>();
    if (coins.isEmpty) return;

    final playerPos = player.position;
    final coinPos = game.pipes.toLocal(playerPos);
    final cx = coinPos.x;
    final cy = coinPos.y;

    final moveSpeed = 250 * dt;

    for (final coin in coins) {
      final dx = cx - coin.position.x;
      final dy = cy - coin.position.y;

      // Fast bounding box check to avoid expensive multiplication and math.sqrt
      if (dx > -150 && dx < 150 && dy > -150 && dy < 150) {
        final distanceSquared = dx * dx + dy * dy;

        if (distanceSquared > 0 && distanceSquared < 22500) {
          // 150 * 150
          final distance = math.sqrt(distanceSquared);
          final moveDist = moveSpeed / distance;
          coin.position.x += dx * moveDist;
          coin.position.y += dy * moveDist;
        }
      }
    }
  }
}
