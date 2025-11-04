import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdmobAds {
  AdmobAds() {
    createInterstitialAd();
    loadRewardedAd();
  }

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;
  bool didGetRewarded = false;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  bool _failedBanner = false;
  bool _loadingBanner = false;

  RewardedAd? get rewardedAd => _rewardedAd;

  BannerAd? get bannerAd => _bannerAd;

  bool get failedBanner => _failedBanner;

  Future<void> createInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: dotenv.env['InterstitialAd']!,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
      request: AdRequest(),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: dotenv.env['RewardedAd']!,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => Timer(Duration(seconds: 30), () => loadRewardedAd()),
      ),
    );
  }

  void showRewardedAd(MyWorld game, Function fun) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          didGetRewarded = true;
          fun();
          _rewardedAd = null;
          loadRewardedAd(); // Preload next ad
        },
      );
     
    }
  }

  Future<void> loadBannerAd(BuildContext context) async {
    if (_loadingBanner) return;
    _loadingBanner = true;
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }
    await BannerAd(
      adUnitId: dotenv.env['BannerAd']!,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _loadingBanner = false;
          _bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          _loadingBanner = false;
          _failedBanner = true;
          Timer(Duration(seconds: 30), () => _failedBanner = false);
          ad.dispose();
        },
      ),
    ).load();
  }
}
