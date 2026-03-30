import 'package:flame/components.dart';
import 'package:game/component/player.dart';

class GhostHelper {
  static void activateGhostMode(TheBird player) {
    // Stage 1: Initial Flash (1 second)
    player.isInvincible = true;

    player.add(
      TimerComponent(
        period: 1.0,
        removeOnFinish: true,
        onTick: () {
          // Stage 2: Solid Ghost Mode (5 seconds)
          player.isInvincible = false;
          player.isGhostMode = true;

          player.add(
            TimerComponent(
              period: 5.0,
              removeOnFinish: true,
              onTick: () {
                // Stage 3: Final Flash (1 second)
                player.isGhostMode = false;
                player.isInvincible = true;

                player.add(
                  TimerComponent(
                    period: 1.0,
                    removeOnFinish: true,
                    onTick: () {
                      player.isInvincible = false;
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
