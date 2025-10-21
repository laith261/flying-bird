import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../main.dart';

class RewardedAd extends StatelessWidget {
  const RewardedAd({super.key, required this.game, required this.fun});

  final MyWorld game;
  final Function fun;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.amberAccent,
      onPressed: () {
        game.ads.showRewardedAd(game, fun);
      },
      child: SizedBox(
        width: 150,
        child: StrokeText(
          textAlign: TextAlign.center,
          text: "watch an ad to continue",
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          strokeColor: Colors.black,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
