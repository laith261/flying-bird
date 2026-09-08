import 'package:flutter/material.dart';
import 'package:game/main.dart';

/// Renders the billboard frame overlay when active.
/// Native ads are strictly prohibited from loading during active game loop (Directive 3.1).
class BillboardOverlayWidget extends StatelessWidget {
  const BillboardOverlayWidget({super.key, required this.game});

  final MyWorld game;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

