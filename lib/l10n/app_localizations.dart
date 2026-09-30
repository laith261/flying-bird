import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
  ];

  /// Title of the game
  ///
  /// In en, this message translates to:
  /// **'Flying Bird'**
  String get appTitle;

  /// Button text to start a new game
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// Button text to continue game after revival
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get continueGame;

  /// Button text on the reward ad revival button
  ///
  /// In en, this message translates to:
  /// **'watch an ad to continue'**
  String get watchAdToContinue;

  /// Current game score
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String score(int score);

  /// Player's best high score
  ///
  /// In en, this message translates to:
  /// **'High Score: {score}'**
  String highScore(int score);

  /// Best score label
  ///
  /// In en, this message translates to:
  /// **'Best: {score}'**
  String bestScore(int score);

  /// Shop screen title
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// Missions tab or dialog title
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// Daily tab title
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly tab title
  ///
  /// In en, this message translates to:
  /// **'Weekly / Other'**
  String get weeklyOther;

  /// Subtitle indicating daily reset
  ///
  /// In en, this message translates to:
  /// **'Resets every day!'**
  String get resetsEveryDay;

  /// Daily rewards section title
  ///
  /// In en, this message translates to:
  /// **'Daily Rewards'**
  String get dailyRewards;

  /// Daily progress title
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// Weekly reward claimed dialog title
  ///
  /// In en, this message translates to:
  /// **'Weekly Reward Claimed!'**
  String get weeklyRewardClaimed;

  /// Trails tab title in shop
  ///
  /// In en, this message translates to:
  /// **'Trails'**
  String get trails;

  /// Power Ups tab title in shop
  ///
  /// In en, this message translates to:
  /// **'Power Ups'**
  String get powerUps;

  /// Birds skins tab title in shop
  ///
  /// In en, this message translates to:
  /// **'Birds'**
  String get birds;

  /// Claim reward button text
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// Label indicating reward was claimed
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimed;

  /// Label indicating a mission is completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Equip item button text
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get equip;

  /// Equipped status badge text
  ///
  /// In en, this message translates to:
  /// **'EQUIPPED'**
  String get equipped;

  /// Temporary item status badge text
  ///
  /// In en, this message translates to:
  /// **'TEMP'**
  String get temp;

  /// Buy item button text
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm purchase dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Purchase'**
  String get confirmPurchase;

  /// Lucky Day power-up name
  ///
  /// In en, this message translates to:
  /// **'Lucky Day'**
  String get luckyDay;

  /// Shield power-up name
  ///
  /// In en, this message translates to:
  /// **'Shield'**
  String get shield;

  /// Awesome exclamation button
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// Got it acknowledgement button
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// Owned count text
  ///
  /// In en, this message translates to:
  /// **'Owned: {count}'**
  String owned(int count);

  /// Return reminder notification title
  ///
  /// In en, this message translates to:
  /// **'We miss you! 🐦'**
  String get notificationTitle;

  /// Return reminder notification body
  ///
  /// In en, this message translates to:
  /// **'Come back to Flying Bird and beat your high score! 🏆'**
  String get notificationBody;

  /// Try item button text
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get tryLabel;

  /// Open gift button text
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Find gift button text
  ///
  /// In en, this message translates to:
  /// **'Find one!'**
  String get findOne;

  /// Status text for ongoing tracker
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// Progress header text
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Go to shop button text
  ///
  /// In en, this message translates to:
  /// **'Go to Shop'**
  String get goToShop;

  /// Sign in required toast message
  ///
  /// In en, this message translates to:
  /// **'You need to sign in first'**
  String get needSignIn;

  /// Confirmation message before purchase
  ///
  /// In en, this message translates to:
  /// **'Do you want to buy {item} for {price} coins?'**
  String confirmBuyItem(String item, int price);

  /// Success message after purchasing item
  ///
  /// In en, this message translates to:
  /// **'Bought {item}!'**
  String boughtItem(String item);

  /// Insufficient coins message
  ///
  /// In en, this message translates to:
  /// **'Need {price} coins!'**
  String needCoins(int price);

  /// Notification when temporary skin is equipped
  ///
  /// In en, this message translates to:
  /// **'Skin equipped for one life!'**
  String get skinEquippedOneLife;

  /// Notification when temporary trail is equipped
  ///
  /// In en, this message translates to:
  /// **'Trail equipped for one life!'**
  String get trailEquippedOneLife;

  /// Loading ad message
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get loadingAd;

  /// Score requirement to unlock trail
  ///
  /// In en, this message translates to:
  /// **'Need {score} score to unlock!'**
  String needScoreToUnlock(int score);

  /// Title when power-up is exhausted
  ///
  /// In en, this message translates to:
  /// **'Out of {powerUp}s!'**
  String outOfPowerUpTitle(String powerUp);

  /// Description when power-up is exhausted
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any {powerUp}s left to activate. Would you like to buy more from the shop?'**
  String outOfPowerUpDesc(String powerUp);

  /// Shield power-up description
  ///
  /// In en, this message translates to:
  /// **'Protects you from one collision'**
  String get shieldDesc;

  /// Lucky Day power-up description
  ///
  /// In en, this message translates to:
  /// **'Increases chance of finding coins'**
  String get luckyDayDesc;

  /// Coin Collector mission title
  ///
  /// In en, this message translates to:
  /// **'Coin Collector'**
  String get coinCollectorTitle;

  /// Coin Collector mission description
  ///
  /// In en, this message translates to:
  /// **'Collect 10 coins in gameplay'**
  String get coinCollectorDesc;

  /// High Flyer mission title
  ///
  /// In en, this message translates to:
  /// **'High Flyer'**
  String get highFlyerTitle;

  /// High Flyer mission description
  ///
  /// In en, this message translates to:
  /// **'Reach a score of 15'**
  String get highFlyerDesc;

  /// Survivor mission title
  ///
  /// In en, this message translates to:
  /// **'Survivor'**
  String get survivorTitle;

  /// Survivor mission description
  ///
  /// In en, this message translates to:
  /// **'Play 3 games'**
  String get survivorDesc;

  /// Subtitle for weekly trackers
  ///
  /// In en, this message translates to:
  /// **'Long term trackers'**
  String get longTermTrackers;

  /// Daily login tracker title
  ///
  /// In en, this message translates to:
  /// **'Daily Login Tracker'**
  String get dailyLoginTrackerTitle;

  /// Daily login tracker description
  ///
  /// In en, this message translates to:
  /// **'Consecutive daily login streak (Weekly reset)'**
  String get dailyLoginTrackerDesc;

  /// Gift inventory title
  ///
  /// In en, this message translates to:
  /// **'Gift Inventory'**
  String get giftInventory;

  /// Gift inventory description
  ///
  /// In en, this message translates to:
  /// **'Open gifts for random coin rewards!'**
  String get giftInventoryDesc;

  /// Gift prize shield
  ///
  /// In en, this message translates to:
  /// **'1x Shield!'**
  String get prizeShield;

  /// Gift prize lucky day
  ///
  /// In en, this message translates to:
  /// **'1x Lucky Day!'**
  String get prizeLuckyDay;

  /// Gift prize coins
  ///
  /// In en, this message translates to:
  /// **'{coins} Coins!'**
  String prizeCoins(int coins);

  /// Day 7 daily reward message
  ///
  /// In en, this message translates to:
  /// **'Congratulations!\nYou\'ve reached Day 7 and earned 10 coins!'**
  String get dailyRewardDay7;

  /// Daily reward progress indicator
  ///
  /// In en, this message translates to:
  /// **'Day {progress} of 7'**
  String dailyRewardProgress(int progress);

  /// Come back tomorrow message
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for Day {nextDay}!'**
  String dailyRewardComeBack(int nextDay);

  /// Challenge banner text
  ///
  /// In en, this message translates to:
  /// **'You need {score} score to beat {name}'**
  String leaderboardChallengeText(int score, String name);

  /// Sound toggle tooltip
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Leaderboard tooltip
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// Achievements tooltip
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// Language toggle tooltip
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Classic bird skin name
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get skinBird;

  /// Magnet bird skin name
  ///
  /// In en, this message translates to:
  /// **'Magnet'**
  String get skinMagnet;

  /// Ghost bird skin name
  ///
  /// In en, this message translates to:
  /// **'Ghost'**
  String get skinGhost;

  /// Classic bird skin description
  ///
  /// In en, this message translates to:
  /// **'The classic bird.'**
  String get skinBirdDesc;

  /// Magnet bird skin description
  ///
  /// In en, this message translates to:
  /// **'Attracts nearby coins!'**
  String get skinMagnetDesc;

  /// Ghost bird skin description
  ///
  /// In en, this message translates to:
  /// **'Can pass through pipes!'**
  String get skinGhostDesc;

  /// No trail name
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get trailNone;

  /// Bubbles trail name
  ///
  /// In en, this message translates to:
  /// **'Bubbles'**
  String get trailBubbles;

  /// Line trail name
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get trailLine;

  /// Rects trail name
  ///
  /// In en, this message translates to:
  /// **'Rects'**
  String get trailRects;

  /// Stars trail name
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get trailStars;

  /// Lighting trail name
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get trailLighting;

  /// Title displayed when breaking a high score
  ///
  /// In en, this message translates to:
  /// **'NEW RECORD!'**
  String get newRecordTitle;

  /// Label for earning a free gift
  ///
  /// In en, this message translates to:
  /// **'+1 FREE GIFT!'**
  String get freeGiftEarned;

  /// Subtitle stating gift was added to inventory
  ///
  /// In en, this message translates to:
  /// **'Added to your Gift Inventory'**
  String get addedToGiftInventory;

  /// Collect button label
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collect;

  /// Snackbar message when collecting a gift
  ///
  /// In en, this message translates to:
  /// **'+1 Gift Collected! Total: {count} 🎁'**
  String giftCollectedTotal(int count);

  /// Short label for advertisement button
  ///
  /// In en, this message translates to:
  /// **'AD'**
  String get adLabel;

  /// Message when rewarded ad cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Rewarded ad is not available right now.'**
  String get rewardedAdUnavailable;

  /// Message displayed when the player is top of the leaderboard
  ///
  /// In en, this message translates to:
  /// **'You\'re #1 on the leaderboard! Defend your record! 👑'**
  String get leaderboardTopPlayer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
