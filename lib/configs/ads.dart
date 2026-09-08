import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobAds {
  AdmobAds();

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
  bool _isInterstitialLoading = false;
  bool _isInterstitialCancelled = false;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;

  bool didGetRewarded = false;

  RewardedAd? get rewardedAd => _rewardedAd;
  bool get isRewardedLoading => _isRewardedLoading;

  /// Cancels any pending or loaded interstitial ad.
  void cancelInterstitialAd() {
    _isInterstitialCancelled = true;
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }
  }

  /// Loads and displays an Interstitial ad on-demand at round boundary.
  Future<void> loadAndShowInterstitialAd({
    VoidCallback? onAdClosed,
    VoidCallback? onAdFailed,
  }) async {
    if (_interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;
    _isInterstitialCancelled = false;

    InterstitialAd.load(
      adUnitId:
          dotenv.env['InterstitialAd'] ??
          'ca-app-pub-3940256099942544/1033173712',
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _isInterstitialLoading = false;
          if (_isInterstitialCancelled) {
            ad.dispose();
            _interstitialAd = null;
            onAdFailed?.call();
            return;
          }
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                  _interstitialAd = null;
                  onAdClosed?.call();
                },
                onAdFailedToShowFullScreenContent: (
                  InterstitialAd ad,
                  AdError error,
                ) {
                  ad.dispose();
                  _interstitialAd = null;
                  onAdFailed?.call();
                },
              );
          _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          debugPrint('Failed to load interstitial ad: ${error.message}');
          onAdFailed?.call();
        },
      ),
      request: const AdRequest(),
    );
  }

  /// Strict user-initiated (on-demand) loading for Rewarded Ads.
  /// Enforces a max timeout (default 3 seconds), single active reference,
  /// and zero background pre-fetching or retries.
  Future<void> loadAndShowRewardedAd({
    required VoidCallback onRewardEarned,
    required VoidCallback onLoadingStarted,
    required VoidCallback onLoadingEnded,
    required Function(String error) onError,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (_rewardedAd != null || _isRewardedLoading) {
      return;
    }

    _isRewardedLoading = true;
    onLoadingStarted();

    bool isTimedOut = false;
    Timer? timeoutTimer = Timer(timeout, () {
      isTimedOut = true;
      _isRewardedLoading = false;
      onLoadingEnded();
      onError('Ad loading timed out.');
    });

    RewardedAd.load(
      adUnitId:
          dotenv.env['RewardedAd'] ?? 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (isTimedOut) {
            ad.dispose();
            return;
          }
          timeoutTimer.cancel();
          _rewardedAd = ad;
          _isRewardedLoading = false;
          onLoadingEnded();

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
              _rewardedAd = null;
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
              _rewardedAd = null;
            },
          );

          _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              didGetRewarded = true;
              onRewardEarned();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (isTimedOut) return;
          timeoutTimer.cancel();
          _rewardedAd = null;
          _isRewardedLoading = false;
          onLoadingEnded();
          onError('Failed to load ad: ${error.message}');
        },
      ),
    );
  }
}

