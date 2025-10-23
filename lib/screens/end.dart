import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:game/configs/functions.dart';
import 'package:game/main.dart';

import 'Widgets/hieh_score.dart';
import 'Widgets/reword_ad.dart';
import 'Widgets/start_button.dart';

class EndWidget extends StatefulWidget {
  const EndWidget({super.key, required this.game});

  final MyWorld game;

  @override
  State<EndWidget> createState() => _EndState();
}

class _EndState extends State<EndWidget> {
  late MyWorld game = widget.game;

  @override
  void initState() {
    congress();
    if (game.ads.rewardedAd == null) {
      game.ads.loadRewardedAd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: game.size.x,
      height: game.size.y,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          HighestScore(game: game),
          StartButton(
            game: game,
            page: "end",
            text: game.ads.didGetRewarded ? "continue" : "Start Over",
          ),
          if (game.ads.rewardedAd != null && !game.ads.didGetRewarded)
            RewardedAd(game: game, fun: () => setState(() {})),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    game.sound = !game.sound;
                    game.audio.setSound(game.sound);
                  });
                },
                icon: Icon(
                  game.sound ? Icons.volume_up : Icons.volume_off,
                  color: Colors.orangeAccent,
                ),
              ),
              IconButton(
                onPressed: () {
                  Functions.showScores();
                },
                icon: Icon(Icons.leaderboard, color: Colors.orangeAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void congress() {
    if (!game.newHighest) return;

    game.newHighest = false;
    game.audio.playWin();
    Future.delayed(
      Duration.zero,
      () => Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      ),
    );
  }
}
