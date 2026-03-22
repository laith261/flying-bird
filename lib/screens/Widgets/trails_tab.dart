import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game/main.dart';
import 'package:game/component/trailes/trail_enum.dart';
import 'package:game/screens/Widgets/shop_helper.dart';

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
                        padding: const EdgeInsets.all(10.0),
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
                          else if (isTemp)
                            const Text("TEMP",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
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
                else if (!isOwned)
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

    final paint = Paint()..color = Colors.orange;

    // Helper to draw glow
    void drawGlow(Path path, Color color) {
      if (!isPro) return;
      final glowPaint = Paint()
        ..color = color.withAlpha(153)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..style = paint.style
        ..strokeWidth = paint.strokeWidth + 4
        ..strokeCap = paint.strokeCap;
      canvas.drawPath(path, glowPaint);
    }

    switch (baseId) {
      case 'line':
        paint
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        if (isPro) {
          // Glow for line
          final path = Path();
          path.moveTo(size.width * 0.1, center.dy);
          path.lineTo(size.width * 0.9, center.dy);

          final glowPaint = Paint()
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke
            // Reverting to basic glow color
            ..color = Colors.orange.withAlpha(128)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

          canvas.drawPath(path, glowPaint);

          // Revert to Rainbow Shader from primaries (Pre-modern)
          final shader = LinearGradient(
            colors: Colors.primaries,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
          paint.shader = shader;
        } else {
          paint.color = Colors.orange;
        }

        canvas.drawLine(
          Offset(size.width * 0.1, center.dy),
          Offset(size.width * 0.9, center.dy),
          paint,
        );
        paint.shader = null;
        break;
      case 'circle':
        paint.style = PaintingStyle.fill;
        List<Color> colors = [Colors.orange, Colors.orange, Colors.orange];
        if (isPro) {
          // Revert to Red/Green/Blue
          colors = [Colors.red, Colors.green, Colors.blue];
        }

        for (int i = 0; i < 3; i++) {
          Offset offset = center;
          if (i == 0) offset += const Offset(-25, 0);
          if (i == 2) offset += const Offset(25, 0);
          double radius = i == 1 ? 10 : 7;
          paint.color = colors[i];
          canvas.drawCircle(offset, radius, paint);
        }
        break;
      case 'rect':
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        final rect = Rect.fromCenter(center: center, width: 30, height: 30);

        if (isPro) {
          canvas.save();
          canvas.translate(center.dx, center.dy);
          canvas.rotate(pi / 4);
          final path = Path()..addRect(Rect.fromCenter(center: Offset.zero, width: 30, height: 30));
          drawGlow(path, Colors.purple);
          paint.color = Colors.purple;
          canvas.drawPath(path, paint);
          canvas.restore();
        } else {
          canvas.drawRect(rect, paint);
        }
        break;
      case 'star':
        paint.style = PaintingStyle.fill;
        Path starPath = Path();
        double outerRadius = 15;
        double innerRadius = 7;

        for (int i = 0; i < 5; i++) {
          double angle = (i * 2 * pi / 5) - (pi / 2);
          if (i == 0) {
            starPath.moveTo(center.dx + outerRadius * cos(angle),
                center.dy + outerRadius * sin(angle));
          } else {
            starPath.lineTo(center.dx + outerRadius * cos(angle),
                center.dy + outerRadius * sin(angle));
          }
          angle += pi / 5;
          starPath.lineTo(center.dx + innerRadius * cos(angle),
              center.dy + innerRadius * sin(angle));
        }
        starPath.close();

        if (isPro) {
          drawGlow(starPath, Colors.amber);
          paint.color = Colors.amber;
        } else {
          paint.color = Colors.orange;
        }
        canvas.drawPath(starPath, paint);
        break;
      case 'lightning':
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

        Path bolt = Path();
        bolt.moveTo(center.dx + 5, center.dy - 15);
        bolt.lineTo(center.dx - 10, center.dy + 5);
        bolt.lineTo(center.dx + 5, center.dy);
        bolt.lineTo(center.dx - 5, center.dy + 15);

        if (isPro) {
          drawGlow(bolt, Colors.blue);
          paint.color = Colors.blue;
        } else {
          paint.color = Colors.orange;
        }
        canvas.drawPath(bolt, paint);
        break;
      default:
        // 'none'
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.grey;
        canvas.drawCircle(center, 15, paint);
        canvas.drawLine(
          center + const Offset(-10, -10),
          center + const Offset(10, 10),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
