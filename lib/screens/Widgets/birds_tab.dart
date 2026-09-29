import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/skins/skin_enum.dart';

import '../../configs/shop_helper.dart';

class BirdsTab extends StatefulWidget {
  final MyWorld game;

  const BirdsTab({super.key, required this.game});

  @override
  State<BirdsTab> createState() => _BirdsTabState();
}

class _BirdsTabState extends State<BirdsTab> {
  void _showSkinPurchaseConfirmation(Skins skin, int price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.l10n.confirmPurchase,
          style: GoogleFonts.luckiestGuy(
            textStyle: const TextStyle(color: Colors.orange),
          ),
        ),
        content: Text(
          context.l10n.confirmBuyItem(skin.localizedName(context), price),
          style: GoogleFonts.luckiestGuy(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.cancel,
              style: GoogleFonts.luckiestGuy(
                textStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.game.ads.loadAndShowRewardedAd(
                onRewardEarned: () {
                  widget.game.tempSkin = skin;
                  widget.game.player.updateSkin(skin);

                  // Force list rebuild to show the 'TEMP' indicator
                  widget.game.playerData.addShield(0);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.skinEquippedOneLife),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  widget.game.analytics.logEvent(
                    name: 'try_skin',
                    parameters: {'skin': skin.name},
                  );
                  if (mounted) setState(() {});
                },
                onLoadingStarted: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.loadingAd),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onLoadingEnded: () {},
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
                  context.l10n.tryLabel,
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
              context.l10n.buy,
              style: GoogleFonts.luckiestGuy(
                textStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSkinCardTap(Skins skin) {
    if (!ShopHelper.isOwned(widget.game, skin)) {
      _showSkinPurchaseConfirmation(skin, ShopHelper.getPrice(skin));
    } else {
      ShopHelper.equipSkin(widget.game, skin, () {
        setState(() {});
      });
    }
  }

  Widget _buildListView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: Skins.values.length,
      itemBuilder: (context, index) {
        final skin = Skins.values[index];

        return _SkinCard(
          game: widget.game,
          skin: skin,
          onTap: () => _onSkinCardTap(skin),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.game.playerData,
      builder: (context, _) => _buildListView(context),
    );
  }
}

class _SkinCard extends StatelessWidget {
  final MyWorld game;
  final Skins skin;
  final VoidCallback onTap;

  const _SkinCard({
    required this.game,
    required this.skin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOwned = ShopHelper.isOwned(game, skin);
    final bool isSelected = ShopHelper.isSelected(game, skin);
    final bool isTemp = game.tempSkin == skin;
    final int price = ShopHelper.getPrice(skin);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? (isTemp
                    ? Colors.blue.withAlpha(40)
                    : Colors.orange.withAlpha(40))
              : Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isTemp ? Colors.blueAccent : Colors.orangeAccent)
                : Colors.white.withAlpha(50),
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SkinCardImage(image: skin.image),
                _SkinCardDetails(
                  name: skin.localizedName(context),
                  description: skin.localizedDescription(context),
                  price: price,
                  isOwned: isOwned,
                  isSelected: isSelected,
                  isTemp: isTemp,
                ),
              ],
            ),
            if (!isOwned && !isTemp) const _SkinCardUnownedOverlay(),
            if (isTemp || isSelected)
              _SkinCardStatusIcon(isTemp: isTemp, isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _SkinCardImage extends StatelessWidget {
  final String image;

  const _SkinCardImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          'assets/images/$image',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.flutter_dash, size: 50, color: Colors.grey),
        ),
      ),
    );
  }
}

class _SkinCardDetails extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final bool isOwned;
  final bool isSelected;
  final bool isTemp;

  const _SkinCardDetails({
    required this.name,
    required this.description,
    required this.price,
    required this.isOwned,
    required this.isSelected,
    required this.isTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: GoogleFonts.luckiestGuy(
              textStyle: TextStyle(
                fontSize: 18,
                color: isSelected
                    ? (isTemp ? Colors.lightBlueAccent : Colors.orangeAccent)
                    : Colors.white,
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
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 5),
          if (isTemp)
            Text(
              context.l10n.temp,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            )
          else if (!isOwned)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else if (isSelected)
            Text(
              context.l10n.equipped,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

class _SkinCardUnownedOverlay extends StatelessWidget {
  const _SkinCardUnownedOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(204),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 40),
      ),
    );
  }
}

class _SkinCardStatusIcon extends StatelessWidget {
  final bool isTemp;
  final bool isSelected;

  const _SkinCardStatusIcon({required this.isTemp, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (isTemp) {
      return const PositionedDirectional(
        top: 10,
        end: 10,
        child: Icon(
          Icons.access_time_filled,
          color: Colors.lightBlueAccent,
          size: 30,
        ),
      );
    } else if (isSelected) {
      return const PositionedDirectional(
        top: 10,
        end: 10,
        child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 30),
      );
    }
    return const SizedBox.shrink();
  }
}
