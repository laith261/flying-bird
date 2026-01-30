import 'package:flutter/material.dart';
import 'package:game/main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../configs/functions.dart';
import 'Widgets/hieh_score.dart';
import 'shop.dart';
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
          // Title
          Text(
            "Flying Bird",
            style: GoogleFonts.luckiestGuy(
              textStyle: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.orange,
                    offset: Offset(0, 5),
                  ),
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          HighestScore(game: game),
          const SizedBox(height: 40),
          StartButton(game: game, page: "start", text: "Start Game"),
          const SizedBox(height: 40),
          // Action Buttons Container
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
}
