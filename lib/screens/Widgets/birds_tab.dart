import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/skins/skin_enum.dart';

import '../../configs/shop_helper.dart';

class BirdsTab extends StatefulWidget {
  final MyWorld game;

  const BirdsTab({
    super.key,
    required this.game,
  });

  @override
  State<BirdsTab> createState() => _BirdsTabState();
}

class _BirdsTabState extends State<BirdsTab> {
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
            onPressed: () {
              if (widget.game.ads.rewardedAd != null) {
                Navigator.of(context).pop();
                widget.game.ads.showRewardedAd(widget.game, () {
                  widget.game.tempSkin = skin;
                  widget.game.player.updateSkin(skin);
                  
                  // Force list rebuild to show the 'TEMP' indicator
                  widget.game.playerData.addShield(0);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Skin equipped for one life!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.game.playerData,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: Skins.values.length,
          itemBuilder: (context, index) {
            final skin = Skins.values[index];
            final bool isOwned = ShopHelper.isOwned(widget.game, skin);
            final bool isSelected = ShopHelper.isSelected(widget.game, skin);
            final bool isTemp = widget.game.tempSkin == skin;
            final int price = ShopHelper.getPrice(skin);
            final String description = ShopHelper.getDescription(skin);

            return GestureDetector(
              onTap: () {
                if (!isOwned) {
                  _showSkinPurchaseConfirmation(skin, price);
                } else {
                  ShopHelper.equipSkin(widget.game, skin, () {
                    setState(() {});
                  });
                }
              },
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(
              right: 15,
              bottom: 50,
              top: 20,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isTemp ? Colors.blue.withAlpha(26) : Colors.orange.withAlpha(26))
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? (isTemp ? Colors.blue : Colors.orange)
                    : Colors.grey.withAlpha(77),
                width: isSelected ? 4 : 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/${skin.image}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.flutter_dash, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            skin.name,
                            style: GoogleFonts.luckiestGuy(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (isTemp)
                            const Text(
                              "TEMP",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                fontSize: 12,
                              ),
                            )
                          else if (!isOwned)
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  "$price",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          else if (isSelected)
                            const Text(
                              "EQUIPPED",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isOwned && !isTemp)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(204),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                if (isTemp)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(
                      Icons.access_time_filled,
                      color: Colors.blue,
                      size: 30,
                    ),
                  )
                else if (isSelected)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  });
  }
}
