import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game/component/helpers/daily_missions_helper.dart';

void main() {
  test('Save Data Benchmark', () async {
    SharedPreferences.setMockInitialValues({});
    final manager = DailyMissionsManager.instance;
    manager.resetForTesting();
    await manager.init();

    // warm up
    for (int i = 0; i < 10; i++) {
      await manager.trackCoinCollected(1);
    }
    manager.resetForTesting();
    await manager.init();

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 10000; i++) {
      await manager.trackCoinCollected(0);
      // Wait for timer to finish or we can just benchmark trackCoinCollected?
      // trackCoinCollected schedules save, but doesn't await it.
    }
    stopwatch.stop();
    print('Baseline - Track coin collected: ${stopwatch.elapsedMilliseconds} ms');
  });
}
