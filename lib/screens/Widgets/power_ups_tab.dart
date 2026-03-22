import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/power_ups/power_up_enum.dart';
import 'package:game/screens/Widgets/shop_helper.dart';

class PowerUpsTab extends StatelessWidget {
  final MyWorld game;
  final VoidCallback onStateChange;

  const PowerUpsTab({
    super.key,
    required this.game,
    required this.onStateChange,
  });

  @override
  Widget build(BuildContext context) {
    final powerUps = PowerUps.values;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: powerUps.length,
      itemBuilder: (context, index) {
        final powerUp = powerUps[index];
        final int count = ShopHelper.getPowerUpCount(game, powerUp);

        return Container(
          margin: const EdgeInsets.only(bottom: 15, top: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.blue.withAlpha(128),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(powerUp.icon, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      powerUp.displayName,
                      style: GoogleFonts.luckiestGuy(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Text(
                      powerUp.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "Owned: $count",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () => ShopHelper.buyPowerUp(
                      context,
                      game,
                      powerUp,
                      onStateChange,
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
                          style: GoogleFonts.luckiestGuy(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
