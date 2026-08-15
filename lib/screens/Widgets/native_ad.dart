import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Displays a native ad loaded from AdMob.
class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({
    super.key,
    required this.adUnitId,
    this.minHeight = 70,
    this.maxHeight = 150,
    this.height,
  });

  final String adUnitId;
  final double minHeight;
  final double maxHeight;
  final double? height;

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  /// Loads the native ad and updates state on success or failure.
  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _nativeAd != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        constraints: widget.height != null
            ? BoxConstraints.tightFor(height: widget.height)
            : BoxConstraints(minHeight: widget.minHeight, maxHeight: widget.maxHeight),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withAlpha(64), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: AdWidget(ad: _nativeAd!),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
