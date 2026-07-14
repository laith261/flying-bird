import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../shop.dart';

class PowerUpToggles extends StatefulWidget {
  final MyWorld game;

  const PowerUpToggles({super.key, required this.game});

  @override
  State<PowerUpToggles> createState() => _PowerUpTogglesState();
}

class _PowerUpTogglesState extends State<PowerUpToggles> {
  late MyWorld game = widget.game;

  @override
  void initState() {
    super.initState();
    game.playerData.addListener(_onPlayerDataChanged);
  }

  @override
  void dispose() {
    game.playerData.removeListener(_onPlayerDataChanged);
    super.dispose();
  }

  void _onPlayerDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Shield Power Up Toggle
            _buildSquarePowerUpToggle(
              icon: Icons.security,
              iconColor: Colors.white,
              count: game.playerData.shields,
              isActive: game.isShieldEnabled,
              onTap: () {
                if (game.playerData.shields <= 0) {
                  _showBuyMoreDialog(context, "Shield");
                  return;
                }
                setState(() {
                  game.isShieldEnabled = !game.isShieldEnabled;
                });
              },
            ),

            // Lucky Day Power Up Toggle
            ValueListenableBuilder<bool>(
              valueListenable: game.isLuckyDayActive,
              builder: (context, isLuckyDay, child) {
                return _buildSquarePowerUpToggle(
                  icon: Icons.stars,
                  iconColor: Colors.yellow,
                  count: game.playerData.luckyDay,
                  isActive: isLuckyDay,
                  onTap: () {
                    if (game.playerData.luckyDay <= 0) {
                      _showBuyMoreDialog(context, "Lucky Day");
                      return;
                    }
                    game.isLuckyDayActive.value = !isLuckyDay;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquarePowerUpToggle({
    required IconData icon,
    required Color iconColor,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final bool effectiveActive = isActive && count > 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Square 50x50 Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.withAlpha(240),
                    Colors.deepOrange.withAlpha(240),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: effectiveActive ? Colors.white : Colors.white.withAlpha(180),
                  width: effectiveActive ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: effectiveActive
                        ? Colors.orange.withAlpha(150)
                        : Colors.black.withAlpha(50),
                    blurRadius: effectiveActive ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: count <= 0 ? iconColor.withAlpha(150) : iconColor,
                  size: 28,
                ),
              ),
            ),
            // Badge showing count at top-right corner
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: count <= 0 ? Colors.grey.shade700 : Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    "$count",
                    style: GoogleFonts.luckiestGuy(
                      textStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyMoreDialog(BuildContext context, String powerUpName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.withAlpha(240),
                Colors.deepOrange.withAlpha(240),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                powerUpName == "Shield" ? Icons.security : Icons.stars,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                "Out of ${powerUpName}s!",
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "You don't have any ${powerUpName}s left to activate. Would you like to buy more from the shop?",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(64),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.white.withAlpha(128)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.luckiestGuy(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShopScreen(
                              game: game,
                              initialTabIndex: 1, // Opens directly on the Power Ups tab
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Go to Shop",
                        style: GoogleFonts.luckiestGuy(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

