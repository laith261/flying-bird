import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/power_ups/power_up_enum.dart';

import '../../configs/shop_helper.dart';

class PowerUpsTab extends StatefulWidget {
  final MyWorld game;

  const PowerUpsTab({super.key, required this.game});

  @override
  State<PowerUpsTab> createState() => _PowerUpsTabState();
}

class _PowerUpsTabState extends State<PowerUpsTab> {
  bool _isAdLoading = false;

  void _claimGiftAd() {
    ShopHelper.claimGiftViaRewardedAd(
      context,
      widget.game,
      onLoadingStarted: () {
        if (mounted) setState(() => _isAdLoading = true);
      },
      onLoadingEnded: () {
        if (mounted) setState(() => _isAdLoading = false);
      },
      onComplete: () {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildGiftCard(BuildContext context) {
    final int giftsCount = widget.game.playerData.gifts;

    return Container(
      margin: const EdgeInsets.only(bottom: 15, top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withAlpha(50),
            Colors.amber.withAlpha(30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withAlpha(100), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.amberAccent,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.giftInventory,
                  style: GoogleFonts.luckiestGuy(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  context.l10n.giftInventoryDesc,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                context.l10n.owned(giftsCount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Buy with 50 Coins
                  ElevatedButton(
                    onPressed: () => ShopHelper.buyGift(
                      context,
                      widget.game,
                      () => setState(() {}),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          size: 16,
                          color: Colors.yellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "50",
                          style: GoogleFonts.luckiestGuy(
                            textStyle: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Claim with Rewarded Ad
                  ElevatedButton(
                    onPressed: _isAdLoading ? null : _claimGiftAd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: _isAdLoading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.play_circle_fill,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.adLabel,
                                style: GoogleFonts.luckiestGuy(
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final powerUps = PowerUps.values;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildGiftCard(context),
        ...powerUps.map((powerUp) {
          final int count = ShopHelper.getPowerUpCount(widget.game, powerUp);

          return Container(
            margin: const EdgeInsets.only(bottom: 15, top: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(50), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(powerUp.icon, color: Colors.lightBlueAccent, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        powerUp.localizedName(context),
                        style: GoogleFonts.luckiestGuy(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        powerUp.localizedDescription(context),
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      context.l10n.owned(count),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () => ShopHelper.buyPowerUp(
                        context,
                        widget.game,
                        powerUp,
                        () => setState(() {}),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${powerUp.price}",
                            style: GoogleFonts.luckiestGuy(
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
