import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.game});

  final MyWorld game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 25,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          height: 44,
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: game.currentScore,
              builder: (context, score, _) {
                return Text(
                  score.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    textStyle: TextStyle(
                      color: Colors.amber,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
