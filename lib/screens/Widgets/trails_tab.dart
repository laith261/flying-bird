import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/trailes/trail_enum.dart';
import 'package:game/configs/trail_painter_helper.dart';

import '../../configs/shop_helper.dart';

class TrailsTab extends StatelessWidget {
  final MyWorld game;
  final bool isProMode;
  final VoidCallback onStateChange;
  final Function(String, String, int) showPurchaseConfirmation;
  final Function(String) selectTrail;

  const TrailsTab({
    super.key,
    required this.game,
    required this.isProMode,
    required this.onStateChange,
    required this.showPurchaseConfirmation,
    required this.selectTrail,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: Trails.values.length,
      itemBuilder: (context, index) {
        final trail = Trails.values[index];
        final String baseId = trail.id;
        final bool isPro = isProMode && baseId != 'none';
        final String trailId = isPro ? '${baseId}_pro' : baseId;
        final String name = isPro ? '${trail.name} Pro' : trail.name;

        final int price = ShopHelper.getTrailPrice(trail, isPro);
        final int requiredScore = trail.requiredScore;

        final bool isSelected = ShopHelper.isTrailSelected(game, trailId);
        final bool isTemp = game.tempTrail == trailId;
        final bool isOwned = ShopHelper.isTrailOwned(game, trailId);
        final bool isLevelLocked = game.highest.value < requiredScore;

        return GestureDetector(
          onTap: () {
            if (isLevelLocked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Need $requiredScore score to unlock!"),
                  duration: const Duration(seconds: 1),
                ),
              );
              return;
            }

            if (!isOwned) {
              showPurchaseConfirmation(trailId, name, price);
              return;
            }

            selectTrail(trailId);
          },
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 15, bottom: 50, top: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isTemp
                      ? Colors.blue.withAlpha(26)
                      : Colors.orange.withAlpha(26))
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
                        padding: EdgeInsets.zero,
                        child: Opacity(
                          opacity: isLevelLocked || !isOwned ? 0.3 : 1.0,
                          child: CustomPaint(
                            painter: TrailPreviewPainter(trailId),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.luckiestGuy(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: isSelected ? Colors.orange : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (isLevelLocked)
                            Text(
                              "Score: $requiredScore",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else if (isTemp)
                            const Text("TEMP",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
                          else if (!isOwned)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.monetization_on,
                                    size: 16, color: Colors.amber),
                                const SizedBox(width: 3),
                                Text(
                                  "$price",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          else if (isSelected)
                            const Text("EQUIPPED",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isLevelLocked)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(128),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, color: Colors.white, size: 40),
                    ),
                  )
                else if (!isOwned && !isTemp)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(204),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_cart,
                          color: Colors.white, size: 40),
                    ),
                  ),
                if (isTemp)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.access_time_filled,
                        color: Colors.blue, size: 30),
                  )
                else if (isSelected)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child:
                        Icon(Icons.check_circle, color: Colors.green, size: 30),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TrailPreviewPainter extends CustomPainter {
  final String trailId;

  TrailPreviewPainter(this.trailId);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bool isPro = trailId.endsWith('_pro');
    final String baseId = isPro
        ? trailId.substring(0, trailId.length - 4)
        : trailId;

    // final paint = Paint()..color = Colors.orange;

    switch (baseId) {
      case 'line':
        TrailPainterHelper.drawLineTrail(canvas, size, center, isPro);
        break;
      case 'circle':
        TrailPainterHelper.drawCircleTrail(canvas, size, center, isPro);
        break;
      case 'rect':
        TrailPainterHelper.drawRectTrail(canvas, size, center, isPro);
        break;
      case 'star':
        TrailPainterHelper.drawStarTrail(canvas, size, center, isPro);
        break;
      case 'lightning':
        TrailPainterHelper.drawLightningTrail(canvas, size, center, isPro);
        break;
      default:
        TrailPainterHelper.drawNone(canvas, size, center);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
