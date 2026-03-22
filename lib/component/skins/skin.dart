import 'package:game/component/player.dart';

abstract class Skin {
  final String image;
  final String name;

  const Skin({required this.image, required this.name});
  void ability(Player player, double dt);
}
