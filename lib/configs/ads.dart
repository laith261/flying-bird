import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      adUnitId: dotenv.env['InterstitialAd'] ?? 'ca-app-pub-3940256099942544/1033173712',
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
            Timer(Duration(seconds: 5), () => createInterstitialAd());
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
      adUnitId: dotenv.env['RewardedAd'] ?? 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) =>
            Timer(Duration(seconds: 30), () => loadRewardedAd()),
      ),
    );
  }

  void showRewardedAd(MyWorld game, Function fun) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          loadRewardedAd();
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          didGetRewarded = true;
          fun();
        },
      );
      _rewardedAd = null;
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
      _loadingBanner = false;
      return;
    }
    await BannerAd(
      adUnitId: dotenv.env['BannerAd'] ?? 'ca-app-pub-3940256099942544/6300978111',
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
