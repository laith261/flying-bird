// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flying Bird';

  @override
  String get startGame => 'Start Game';

  @override
  String get continueGame => 'continue';

  @override
  String get watchAdToContinue => 'watch an ad to continue';

  @override
  String score(int score) {
    return 'Score: $score';
  }

  @override
  String highScore(int score) {
    return 'High Score: $score';
  }

  @override
  String bestScore(int score) {
    return 'Best: $score';
  }

  @override
  String get shop => 'Shop';

  @override
  String get missions => 'Missions';

  @override
  String get daily => 'Daily';

  @override
  String get weeklyOther => 'Weekly / Other';

  @override
  String get resetsEveryDay => 'Resets every day!';

  @override
  String get dailyRewards => 'Daily Rewards';

  @override
  String get dailyProgress => 'Daily Progress';

  @override
  String get weeklyRewardClaimed => 'Weekly Reward Claimed!';

  @override
  String get trails => 'Trails';

  @override
  String get powerUps => 'Power Ups';

  @override
  String get birds => 'Birds';

  @override
  String get claim => 'Claim';

  @override
  String get claimed => 'Claimed';

  @override
  String get completed => 'Completed';

  @override
  String get equip => 'Equip';

  @override
  String get equipped => 'EQUIPPED';

  @override
  String get temp => 'TEMP';

  @override
  String get buy => 'Buy';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmPurchase => 'Confirm Purchase';

  @override
  String get luckyDay => 'Lucky Day';

  @override
  String get shield => 'Shield';

  @override
  String get awesome => 'Awesome!';

  @override
  String get gotIt => 'Got it!';

  @override
  String owned(int count) {
    return 'Owned: $count';
  }

  @override
  String get notificationTitle => 'We miss you! 🐦';

  @override
  String get notificationBody =>
      'Come back to Flying Bird and beat your high score! 🏆';

  @override
  String get tryLabel => 'Try';

  @override
  String get open => 'Open';

  @override
  String get findOne => 'Find one!';

  @override
  String get tracking => 'Tracking';

  @override
  String get progress => 'Progress';

  @override
  String get goToShop => 'Go to Shop';

  @override
  String get needSignIn => 'You need to sign in first';

  @override
  String confirmBuyItem(String item, int price) {
    return 'Do you want to buy $item for $price coins?';
  }

  @override
  String boughtItem(String item) {
    return 'Bought $item!';
  }

  @override
  String needCoins(int price) {
    return 'Need $price coins!';
  }

  @override
  String get skinEquippedOneLife => 'Skin equipped for one life!';

  @override
  String get trailEquippedOneLife => 'Trail equipped for one life!';

  @override
  String get loadingAd => 'Loading ad...';

  @override
  String needScoreToUnlock(int score) {
    return 'Need $score score to unlock!';
  }

  @override
  String outOfPowerUpTitle(String powerUp) {
    return 'Out of ${powerUp}s!';
  }

  @override
  String outOfPowerUpDesc(String powerUp) {
    return 'You don\'t have any ${powerUp}s left to activate. Would you like to buy more from the shop?';
  }

  @override
  String get shieldDesc => 'Protects you from one collision';

  @override
  String get luckyDayDesc => 'Increases chance of finding coins';

  @override
  String get coinCollectorTitle => 'Coin Collector';

  @override
  String get coinCollectorDesc => 'Collect 10 coins in gameplay';

  @override
  String get highFlyerTitle => 'High Flyer';

  @override
  String get highFlyerDesc => 'Reach a score of 15';

  @override
  String get survivorTitle => 'Survivor';

  @override
  String get survivorDesc => 'Play 3 games';

  @override
  String get longTermTrackers => 'Long term trackers';

  @override
  String get dailyLoginTrackerTitle => 'Daily Login Tracker';

  @override
  String get dailyLoginTrackerDesc =>
      'Consecutive daily login streak (Weekly reset)';

  @override
  String get giftInventory => 'Gift Inventory';

  @override
  String get giftInventoryDesc => 'Open gifts for random coin rewards!';

  @override
  String get prizeShield => '1x Shield!';

  @override
  String get prizeLuckyDay => '1x Lucky Day!';

  @override
  String prizeCoins(int coins) {
    return '$coins Coins!';
  }

  @override
  String get dailyRewardDay7 =>
      'Congratulations!\nYou\'ve reached Day 7 and earned 10 coins!';

  @override
  String dailyRewardProgress(int progress) {
    return 'Day $progress of 7';
  }

  @override
  String dailyRewardComeBack(int nextDay) {
    return 'Come back tomorrow for Day $nextDay!';
  }

  @override
  String leaderboardChallengeText(int score, String name) {
    return 'You need $score score to beat $name';
  }

  @override
  String get sound => 'Sound';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get achievements => 'Achievements';

  @override
  String get language => 'Language';

  @override
  String get skinBird => 'Bird';

  @override
  String get skinMagnet => 'Magnet';

  @override
  String get skinGhost => 'Ghost';

  @override
  String get skinBirdDesc => 'The classic bird.';

  @override
  String get skinMagnetDesc => 'Attracts nearby coins!';

  @override
  String get skinGhostDesc => 'Can pass through pipes!';

  @override
  String get trailNone => 'None';

  @override
  String get trailBubbles => 'Bubbles';

  @override
  String get trailLine => 'Line';

  @override
  String get trailRects => 'Rects';

  @override
  String get trailStars => 'Stars';

  @override
  String get trailLighting => 'Lighting';

  @override
  String get newRecordTitle => 'NEW RECORD!';

  @override
  String get freeGiftEarned => '+1 FREE GIFT!';

  @override
  String get addedToGiftInventory => 'Added to your Gift Inventory';

  @override
  String get collect => 'Collect';

  @override
  String giftCollectedTotal(int count) {
    return '+1 Gift Collected! Total: $count 🎁';
  }

  @override
  String get adLabel => 'AD';

  @override
  String get rewardedAdUnavailable => 'Rewarded ad is not available right now.';

  @override
  String get leaderboardTopPlayer =>
      'You\'re #1 on the leaderboard! Defend your record! 👑';
}
