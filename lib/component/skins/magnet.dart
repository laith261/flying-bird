import 'package:game/component/coin.dart';
import 'package:game/component/player.dart';
import 'package:game/component/skins/skin.dart';

class Magnet extends Skin {
  const Magnet({required super.image, required super.name});

  @override
  void ability(Player player, double dt) {
    final game = player.game;
    if (!game.isStarted) return;

    final coins = game.pipes.children.whereType<Coin>();
    for (final coin in coins) {
      final playerPos = player.position;
      final coinPos = game.pipes.toLocal(playerPos);

      final distance = coin.position.distanceTo(coinPos);
      if (distance < 150) {
        final direction = (coinPos - coin.position).normalized();
        coin.position += direction * 250 * dt;
      }
    }
  }
}
