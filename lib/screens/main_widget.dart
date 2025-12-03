import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import '../main.dart';
import 'banner.dart';
import 'end.dart';
import 'start.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({super.key, required this.game});
  final MyWorld game;

  @override
  Widget build(BuildContext context) {
    checkUpdate();
    return MaterialApp(
      home: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GameWidget(
                game: game,
                initialActiveOverlays: const ["start"],
                overlayBuilderMap: {
                  'start': (context, _) => StartWidget(game: game),
                  'end': (context, _) => EndWidget(game: game),
                },
                backgroundBuilder: (context) => Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            BannerWidget(game: game),
          ],
        ),
      ),
    );
  }

  void checkUpdate() {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    });
  }
}
