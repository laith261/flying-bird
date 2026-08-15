import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A Flutter widget positioned inside `backgroundBuilder` above `bg.png`.
/// It renders the billboard image frame and inside it, a live AdMob test banner (`BannerAd`).
/// Because this is in `backgroundBuilder`, Flame game components (bird, pipes, clouds)
/// will cleanly render in front of both the billboard and the AdMob banner!
class BillboardOverlayWidget extends StatefulWidget {
  const BillboardOverlayWidget({super.key, required this.game});

  final MyWorld game;

  @override
  State<BillboardOverlayWidget> createState() => _BillboardOverlayWidgetState();
}

class _BillboardOverlayWidgetState extends State<BillboardOverlayWidget> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  /// Loads the AdMob banner ad using dotenv config or official Google test IDs.
  void _loadBannerAd() {
    final String adUnitId =
        dotenv.env['BannerAd'] ??
        (defaultTargetPlatform == TargetPlatform.android
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isBannerLoaded = true;
            });
          }
          widget.game.billboard.isAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          print("laith");
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isBannerLoaded = false;
            });
          }
          widget.game.billboard.isAdLoaded = false;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Rect?>(
      valueListenable: widget.game.billboard.widgetRectNotifier,
      builder: (context, rect, child) {
        if (rect == null) {
          return const SizedBox.shrink();
        }

        // Only show billboard when the game is started, banner ad is loaded and not null, and within screen boundaries
        if (!widget.game.isStarted ||
            !_isBannerLoaded ||
            _bannerAd == null ||
            rect.right < -50 ||
            rect.left > widget.game.size.x + 50) {
          return const SizedBox.shrink();
        }

        final billboard = widget.game.billboard;
        final double spriteLeft = billboard.x - (billboard.size.x / 2);
        final double spriteTop = billboard.y - (billboard.size.y / 2);

        return Stack(
          children: [
            // 1. Billboard Image Frame
            Positioned(
              left: spriteLeft,
              top: spriteTop,
              width: billboard.size.x,
              height: billboard.size.y,
              child: Image.asset(
                "assets/images/billboard.png",
                fit: BoxFit.fill,
              ),
            ),
            // 2. Live AdMob Banner Container inside Billboard display face
            Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: Container(
                decoration: const BoxDecoration(color: Colors.black),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
