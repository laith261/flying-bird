import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class PowerUpToggles extends StatefulWidget {
  final MyWorld game;

  const PowerUpToggles({super.key, required this.game});

  @override
  State<PowerUpToggles> createState() => _PowerUpTogglesState();
}

class _PowerUpTogglesState extends State<PowerUpToggles> {
  late MyWorld game = widget.game;

  @override
  void initState() {
    super.initState();
    game.playerData.addListener(_onPlayerDataChanged);
  }

  @override
  void dispose() {
    game.playerData.removeListener(_onPlayerDataChanged);
    super.dispose();
  }

  void _onPlayerDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game.playerData.shields <= 0 && game.playerData.luckyDay <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Shield Power Up Toggle
        if (game.playerData.shields > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  game.isShieldEnabled = !game.isShieldEnabled;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: game.isShieldEnabled
                      ? Colors.blue.withAlpha(230)
                      : Colors.grey.withAlpha(128),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.security, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      "Shield: ${game.playerData.shields}",
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      game.isShieldEnabled
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Lucky Day Power Up Toggle
        if (game.playerData.luckyDay > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: ValueListenableBuilder<bool>(
              valueListenable: game.isLuckyDayActive,
              builder: (context, isLuckyDay, child) {
                return GestureDetector(
                  onTap: () {
                    game.isLuckyDayActive.value = !isLuckyDay;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isLuckyDay
                          ? Colors.blue.withAlpha(230)
                          : Colors.grey.withAlpha(128),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars, color: Colors.yellow, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          "Lucky Day: ${game.playerData.luckyDay}",
                          style: GoogleFonts.luckiestGuy(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          isLuckyDay
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
