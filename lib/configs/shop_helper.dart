import 'package:flutter/material.dart';
import 'package:game/component/skins/skin_enum.dart';
import 'package:game/component/trailes/trail_enum.dart';
import 'package:game/component/power_ups/power_up_enum.dart';
import 'package:game/main.dart';

class ShopHelper {
  static bool isOwned(MyWorld game, Skins skin) {
    return game.playerData.purchasedSkins.contains(skin.name);
  }

  static bool isSelected(MyWorld game, Skins skin) {
    return (game.tempSkin ?? game.playerData.selectedSkin) == skin;
  }

  static int getPrice(Skins skin) {
    return skin.price;
  }

  static String getDescription(Skins skin) {
    return skin.description;
  }

  static Future<void> buySkin(
    BuildContext context,
    MyWorld game,
    Skins skin,
    VoidCallback onComplete,
  ) async {
    final price = getPrice(skin);

    if (game.playerData.coins >= price) {
      if (game.tempSkin != null) game.tempSkin = null;
      await game.playerData.runBatched([
        () => game.playerData.subtractCoins(price),
        () => game.playerData.unlockSkin(skin.name),
        () => game.playerData.equipSkin(skin),
      ]);
      await game.player.updateSkin(skin);
      onComplete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.boughtItem(skin.localizedName(context))),
          duration: const Duration(seconds: 1),
        ),
      );
      game.analytics.logEvent(
        name: 'buy_skin',
        parameters: {'skin': skin.name},
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.needCoins(price)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  static Future<void> equipSkin(
    MyWorld game,
    Skins skin,
    VoidCallback onComplete,
  ) async {
    if (game.tempSkin != null) game.tempSkin = null;
    await game.playerData.runBatched([() => game.playerData.equipSkin(skin)]);
    await game.player.updateSkin(skin);
    onComplete();
  }

  // Trails Logic
  static bool isTrailOwned(MyWorld game, String trailId) {
    return game.playerData.purchasedTrails.contains(trailId);
  }

  static bool isTrailSelected(MyWorld game, String trailId) {
    return (game.tempTrail ?? game.playerData.selectedTrail) == trailId;
  }

  static int getTrailPrice(Trails trail, bool isPro) {
    return isPro ? trail.price * 2 : trail.price;
  }

  static Future<void> buyTrail(
    MyWorld game,
    String trailId,
    int price,
    VoidCallback onComplete,
  ) async {
    if (game.playerData.coins >= price) {
      await game.playerData.runBatched([
        () => game.playerData.subtractCoins(price),
        () => game.playerData.unlockTrail(trailId),
        () => game.playerData.equipTrail(trailId),
      ]);
      game.player.updateTrail(trailId);
      onComplete();
    }
  }

  // Power Ups Logic
  static int getPowerUpCount(MyWorld game, PowerUps powerUp) {
    if (powerUp == PowerUps.shield) {
      return game.playerData.shields;
    } else if (powerUp == PowerUps.luckyDay) {
      return game.playerData.luckyDay;
    }
    return 0;
  }

  static Future<void> buyPowerUp(
    BuildContext context,
    MyWorld game,
    PowerUps powerUp,
    VoidCallback onComplete,
  ) async {
    if (game.playerData.coins >= powerUp.price) {
      await game.playerData.runBatched([
        () => game.playerData.subtractCoins(powerUp.price),
        () async {
          if (powerUp == PowerUps.shield) {
            await game.playerData.addShield(1);
          } else if (powerUp == PowerUps.luckyDay) {
            await game.playerData.addLuckyDay(1);
          }
        },
      ]);
      onComplete();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.boughtItem(powerUp.localizedName(context))),
          duration: const Duration(seconds: 1),
        ),
      );
      game.analytics.logEvent(
        name: 'buy_power',
        parameters: {'power': powerUp.displayName},
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.needCoins(powerUp.price)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  static Future<void> buyGift(
    BuildContext context,
    MyWorld game,
    VoidCallback onComplete,
  ) async {
    const int price = 50;
    if (game.playerData.coins >= price) {
      await game.playerData.runBatched([
        () => game.playerData.subtractCoins(price),
        () => game.playerData.addGift(1),
      ]);
      onComplete();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.boughtItem(context.l10n.giftInventory)),
          duration: const Duration(seconds: 1),
        ),
      );
      game.analytics.logEvent(
        name: 'buy_gift',
        parameters: {'price': price},
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.needCoins(price)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  static void claimGiftViaRewardedAd(
    BuildContext context,
    MyWorld game, {
    required VoidCallback onLoadingStarted,
    required VoidCallback onLoadingEnded,
    required VoidCallback onComplete,
  }) {
    game.ads.loadAndShowRewardedAd(
      onRewardEarned: () async {
        await game.playerData.runBatched([
          () => game.playerData.addGift(1),
        ]);
        onComplete();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.card_giftcard, color: Colors.amberAccent),
                const SizedBox(width: 8),
                Text(context.l10n.giftCollectedTotal(game.playerData.gifts)),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        game.analytics.logEvent(name: 'claim_gift_ad');
      },
      onLoadingStarted: onLoadingStarted,
      onLoadingEnded: onLoadingEnded,
      onError: (String error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.rewardedAdUnavailable),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
