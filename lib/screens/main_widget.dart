import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:permission_handler/permission_handler.dart';

import '../configs/notification_helper.dart';
import '../main.dart';
import 'start.dart';
import 'Widgets/coin_display.dart';
import 'Widgets/hieh_score.dart';
import 'Widgets/adaptive_banner.dart';
import 'Widgets/daily_missions_dialog.dart';
import 'Widgets/score_display.dart';
import 'shop.dart';

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
    return ValueListenableBuilder<Locale>(
      valueListenable: LanguageManager.currentLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          locale: locale,
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          //   primaryColor: Colors.amber,
          // ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: locale.textDirection,
                      child: GameWidget(
                        game: widget.game,
                        // initialActiveOverlays handled in MyWorld.onLoad
                        overlayBuilderMap: {
                          'start': (context, _) =>
                              StartWidget(game: widget.game),
                          'coin_display': (context, _) =>
                              CoinDisplay(game: widget.game),
                          'highest_score': (context, _) =>
                              HighestScore(game: widget.game),
                          'daily_missions': (context, _) =>
                              DailyMissionsDialog(game: widget.game),
                          'shop': (context, _) => ShopScreen(
                            game: widget.game,
                            initialTabIndex: widget.game.shopInitialTabIndex,
                          ),
                          'score_display': (context, _) =>
                              ScoreDisplay(game: widget.game),
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
                  ),
                  const AdaptiveBannerWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
