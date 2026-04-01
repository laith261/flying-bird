import 'package:flutter/material.dart';

import 'package:game/component/skins/skin_enum.dart';
import 'package:game/screens/Widgets/trails_tab.dart';
import 'package:game/screens/Widgets/power_ups_tab.dart';
import 'package:game/screens/Widgets/birds_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';

import '../configs/shop_helper.dart';

class ShopScreen extends StatefulWidget {
  final MyWorld game;
  const ShopScreen({super.key, required this.game});

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
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          ),
          title: Text(
            "Shop",
            style: GoogleFonts.luckiestGuy(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            // Row(
            //   children: [
            //     Text(
            //       "PRO",
            //       style: GoogleFonts.luckiestGuy(
            //         textStyle: TextStyle(
            //           fontSize: 16,
            //           color: isProMode ? Colors.purple : Colors.grey,
            //         ),
            //       ),
            //     ),
            //     Switch(
            //       value: isProMode,
            //       activeColor: Colors.purple,
            //       onChanged: (value) {
            //         setState(() {
            //           isProMode = value;
            //         });
            //       },
            //     ),
            //     const SizedBox(width: 10),
            //   ],
            // ),
          ],
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.luckiestGuy(fontSize: 18),
            tabs: const [
              Tab(text: "Trails"),
              Tab(text: "Power Ups"),
              Tab(text: "Birds"),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Current Coins Display
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
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
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<int>(
                      valueListenable: widget.game.coins,
                      builder: (context, coins, _) {
                        return Transform.translate(
                          offset: const Offset(0, 3),
                          child: Text(
                            coins.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.luckiestGuy(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
              Expanded(
                child: TabBarView(
                  children: [
                    // Trails Tab
                    TrailsTab(
                      game: widget.game,
                      isProMode: isProMode,
                    ),
                    // Power Ups Tab
                    PowerUpsTab(
                      game: widget.game,
                    ),
                    // Birds Tab
                    BirdsTab(
                      game: widget.game,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
