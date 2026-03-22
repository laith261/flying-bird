import 'package:game/component/skins/bird.dart';
import 'package:game/component/skins/skin.dart';
import 'package:game/component/skins/magnet.dart';

enum Skins {
  bird(Bird(image: 'bird/skins/bird.png', name: 'Bird'), 0, 'The classic bird.'),
  magnet(Magnet(image: 'bird/skins/bird_magnetic.png', name: 'Magnet'), 0, 'Attracts nearby coins!');

  final Skin skin;
  final int price;
  final String description;
  const Skins(this.skin, this.price, this.description);

  String get image => skin.image;
  String get name => skin.name;
}
