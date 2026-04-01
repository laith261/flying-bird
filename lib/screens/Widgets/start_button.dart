import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../main.dart';

class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
    required this.game,
    required this.text,
  });

  final MyWorld game;
  final String text;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _startGame();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  void _startGame() {
    widget.game.overlays.remove("start");
    widget.game.startGame(withRewarded: widget.game.ads.didGetRewarded);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        transform: Matrix4.translationValues(0, _isPressed ? 8.0 : 0.0, 0), // Moves down instantly without layout shifting
        width: 200,
        height: 70, // Fixed height
        decoration: BoxDecoration(
          color: const Color(0xFFFFD500), // Vibrant Hypercasual Yellow
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, _isPressed ? 0 : 8), // Shadow disappears as button presses in
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: StrokeText(
            textAlign: TextAlign.center,
            text: widget.text.toUpperCase(),
            textStyle: GoogleFonts.luckiestGuy(
              textStyle: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            strokeColor: Colors.black,
            strokeWidth: 4,
          ),
        ),
      ),
    );
  }
}
