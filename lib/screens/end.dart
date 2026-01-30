import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:game/configs/functions.dart';
import 'package:game/main.dart';

import 'Widgets/hieh_score.dart';
import 'Widgets/reword_ad.dart';
import 'shop.dart';
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
          const SizedBox(height: 20),
          StartButton(
            game: game,
            page: "end",
            text: game.ads.didGetRewarded ? "continue" : "Start Over",
          ),
          if (game.ads.rewardedAd != null && !game.ads.didGetRewarded) ...[
            const SizedBox(height: 15),
            RewardedAd(
              game: game,
              fun: () => setState(() {
                game.ads.didGetRewarded = true;
              }),
            ),
          ],
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconButton(
                  onPressed: () {
                    setState(() {
                      game.sound = !game.sound;
                      game.audio.setSound(game.sound);
                    });
                  },
                  icon: game.sound ? Icons.volume_up : Icons.volume_off,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(width: 15),
                _buildIconButton(
                  onPressed: () => Functions.showScores(),
                  icon: Icons.leaderboard,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 15),
                _buildIconButton(
                  onPressed: () => Functions.showAchievements(),
                  icon: Icons.star_rounded,
                  color: Colors.purpleAccent,
                ),
                const SizedBox(width: 15),
                _buildIconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShopScreen(game: game),
                    ),
                  ),
                  icon: Icons.store,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        iconSize: 28,
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
