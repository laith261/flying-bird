import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/skins/skin_enum.dart';

import '../../configs/shop_helper.dart';

class BirdsTab extends StatelessWidget {
  final MyWorld game;
  final VoidCallback onStateChange;
  final Function(Skins, int) showSkinPurchaseConfirmation;

  const BirdsTab({
    super.key,
    required this.game,
    required this.onStateChange,
    required this.showSkinPurchaseConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: Skins.values.length,
      itemBuilder: (context, index) {
        final skin = Skins.values[index];
        final bool isOwned = ShopHelper.isOwned(game, skin);
        final bool isSelected = ShopHelper.isSelected(game, skin);
        final bool isTemp = game.tempSkin == skin;
        final int price = ShopHelper.getPrice(skin);
        final String description = ShopHelper.getDescription(skin);

        return GestureDetector(
          onTap: () {
            if (!isOwned) {
              showSkinPurchaseConfirmation(skin, price);
            } else {
              ShopHelper.equipSkin(game, skin, () {
                onStateChange();
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
  }
}
