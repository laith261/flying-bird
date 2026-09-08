import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../main.dart';

class RewardedAd extends StatefulWidget {
  const RewardedAd({super.key, required this.game, required this.fun});

  final MyWorld game;
  final Function fun;

  @override
  State<RewardedAd> createState() => _RewardedAdState();
}

class _RewardedAdState extends State<RewardedAd> {
  bool _isLoading = false;

  void _handleTap() {
    if (_isLoading) return;

    widget.game.ads.loadAndShowRewardedAd(
      onRewardEarned: () {
        widget.fun();
        widget.game.analytics.logEvent(name: 'revive_ad');
      },
      onLoadingStarted: () {
        if (mounted) setState(() => _isLoading = true);
      },
      onLoadingEnded: () {
        if (mounted) setState(() => _isLoading = false);
      },
      onError: (String error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.amberAccent,
      onPressed: _isLoading ? null : _handleTap,
      child: SizedBox(
        width: 150,
        child: _isLoading
            ? const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                ),
              )
            : const StrokeText(
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

