import 'package:game/component/player.dart';
import 'package:game/component/skins/skin.dart';

class Ghost extends Skin {
  const Ghost({required super.image, required super.name});

  @override
  void ability(TheBird player, double dt) {}

  @override
  bool get isGhost => true;

  @override
  bool get hasWings => false;
}

