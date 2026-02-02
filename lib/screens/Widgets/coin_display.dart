import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class CoinDisplay extends StatelessWidget {
  final MyWorld game;

  const CoinDisplay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 25,
      right: 10,
      child: ValueListenableBuilder<bool>(
        valueListenable: game.isLuckyDayActive,
        builder: (context, isLuckyDay, child) {
          return ValueListenableBuilder<int>(
            valueListenable: game.coins,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(102),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isLuckyDay
                        ? Colors.yellowAccent.withAlpha(204)
                        : Colors.white.withAlpha(128),
                    width: isLuckyDay ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                    if (isLuckyDay)
                      BoxShadow(
                        color: Colors.yellowAccent.withAlpha(153),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/coin_no_bg.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.translate(
                      offset: const Offset(0, 3),
                      child: Text(
                        value.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.luckiestGuy(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
