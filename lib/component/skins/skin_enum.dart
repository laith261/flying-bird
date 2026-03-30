import 'package:game/component/skins/bird.dart';
import 'package:game/component/skins/skin.dart';
import 'package:game/component/skins/magnet.dart';
import 'package:game/component/skins/ghost.dart';

enum Skins {
  bird(
    Bird(image: 'bird/skins/bird.png', name: 'Bird'),
    0,
    'The classic bird.',
  ),
  magnet(
    Magnet(image: 'bird/skins/bird_magnetic.png', name: 'Magnet'),
    100,
    'Attracts nearby coins!',
  ),
  ghost(
    Ghost(image: 'bird/skins/ghost.png', name: 'Ghost'),
    100,
    'Can pass through pipes!',
  );

  final Skin skin;
  final int price;
  final String description;
  const Skins(this.skin, this.price, this.description);

  String get image => skin.image;
  String get name => skin.name;
}
