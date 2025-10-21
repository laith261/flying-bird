import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../main.dart';

class HighestScore extends StatefulWidget {
  const HighestScore({super.key, required this.game});

  final MyWorld game;

  @override
  State<HighestScore> createState() => _HighestScoreState();
}

class _HighestScoreState extends State<HighestScore> {
  late int score = game.highest;
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
            flex: 2,
            child: StrokeText(
              textAlign: TextAlign.right,
              text: "Highest Score: ",
              textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'game',
                color: Colors.white,
              ),
              strokeColor: Colors.black,
              strokeWidth: 2,
            ),
          ),
          Flexible(
            flex: 1,
            child: StrokeText(
              textAlign: TextAlign.left,
              text: "$score",
              textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'game',
                color: game.newHighest ? Colors.amberAccent : Colors.white,
              ),
              strokeColor: Colors.black,
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
