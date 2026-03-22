import 'package:flutter/material.dart';

import 'package:game/component/skins/skinEnum.dart';
import 'package:game/screens/Widgets/shop_helper.dart';
import 'package:game/screens/Widgets/trails_tab.dart';
import 'package:game/screens/Widgets/power_ups_tab.dart';
import 'package:game/screens/Widgets/birds_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';

class ShopScreen extends StatefulWidget {
  final MyWorld game;
  const ShopScreen({super.key, required this.game});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  String selectedTrail = 'none';
  List<String> purchasedTrails = ['none'];

  bool isProMode = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    String savedTrail = widget.game.playerData.selectedTrail;
    List<String> bought = List.from(widget.game.playerData.purchasedTrails);
    setState(() {
      selectedTrail = widget.game.tempTrail ?? savedTrail;
      purchasedTrails = bought;
    });
  }

  void _selectTrail(String id) {
    if (widget.game.tempTrail != null) {
      widget.game.tempTrail = null;
    }
    setState(() {
      selectedTrail = id;
    });

    widget.game.playerData.equipTrail(id);
    // _dataManage.savePlayerData(widget.game.playerData);

    // Update player immediately if game is running/ready
    widget.game.player.updateTrail(id);
    widget.game.analytics.logEvent(
      name: 'select_trail',
      parameters: {'trail': id},
    );
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
                    Transform.translate(
                      offset: const Offset(0, 3),
                      child: Text(
                        widget.game.playerData.coins.toString(),
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
                      onStateChange: () => setState(() {}),
                      showPurchaseConfirmation: _showPurchaseConfirmation,
                      selectTrail: _selectTrail,
                    ),
                    // Power Ups Tab
                    PowerUpsTab(
                      game: widget.game,
                      onStateChange: () => setState(() {}),
                    ),
                    // Birds Tab
                    BirdsTab(
                      game: widget.game,
                      onStateChange: () => setState(() {}),
                      showSkinPurchaseConfirmation: _showSkinPurchaseConfirmation,
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

  void _showPurchaseConfirmation(String trailId, String trailName, int price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Purchase",
          style: GoogleFonts.luckiestGuy(
            textStyle: const TextStyle(color: Colors.orange),
          ),
        ),
        content: Text(
          "Do you want to buy $trailName for $price coins?",
          style: GoogleFonts.luckiestGuy(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: GoogleFonts.luckiestGuy(
                textStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.game.ads.rewardedAd != null) {
                Navigator.of(context).pop();
                widget.game.ads.showRewardedAd(widget.game, () {
                  widget.game.tempTrail = trailId;
                  widget.game.player.updateTrail(trailId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Trail equipped for one life!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ad not ready yet, try again later"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "Try",
                  style: GoogleFonts.luckiestGuy(
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.game.playerData.coins >= price
                ? () {
                    Navigator.of(context).pop();
                    _buyTrail(trailId, price);
                  }
                : null, // Disable button if not enough coins
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.game.playerData.coins >= price
                  ? Colors.orange
                  : Colors.grey,
            ),
            child: Text(
              "Buy",
              style: GoogleFonts.luckiestGuy(
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buyTrail(String trailId, int price) {
    ShopHelper.buyTrail(widget.game, trailId, price, () {
      setState(() {
        _selectTrail(trailId);
      });
      widget.game.analytics.logEvent(
        name: 'buy_trail',
        parameters: {'trail': trailId},
      );
    });
  }

  void _showSkinPurchaseConfirmation(Skins skin, int price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Purchase",
          style: GoogleFonts.luckiestGuy(
            textStyle: const TextStyle(color: Colors.orange),
          ),
        ),
        content: Text(
          "Do you want to buy ${skin.name} for $price coins?",
          style: GoogleFonts.luckiestGuy(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: GoogleFonts.luckiestGuy(
                textStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: widget.game.playerData.coins >= price
                ? () {
                    Navigator.of(context).pop();
                    ShopHelper.buySkin(context, widget.game, skin, () {
                      setState(() {});
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.game.playerData.coins >= price
                  ? Colors.orange
                  : Colors.grey,
            ),
            child: Text(
              "Buy",
              style: GoogleFonts.luckiestGuy(
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
