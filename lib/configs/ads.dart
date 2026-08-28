import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobAds {
  AdmobAds() {
    createInterstitialAd();
    loadRewardedAd();
  }

  static Future<void> initializeMobileAds() async {
    final Completer<void> completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          ConsentForm.loadAndShowConsentFormIfRequired((
            FormError? formError,
          ) async {
            await MobileAds.instance.initialize();
            completer.complete();
          });
        } else {
          await MobileAds.instance.initialize();
          completer.complete();
        }
      },
      (FormError error) async {
        await MobileAds.instance.initialize();
        completer.complete();
      },
    );

    return completer.future;
  }

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  bool _isInterstitialLoading = false;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  bool _isRewardedLoading = false;

  final int _maxFailedLoadAttempts = 3;
  bool didGetRewarded = false;

  RewardedAd? get rewardedAd => _rewardedAd;

  Future<void> createInterstitialAd() async {
    if (_interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId:
          dotenv.env['InterstitialAd'] ??
          'ca-app-pub-3940256099942544/1033173712',
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _isInterstitialLoading = false;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          _isInterstitialLoading = false;
          if (_numInterstitialLoadAttempts <= _maxFailedLoadAttempts) {
            final int delayMs = (pow(2, _numInterstitialLoadAttempts) * 1000)
                .toInt();
            Timer(
              Duration(milliseconds: delayMs),
              () => createInterstitialAd(),
            );
          } else {
            debugPrint(
              'Failed to load interstitial ad after $_maxFailedLoadAttempts attempts',
            );
          }
        },
      ),
      request: const AdRequest(),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void loadRewardedAd() {
    if (_rewardedAd != null || _isRewardedLoading) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId:
          dotenv.env['RewardedAd'] ?? 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
          _isRewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          _numRewardedLoadAttempts += 1;
          _rewardedAd = null;
          _isRewardedLoading = false;
          if (_numRewardedLoadAttempts <= _maxFailedLoadAttempts) {
            final int delayMs = (pow(2, _numRewardedLoadAttempts) * 1000)
                .toInt();
            Timer(Duration(milliseconds: delayMs), () => loadRewardedAd());
          } else {
            debugPrint(
              'Failed to load rewarded ad after $_maxFailedLoadAttempts attempts',
            );
          }
        },
      ),
    );
  }

  void showRewardedAd(MyWorld game, Function fun) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _rewardedAd = null;
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
}
