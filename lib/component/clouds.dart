import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:game/configs/ads.dart';
import 'package:game/configs/const.dart';
import 'package:game/main.dart';

class Clouds extends ParallaxComponent<MyWorld> {
  bool _adsShowing = false;
  late AdmobAds ads = game.ads;

  @override
  Future<void> onLoad() async {
    priority = 1;
    final image = await Flame.images.load("clouds.png");
    position = Vector2(x, -(game.size.y - 80));
    parallax = Parallax([
      ParallaxLayer(ParallaxImage(image, fill: LayerFill.none)),
    ]);
    parallax?.baseVelocity.x = Consts.pipeSpeed;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    return adsPadding();
  }

  void adsPadding() {
    if (!_adsShowing && ads.bannerAd != null) {
      _adsShowing = true;
      y += ads.bannerAd!.size.height;
    }
  }
}
