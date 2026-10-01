import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages application language state and persistence.
class LanguageManager {
  static const String _prefKey = 'app_language';

  /// ValueNotifier holding the currently active [Locale].
  static final ValueNotifier<Locale> currentLocale = ValueNotifier<Locale>(
    const Locale('en'),
  );

  /// Supported language codes in order.
  static const List<String> supportedLanguages = ['en', 'ar', 'es'];

  /// Text direction mapping for supported language codes.
  static const Map<String, TextDirection> _directions = {
    'ar': TextDirection.rtl,
    'en': TextDirection.ltr,
    'es': TextDirection.ltr,
  };

  /// Returns the [TextDirection] for a given [Locale].
  static TextDirection directionOf(Locale locale) =>
      _directions[locale.languageCode] ?? TextDirection.ltr;

  /// Returns the [TextDirection] of the current active language.
  static TextDirection get currentTextDirection =>
      directionOf(currentLocale.value);

  /// Returns true if the current active language is right-to-left.
  static bool get isRtl => currentTextDirection == TextDirection.rtl;

  /// Initializes language preference from local storage or system locale.
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null && supportedLanguages.contains(savedCode)) {
        currentLocale.value = Locale(savedCode);
      } else {
        final systemCode = PlatformDispatcher.instance.locale.languageCode;
        if (supportedLanguages.contains(systemCode)) {
          currentLocale.value = Locale(systemCode);
        } else {
          currentLocale.value = const Locale('en');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LanguageManager.init failed: $e');
      }
    }
  }

  /// Cycles through supported languages (English -> Arabic -> Spanish -> English).
  static Future<void> toggleLanguage() async {
    final currentIndex = supportedLanguages.indexOf(
      currentLocale.value.languageCode,
    );
    final nextIndex = (currentIndex + 1) % supportedLanguages.length;
    await setLanguage(supportedLanguages[nextIndex]);
  }

  /// Sets the specified language and saves the preference.
  static Future<void> setLanguage(String code) async {
    try {
      currentLocale.value = Locale(code);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, code);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LanguageManager.setLanguage failed: $e');
      }
    }
  }
}

/// Extension on [Locale] providing direct access to its text direction.
extension LocaleDirection on Locale {
  TextDirection get textDirection => LanguageManager.directionOf(this);
  bool get isRtl => textDirection == TextDirection.rtl;
}
