import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  // --- Session Attempt Tracking (Full Page / Interstitial) ---
  static const int targetAttempt = 3;
  int _attemptCount = 0;

  int get attemptCount => _attemptCount;
  set attemptCount(int val) => _attemptCount = val;
  bool get isDesignatedRound => _attemptCount >= targetAttempt;

  /// Increments attempt counter on new game round and triggers interstitial preload
  /// at the exact moment the designated round starts (e.g. attempt #3).
  void onGameAttemptStarted() {
    _attemptCount++;
    if (_attemptCount == targetAttempt) {
      loadInterstitialAd();
    }
  }

  /// Resets the attempt counter back to zero to begin the next cycle.
  void resetAttemptCount() {
    _attemptCount = 0;
  }

  // --- Interstitial Ad State ---
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  bool _isInterstitialCancelled = false;

  bool get isInterstitialLoaded => _interstitialAd != null;
  bool get isInterstitialLoading => _isInterstitialLoading;

  /// Cancels any pending or loaded interstitial ad.
  void cancelInterstitialAd() {
    _isInterstitialCancelled = true;
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }
  }

  /// Loads an Interstitial ad in the background.
  Future<void> loadInterstitialAd() async {
    if (_interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;
    _isInterstitialCancelled = false;

    try {
      await InterstitialAd.load(
        adUnitId:
            dotenv.env['InterstitialAd'] ??
            'ca-app-pub-3940256099942544/1033173712',
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _isInterstitialLoading = false;
            if (_isInterstitialCancelled) {
              ad.dispose();
              _interstitialAd = null;

              return;
            }
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isInterstitialLoading = false;
            _interstitialAd = null;
            debugPrint('Failed to load interstitial ad: ${error.message}');
          },
        ),
        request: const AdRequest(),
      );
    } catch (e) {
      _isInterstitialLoading = false;
      _interstitialAd = null;
      debugPrint('Error loading interstitial ad: $e');
    }
  }

  /// Shows the interstitial ad directly upon game over / loss in the designated round.
  /// Inside onAdDismissedFullScreenContent, resets the attempt counter back to zero to begin the next cycle.
  Future<void> showInterstitialAd({
    required VoidCallback onDismissed,
    VoidCallback? onFailed,
  }) async {
    if (_interstitialAd != null) {
      _showLoadedInterstitial(onDismissed: onDismissed, onFailed: onFailed);

      return;
    }

    if (_isInterstitialLoading) {
      // Background request executing concurrently; wait briefly if round ended quickly
      int elapsedMs = 0;
      while (_isInterstitialLoading && elapsedMs < 2000) {
        await Future.delayed(const Duration(milliseconds: 100));
        elapsedMs += 100;
      }

      if (_interstitialAd != null) {
        _showLoadedInterstitial(onDismissed: onDismissed, onFailed: onFailed);

        return;
      }
    }

    resetAttemptCount();
    onFailed != null ? onFailed() : onDismissed();
  }

  void _showLoadedInterstitial({
    required VoidCallback onDismissed,
    VoidCallback? onFailed,
  }) {
    final ad = _interstitialAd;
    if (ad == null) {
      resetAttemptCount();
      onFailed != null ? onFailed() : onDismissed();

      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd dismissedAd) {
        dismissedAd.dispose();
        _interstitialAd = null;
        resetAttemptCount();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent:
          (InterstitialAd failedAd, AdError error) {
            debugPrint('Failed to show interstitial ad: ${error.message}');
            failedAd.dispose();
            _interstitialAd = null;
            resetAttemptCount();
            onFailed != null ? onFailed() : onDismissed();
          },
    );

    ad.show();
  }

  // --- Rewarded Ad State ---
  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;
  bool _hasInitiatedRewardedLoad = false;
  bool didGetRewarded = false;

  RewardedAd? get rewardedAd => _rewardedAd;
  bool get isRewardedLoaded => _rewardedAd != null;
  bool get isRewardedLoading => _isRewardedLoading;

  /// Triggers rewarded ad loading ONLY when the user clicks "Start Game" for the first time in the session.
  /// Prevents any network requests on splash screen or initial menu launch.
  void initRewardedAdOnFirstStart() {
    if (_hasInitiatedRewardedLoad) return;
    _hasInitiatedRewardedLoad = true;
    loadRewardedAd();
  }

  /// Loads a Rewarded Ad in the background.
  Future<void> loadRewardedAd() async {
    if (_rewardedAd != null || _isRewardedLoading) return;
    _isRewardedLoading = true;

    try {
      await RewardedAd.load(
        adUnitId:
            dotenv.env['RewardedAd'] ??
            'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _isRewardedLoading = false;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _isRewardedLoading = false;
            debugPrint('Failed to load rewarded ad: ${error.message}');
          },
        ),
      );
    } catch (e) {
      _rewardedAd = null;
      _isRewardedLoading = false;
      debugPrint('Error loading rewarded ad: $e');
    }
  }

  /// Shows the loaded rewarded ad immediately when the player chooses to revive or claim reward.
  /// Automatically reloads the next rewarded ad in the background inside onAdDismissedFullScreenContent.
  Future<void> showRewardedAd({
    required VoidCallback onRewardEarned,
    VoidCallback? onLoadingStarted,
    VoidCallback? onLoadingEnded,
    Function(String error)? onError,
  }) async {
    if (_rewardedAd != null) {
      _displayLoadedRewardedAd(
        onRewardEarned: onRewardEarned,
        onError: onError,
      );

      return;
    }

    if (_isRewardedLoading) {
      onLoadingStarted?.call();
      int elapsedMs = 0;
      while (_isRewardedLoading && elapsedMs < 3000) {
        await Future.delayed(const Duration(milliseconds: 100));
        elapsedMs += 100;
      }
      onLoadingEnded?.call();

      if (_rewardedAd != null) {
        _displayLoadedRewardedAd(
          onRewardEarned: onRewardEarned,
          onError: onError,
        );

        return;
      }
    }

    // Fallback if not yet loaded or previous load failed
    onLoadingStarted?.call();
    await loadRewardedAd();
    onLoadingEnded?.call();

    if (_rewardedAd != null) {
      _displayLoadedRewardedAd(
        onRewardEarned: onRewardEarned,
        onError: onError,
      );
    } else {
      onError?.call('Rewarded ad is not available right now.');
    }
  }

  void _displayLoadedRewardedAd({
    required VoidCallback onRewardEarned,
    Function(String error)? onError,
  }) {
    final ad = _rewardedAd;
    if (ad == null) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd dismissedAd) {
        dismissedAd.dispose();
        _rewardedAd = null;
        // Automatically invoke load method in the background to prepare the next rewarded ad for subsequent attempts
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd failedAd, AdError error) {
        debugPrint('Failed to show rewarded ad: ${error.message}');
        failedAd.dispose();
        _rewardedAd = null;
        onError?.call(error.message);
        loadRewardedAd();
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) {
        didGetRewarded = true;
        onRewardEarned();
      },
    );
  }

  /// Backward-compatible wrapper for widgets calling loadAndShowRewardedAd
  Future<void> loadAndShowRewardedAd({
    required VoidCallback onRewardEarned,
    VoidCallback? onLoadingStarted,
    VoidCallback? onLoadingEnded,
    Function(String error)? onError,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    return showRewardedAd(
      onRewardEarned: onRewardEarned,
      onLoadingStarted: onLoadingStarted,
      onLoadingEnded: onLoadingEnded,
      onError: onError,
    );
  }
}
