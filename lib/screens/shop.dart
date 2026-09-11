import 'package:flutter/material.dart';

import 'package:game/screens/Widgets/trails_tab.dart';
import 'package:game/screens/Widgets/power_ups_tab.dart';
import 'package:game/screens/Widgets/birds_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';

class ShopScreen extends StatefulWidget {
  final MyWorld game;
  final int initialTabIndex;
  const ShopScreen({super.key, required this.game, this.initialTabIndex = 0});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isProMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialTabIndex,
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade900, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom App Bar equivalent
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => widget.game.overlays.remove('shop'),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Shop",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.luckiestGuy(
                            textStyle: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(26),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/coin_no_bg.png',
                              width: 20,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.monetization_on,
                                color: Colors.yellow,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 4),
                            ValueListenableBuilder<int>(
                              valueListenable: widget.game.coins,
                              builder: (context, coins, _) {
                                return Transform.translate(
                                  offset: const Offset(0, 2),
                                  child: Text(
                                    coins.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.luckiestGuy(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.orangeAccent,
                  indicatorWeight: 4,
                  labelColor: Colors.orangeAccent,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: GoogleFonts.luckiestGuy(fontSize: 18),
                  unselectedLabelStyle: GoogleFonts.luckiestGuy(fontSize: 16),
                  tabs: const [
                    Tab(text: "Trails"),
                    Tab(text: "Power Ups"),
                    Tab(text: "Birds"),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Trails Tab
                      TrailsTab(game: widget.game, isProMode: isProMode),
                      // Power Ups Tab
                      PowerUpsTab(game: widget.game),
                      // Birds Tab
                      BirdsTab(game: widget.game),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
