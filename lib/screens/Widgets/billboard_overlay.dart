import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A Flutter widget positioned inside `backgroundBuilder` above `bg.png`.
/// It renders the billboard image frame and inside it, a live AdMob test native ad.
/// Because this is in `backgroundBuilder`, Flame game components (bird, pipes, clouds)
/// will cleanly render in front of both the billboard and the AdMob native ad!
class BillboardOverlayWidget extends StatefulWidget {
  const BillboardOverlayWidget({super.key, required this.game});

  final MyWorld game;

  @override
  State<BillboardOverlayWidget> createState() => _BillboardOverlayWidgetState();
}

class _BillboardOverlayWidgetState extends State<BillboardOverlayWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  /// Loads the AdMob native ad using dotenv config or official Google test IDs.
  void _loadNativeAd() {
    final String adUnitId =
        dotenv.env['NativeAd'] ??
        (defaultTargetPlatform == TargetPlatform.android
            ? 'ca-app-pub-3940256099942544/2247696110' // Android native ad test id
            : 'ca-app-pub-3940256099942544/3986624511'); // iOS native ad test id

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
          widget.game.billboard.isAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Native Ad failed to load: $error");
          ad.dispose();
          if (mounted) {
            setState(() {
              _nativeAd = null;
              _isAdLoaded = false;
            });
          }
          widget.game.billboard.isAdLoaded = false;
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.black,
        cornerRadius: 8.0,
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
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

        // Only show billboard when the game is started, native ad is loaded and not null, and within screen boundaries
        if (!widget.game.isStarted ||
            !_isAdLoaded ||
            _nativeAd == null ||
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
            // 2. Live AdMob Native Ad Container inside Billboard display face
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
                    width: 300,
                    height: 250, // Standard size for medium template native ad
                    child: AdWidget(ad: _nativeAd!),
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
