# Component Helpers

This directory contains clean, specialized static helpers to support game logic, transitions, calculations, and mechanics.

## Design Philosophy
Following the **Single Responsibility Principle (SRP)**, these helpers isolate specific computations, animations, or state evaluations to prevent bloating active components like `TheBird` or game screens. 

UI rendering and widget composition are strictly decoupled and delegated to independent Widgets.

## Helper Modules

### 1. [CollisionHelper](file:///Users/LAITH/StudioProjects/flying-bird/lib/component/helpers/collision_helper.dart)
- **Responsibility**: Manages collision detection between the player (`TheBird`) and obstacles (`Pipe`).
- **Logic Flow**:
  - Immediately yields if the player is in ghost or invincible mode.
  - If a shield is active, it consumes the shield, awards short-term invincibility, plays audio, and keeps the player alive.
  - Returns `true` to signal game-over under normal status.

### 2. [GhostHelper](file:///Users/LAITH/StudioProjects/flying-bird/lib/component/helpers/ghost_helper.dart)
- **Responsibility**: Handles multistage timings for the ghost mode power-up.
- **Logic Flow**:
  - **Stage 1 (1s)**: Grants invincibility and flashes the player.
  - **Stage 2 (5s)**: Activates full ghost mode to pass safely through obstacles.
  - **Stage 3 (1s)**: Restores standard collision but keeps temporary invincibility to allow recovery.

### 3. [GlowHelper](file:///Users/LAITH/StudioProjects/flying-bird/lib/component/helpers/glow_helper.dart)
- **Responsibility**: Paints high-performance glow rings on a Flutter canvas.
- **Logic Flow**: Uses milliseconds-based sine functions to compute smooth pulsating size, radius, and transparency values, rendering the white overlay circle natively.

### 4. [RewardHelper](file:///Users/LAITH/StudioProjects/flying-bird/lib/component/helpers/reward_helper.dart)
- **Responsibility**: Daily and weekly progression verification logic.
- **Logic Flow**:
  - Performs date math between log-in instances.
  - Progresses reward trackers if sequential log-ins occur, resets otherwise.
  - Initiates the `DailyRewardDialog` UI widget on complete runs.
