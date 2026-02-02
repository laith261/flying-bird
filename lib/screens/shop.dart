import 'dart:math';

import 'package:flutter/material.dart';

import 'package:game/main.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopScreen extends StatefulWidget {
  final MyWorld game;
  const ShopScreen({super.key, required this.game});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Map<String, dynamic>> trails = [
    {'id': 'none', 'name': 'None', 'score': 0, 'price': 0},
    {'id': 'circle', 'name': 'Bubbles', 'score': 0, 'price': 0},
    {'id': 'line', 'name': 'Line', 'score': 20, 'price': 50},
    {'id': 'rect', 'name': 'Rects', 'score': 50, 'price': 50},
    {'id': 'star', 'name': 'Stars', 'score': 100, 'price': 100},
    {'id': 'lightning', 'name': 'Lighting', 'score': 100, 'price': 100},
  ];

  final List<Map<String, dynamic>> powerUps = [
    {'id': 'shield', 'name': 'Shield', 'price': 50, 'icon': Icons.security},
    {'id': 'luckyDay', 'name': 'Lucky Day', 'price': 50, 'icon': Icons.stars},
  ];

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
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: trails.length,
                      itemBuilder: (context, index) {
                        final trail = trails[index];
                        final String baseId = trail['id'] as String;
                        final bool isPro = isProMode && baseId != 'none';
                        final String trailId = isPro ? '${baseId}_pro' : baseId;
                        final String name = isPro
                            ? '${trail['name']} Pro'
                            : (trail['name'] as String);
                        // Double price for Pro versions, same score requirement
                        final int price = isPro
                            ? (trail['price'] as int) * 2
                            : (trail['price'] as int);
                        final int requiredScore = trail['score'] as int;

                        final bool isSelected = selectedTrail == trailId;
                        final bool isTemp = widget.game.tempTrail == trailId;
                        final bool isOwned = purchasedTrails.contains(trailId);
                        final bool isLevelLocked =
                            widget.game.highest.value < requiredScore;

                        return GestureDetector(
                          onTap: () {
                            if (isLevelLocked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Need $requiredScore score to unlock!",
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              return;
                            }

                            if (!isOwned) {
                              /*
                              if (widget.game.coins.value >= price) {
                                _showPurchaseConfirmation(trailId, name, price);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Need $price coins to buy!"),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                              */
                              _showPurchaseConfirmation(trailId, name, price);
                              return;
                            }

                            _selectTrail(trailId);
                          },
                          child: Container(
                            width: 160, // Fixed width for horizontal items
                            margin: const EdgeInsets.only(
                              right: 15,
                              bottom: 50,
                              top: 20,
                            ),
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
                                          opacity: isLevelLocked || !isOwned
                                              ? 0.3
                                              : 1.0,
                                          child: CustomPaint(
                                            painter: TrailPreviewPainter(
                                              trailId,
                                            ),
                                            size: Size.infinite,
                                          ),
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
                                            name,
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
                                          if (isLevelLocked)
                                            Text(
                                              "Lvl: $requiredScore",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
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
                                          else if (isTemp)
                                            const Text(
                                              "TEMP",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                                fontSize: 12,
                                              ),
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
                                if (isLevelLocked)
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(128),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 40,
                                      ),
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
                    ),
                    // Power Ups Tab
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: powerUps.length,
                      itemBuilder: (context, index) {
                        final powerUp = powerUps[index];
                        final String id = powerUp['id'] as String;
                        final String name = powerUp['name'] as String;
                        final int price = powerUp['price'] as int;
                        final IconData icon = powerUp['icon'] as IconData;
                        final int count = id == 'shield'
                            ? widget.game.playerData.shields
                            : widget.game.playerData.luckyDay;

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
                                child: Icon(icon, color: Colors.blue, size: 30),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.luckiestGuy(
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      id == 'shield'
                                          ? "Protect once from collision"
                                          : "Spawn coin at every pipe",
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
                                    onPressed: () {
                                      if (widget.game.playerData.coins >=
                                          price) {
                                        setState(() {
                                          widget.game.playerData.subtractCoins(
                                            price,
                                          );
                                          if (id == 'shield') {
                                            widget.game.playerData.addShield(1);
                                          } else if (id == 'luckyDay') {
                                            widget.game.playerData.addLuckyDay(
                                              1,
                                            );
                                          }
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Bought $name!"),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Need $price coins!"),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      }
                                    },
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
                                          "$price",
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
                    ),
                    // Birds Tab Placeholder
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flutter_dash,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "New Birds Coming Soon!",
                            style: GoogleFonts.luckiestGuy(
                              textStyle: TextStyle(
                                fontSize: 24,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ],
                      ),
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
    setState(() {
      // Use new PlayerData methods
      widget.game.playerData.subtractCoins(price);
      widget.game.playerData.unlockTrail(trailId);

      // widget.game.playerData.coins = widget.game.coins.value;
      // widget.game.playerData.purchasedTrails.add(trailId);

      purchasedTrails.add(trailId);
      // _dataManage.savePlayerData(widget.game.playerData);

      _selectTrail(trailId);
      widget.game.analytics.logEvent(
        name: 'buy trail',
        parameters: {'trail': trailId},
      );
    });
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

          if (isPro) {
            canvas.drawCircle(
              offset,
              radius + 4,
              Paint()
                ..color = colors[i].withAlpha(128)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
            );
          }

          canvas.drawCircle(
            offset,
            radius,
            paint
              ..color = colors[i].withAlpha(isPro ? 255 : (i == 1 ? 204 : 128)),
          );
        }
        break;
      case 'rect':
        paint.style = PaintingStyle.fill;
        Color c1 = Colors.orange.withAlpha(153);
        Color c2 = Colors.orange.withAlpha(153);
        if (isPro) {
          // Revert to Purple/Teal
          c1 = Colors.purple.withAlpha(153);
          c2 = Colors.teal.withAlpha(153);
        }

        void drawRect(Offset offset, double angle, Color color) {
          canvas.save();
          canvas.translate(offset.dx, offset.dy);
          canvas.rotate(angle);

          if (isPro) {
            // Glow
            canvas.drawRect(
              Rect.fromCenter(center: Offset.zero, width: 14, height: 14),
              Paint()
                ..color = color.withAlpha(153)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
            );
          }

          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: 14, height: 14),
            paint..color = color.withAlpha(isPro ? 255 : 153),
          );
          canvas.restore();
        }

        drawRect(center + const Offset(-25, 0), 0.2, c1);
        drawRect(center + const Offset(25, 0), -0.2, c2);
        break;
      case 'star':
        paint.style = PaintingStyle.fill;
        if (isPro) {
          paint.color = Colors.amber; // Revert to Amber
        } else {
          paint.color = Colors.orange;
        }

        final path = Path();
        const double outerRadius = 20;
        const double innerRadius = 9;
        double angle = -pi / 2;
        final double step = pi / 5;

        path.moveTo(
          center.dx + outerRadius * cos(angle),
          center.dy + outerRadius * sin(angle),
        );

        for (int i = 0; i < 5; i++) {
          angle += step;
          path.lineTo(
            center.dx + innerRadius * cos(angle),
            center.dy + innerRadius * sin(angle),
          );

          angle += step;
          path.lineTo(
            center.dx + outerRadius * cos(angle),
            center.dy + outerRadius * sin(angle),
          );
        }
        path.close();

        if (isPro) {
          drawGlow(path, Colors.orange); // Revert glow color?
        }
        canvas.drawPath(path, paint);
        break;
      case 'lightning':
        Color glowColor = Colors.orange.withAlpha(153);
        if (isPro) {
          glowColor = Colors.purple.withAlpha(204); // Revert to Purple
        }

        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isPro ? 8 : 5
          ..strokeCap = StrokeCap.round
          ..maskFilter = isPro
              ? const MaskFilter.blur(BlurStyle.normal, 10)
              : null
          ..color = glowColor;

        final corePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = Colors.white;

        final lPath = Path();
        lPath.moveTo(center.dx + 20, center.dy);
        lPath.lineTo(center.dx + 6, center.dy - 10);
        lPath.lineTo(center.dx - 4, center.dy + 10);
        lPath.lineTo(center.dx - 14, center.dy - 6);
        lPath.lineTo(center.dx - 26, center.dy + 14);

        canvas.drawPath(lPath, glowPaint);
        canvas.drawPath(lPath, corePaint);
        break;
      case 'none':
        paint
          ..color = Colors.grey.withAlpha(128)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(center, 20, paint);
        canvas.drawLine(
          center + const Offset(-14, -14),
          center + const Offset(14, 14),
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant TrailPreviewPainter oldDelegate) {
    return oldDelegate.trailId != trailId;
  }
}
