import 'package:flutter/material.dart';

enum PowerUps {
  shield(
    id: 'shield',
    displayName: 'Shield',
    price: 50,
    icon: Icons.security,
    description: 'Protects you from one collision',
  ),
  luckyDay(
    id: 'luckyDay',
    displayName: 'Lucky Day',
    price: 50,
    icon: Icons.stars,
    description: 'Increases chance of finding coins',
  );

  final String id;
  final String displayName;
  final int price;
  final IconData icon;
  final String description;

  const PowerUps({
    required this.id,
    required this.displayName,
    required this.price,
    required this.icon,
    required this.description,
  });
}
