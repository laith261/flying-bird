import 'package:game/component/player.dart';
import 'package:game/component/skins/skin.dart';

class Bird extends Skin {
  const Bird({required super.image, required super.name});

  @override
  void ability(TheBird player, double dt) {}
}
