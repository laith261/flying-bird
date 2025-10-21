import 'package:flutter/material.dart';
import 'package:game/main.dart';

import 'Widgets/hieh_score.dart';
import 'Widgets/start_button.dart';

class StartWidget extends StatefulWidget {
  const StartWidget({super.key, required this.game});

  final MyWorld game;

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  late MyWorld game = widget.game;

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
          StartButton(game: game, page: "start", text: "Start Game"),
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
            ],
          ),
        ],
      ),
    );
  }
}
