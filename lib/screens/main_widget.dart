import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import 'banner.dart';
import 'end.dart';
import 'start.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.game});
  final MyWorld game;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
    checkUpdate();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }

  void checkUpdate() {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GameWidget(
                game: widget.game,
                initialActiveOverlays: const ["start"],
                overlayBuilderMap: {
                  'start': (context, _) => StartWidget(game: widget.game),
                  'end': (context, _) => EndWidget(game: widget.game),
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
            BannerWidget(game: widget.game),
          ],
        ),
      ),
    );
  }
}
