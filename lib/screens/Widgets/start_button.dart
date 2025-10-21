import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../main.dart';

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
    required this.game,
    required this.page,
    required this.text,
  });

  final MyWorld game;
  final String page;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.orangeAccent,
      onPressed: () {
        game.overlays.remove(page);
        game.startGame(withRewarded: game.ads.didGetRewarded);
      },

      child: SizedBox(
        width: 150,
        child: StrokeText(
          textAlign: TextAlign.center,
          text: text,
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
    );
  }
}
