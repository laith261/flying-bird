import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:permission_handler/permission_handler.dart';

import '../configs/notification_helper.dart';
import '../main.dart';
import 'start.dart';
import 'Widgets/coin_display.dart';
import 'Widgets/billboard_overlay.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.game});
  final MyWorld game;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkUpdate();
    requestNotificationPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      NotificationHelper().scheduleReturnReminder();
    }
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
    await NotificationHelper().scheduleReturnReminder();
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
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GameWidget(
                  game: widget.game,
                  // initialActiveOverlays handled in MyWorld.onLoad
                  overlayBuilderMap: {
                    'start': (context, _) => StartWidget(game: widget.game),
                    'coin_display': (context, _) =>
                        CoinDisplay(game: widget.game),
                  },
                  backgroundBuilder: (context) => Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      BillboardOverlayWidget(game: widget.game),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
