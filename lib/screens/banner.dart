import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../configs/ads.dart';
import '../main.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key, required this.game});

  final MyWorld game;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late AdmobAds ads = widget.game.ads;

  @override
  Widget build(BuildContext context) {
    initBanner();
    return ads.bannerAd != null
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: ads.bannerAd!.size.width.toDouble(),
              height: ads.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: ads.bannerAd!),
            ),
          )
        : SizedBox();
  }

  initBanner() async {
    if (ads.failedBanner || ads.bannerAd != null) return;
    ads.loadBannerAd(context).then((value) {
      setState(() {});
    });
  }
}
