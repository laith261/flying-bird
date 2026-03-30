import 'package:flame/components.dart';
import 'package:game/component/player.dart';
import 'package:game/component/pipe.dart';

class CollisionHelper {
  static bool handlePipeCollision(TheBird player, Pipe pipe) {
    if (player.isGhostMode) return false;
    if (player.isInvincible) return false;

    if (player.hasActiveShield) {
      player.hasActiveShield = false;
      player.isInvincible = true;
      player.add(
        TimerComponent(
          period: 1.0,
          removeOnFinish: true,
          onTick: () => player.isInvincible = false,
        ),
      );
      player.game.audio.playBrake();
      return false;
    }

    return true; // Game over
  }
}
