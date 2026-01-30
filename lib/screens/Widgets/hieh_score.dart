import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../main.dart';

class HighestScore extends StatefulWidget {
  const HighestScore({super.key, required this.game});

  final MyWorld game;

  @override
  State<HighestScore> createState() => _HighestScoreState();
}

class _HighestScoreState extends State<HighestScore> {
  late ValueNotifier<int> score = game.highest;
  late MyWorld game = widget.game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            child: ValueListenableBuilder<int>(
              builder: (context, value, child) {
                return StrokeText(
                  textAlign: TextAlign.center,
                  text: "Highest Score: $value",
                  textStyle: GoogleFonts.luckiestGuy(
                    textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: game.newHighest
                          ? Colors.amberAccent
                          : Colors.white,
                    ),
                  ),
                  strokeColor: Colors.black,
                  strokeWidth: 2,
                );
              },
              valueListenable: score,
            ),
          ),
        ],
      ),
    );
  }
}
