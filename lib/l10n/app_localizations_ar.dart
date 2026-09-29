// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فلاينغ بيرد';

  @override
  String get startGame => 'ابدأ اللعبة';

  @override
  String get continueGame => 'متابعة';

  @override
  String get watchAdToContinue => 'شاهد إعلاناً للمتابعة';

  @override
  String score(int score) {
    return 'النتيجة: $score';
  }

  @override
  String highScore(int score) {
    return 'أعلى نتيجة: $score';
  }

  @override
  String bestScore(int score) {
    return 'أفضل نتيجة: $score';
  }

  @override
  String get shop => 'المتجر';

  @override
  String get missions => 'المهام';

  @override
  String get daily => 'يومية';

  @override
  String get weeklyOther => 'أسبوعية / أخرى';

  @override
  String get resetsEveryDay => 'تتجدد كل يوم!';

  @override
  String get dailyRewards => 'المكافآت اليومية';

  @override
  String get dailyProgress => 'التقدم اليومي';

  @override
  String get weeklyRewardClaimed => 'تم استلام المكافأة الأسبوعية!';

  @override
  String get trails => 'المسارات';

  @override
  String get powerUps => 'التعزيزات';

  @override
  String get birds => 'الطيور';

  @override
  String get claim => 'استلام';

  @override
  String get claimed => 'تم الاستلام';

  @override
  String get completed => 'مكتمل';

  @override
  String get equip => 'تجهيز';

  @override
  String get equipped => 'مجهز';

  @override
  String get temp => 'مؤقت';

  @override
  String get buy => 'شراء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirmPurchase => 'تأكيد الشراء';

  @override
  String get luckyDay => 'يوم الحظ';

  @override
  String get shield => 'الدرع';

  @override
  String get awesome => 'رائع!';

  @override
  String get gotIt => 'حسناً!';

  @override
  String owned(int count) {
    return 'المملوك: $count';
  }

  @override
  String get notificationTitle => 'اشتقنا إليك! 🐦';

  @override
  String get notificationBody => 'عد إلى فلاينغ بيرد وحطم رقمك القياسي! 🏆';

  @override
  String get tryLabel => 'تجربة';

  @override
  String get open => 'فتح';

  @override
  String get findOne => 'ابحث عن واحدة!';

  @override
  String get tracking => 'مستمر';

  @override
  String get progress => 'التقدم';

  @override
  String get goToShop => 'الذهاب للمتجر';

  @override
  String get needSignIn => 'يجب تسجيل الدخول أولاً';

  @override
  String confirmBuyItem(String item, int price) {
    return 'هل ترغب في شراء $item مقابل $price قطعة نقدية؟';
  }

  @override
  String boughtItem(String item) {
    return 'تم شراء $item!';
  }

  @override
  String needCoins(int price) {
    return 'تحتاج إلى $price عملة!';
  }

  @override
  String get skinEquippedOneLife => 'تم تجهيز المظهر لمحاولة واحدة!';

  @override
  String get trailEquippedOneLife => 'تم تجهيز المسار لمحاولة واحدة!';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String needScoreToUnlock(int score) {
    return 'تحتاج إلى نتيجة $score لإلغاء القفل!';
  }

  @override
  String outOfPowerUpTitle(String powerUp) {
    return 'نفد $powerUp!';
  }

  @override
  String outOfPowerUpDesc(String powerUp) {
    return 'ليس لديك أي $powerUp متبقٍ للتفعيل. هل ترغب بشراء المزيد من المتجر؟';
  }

  @override
  String get shieldDesc => 'يحميك من اصطدام واحد';

  @override
  String get luckyDayDesc => 'يزيد من فرصة العثور على العملات';

  @override
  String get coinCollectorTitle => 'جامع العملات';

  @override
  String get coinCollectorDesc => 'اجمع 10 عملات أثناء اللعب';

  @override
  String get highFlyerTitle => 'محلق عالياً';

  @override
  String get highFlyerDesc => 'حقق نتيجة 15';

  @override
  String get survivorTitle => 'الناجي';

  @override
  String get survivorDesc => 'العب 3 مباريات';

  @override
  String get longTermTrackers => 'متابعة طويلة المدى';

  @override
  String get dailyLoginTrackerTitle => 'متابعة تسجيل الدخول اليومي';

  @override
  String get dailyLoginTrackerDesc =>
      'أيام تسجيل الدخول المتتالية (تتجدد أسبوعياً)';

  @override
  String get giftInventory => 'مخزون الهدايا';

  @override
  String get giftInventoryDesc => 'افتح الهدايا للحصول على عملات عشوائية!';

  @override
  String get prizeShield => '1x درع!';

  @override
  String get prizeLuckyDay => '1x يوم الحظ!';

  @override
  String prizeCoins(int coins) {
    return '$coins عملة!';
  }

  @override
  String get dailyRewardDay7 =>
      'تهانينا!\nلقد وصلت لليوم 7 وحصلت على 10 عملات!';

  @override
  String dailyRewardProgress(int progress) {
    return 'اليوم $progress من 7';
  }

  @override
  String dailyRewardComeBack(int nextDay) {
    return 'عد غداً لليوم $nextDay!';
  }

  @override
  String leaderboardChallengeText(int score, String name) {
    return 'تحتاج إلى $score نقطة لتتفوق على $name';
  }

  @override
  String get sound => 'الصوت';

  @override
  String get leaderboard => 'المتصدرون';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get language => 'اللغة';

  @override
  String get skinBird => 'عصفور';

  @override
  String get skinMagnet => 'المغناطيس';

  @override
  String get skinGhost => 'الشبح';

  @override
  String get skinBirdDesc => 'الطائر الكلاسيكي.';

  @override
  String get skinMagnetDesc => 'يجذب العملات القريبة!';

  @override
  String get skinGhostDesc => 'يمكنه المرور عبر الأنابيب!';

  @override
  String get trailNone => 'بدون';

  @override
  String get trailBubbles => 'فقاعات';

  @override
  String get trailLine => 'خط';

  @override
  String get trailRects => 'مربعات';

  @override
  String get trailStars => 'نجوم';

  @override
  String get trailLighting => 'برق';
}
