import 'package:flutter_test/flutter_test.dart';
import 'package:game/l10n/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'app_language': 'en'});
  });

  test('LanguageManager benchmark setLanguage', () async {
    await LanguageManager.init();

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 1000; i++) {
      await LanguageManager.setLanguage(i % 2 == 0 ? 'ar' : 'es');
    }
    stopwatch.stop();

    print('LanguageManager.setLanguage 1000 iterations: ${stopwatch.elapsedMilliseconds} ms');
  });
}
