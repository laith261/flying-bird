import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:game/component/helpers/daily_missions_helper.dart';
import 'package:game/models/player_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyMissionsManager', () {
    late DailyMissionsManager manager;
    late PlayerInfo testPlayer;

    setUpAll(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('games_services'),
        (MethodCall methodCall) async {
          // Mock successful responses for GamesServices plugin calls
          return null;
        },
      );
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      PlayerInfo.setPrefsForTesting(prefs);

      manager = DailyMissionsManager.instance;
      manager.resetForTesting();
      testPlayer = PlayerInfo(
        highScore: 0,
        coins: 0,
        playerId: 'test_player',
      );
    });

    test('initialization sets correct default values', () async {
      await manager.init();

      expect(manager.coinsProgress, 0);
      expect(manager.scoreProgress, 0);
      expect(manager.gamesPlayed, 0);
      expect(manager.coinsClaimed, false);
      expect(manager.scoreClaimed, false);
      expect(manager.gamesClaimed, false);
      expect(manager.hasUnclaimedCompletedMission, false);
    });

    test('trackCoinCollected updates progress and correctly flags unclaimed mission', () async {
      await manager.init();

      await manager.trackCoinCollected(5);
      expect(manager.coinsProgress, 5);
      expect(manager.hasUnclaimedCompletedMission, false);

      await manager.trackCoinCollected(5);
      expect(manager.coinsProgress, 10);
      expect(manager.hasUnclaimedCompletedMission, true);

      // Should clamp to 10
      await manager.trackCoinCollected(5);
      expect(manager.coinsProgress, 10);
    });

    test('trackGamePlayed updates games and score progress correctly', () async {
      await manager.init();

      await manager.trackGamePlayed(10);
      expect(manager.gamesPlayed, 1);
      expect(manager.scoreProgress, 10);
      expect(manager.hasUnclaimedCompletedMission, false);

      await manager.trackGamePlayed(12);
      expect(manager.gamesPlayed, 2);
      expect(manager.scoreProgress, 12);
      expect(manager.hasUnclaimedCompletedMission, false);

      await manager.trackGamePlayed(5); // Score didn't beat highest (12)
      expect(manager.gamesPlayed, 3);
      expect(manager.scoreProgress, 12);
      expect(manager.hasUnclaimedCompletedMission, true); // Games played = 3
    });

    test('claimCoinsReward correctly claims reward and calls PlayerInfo', () async {
      await manager.init();
      await manager.trackCoinCollected(10);

      expect(manager.hasUnclaimedCompletedMission, true);

      int initialCoins = testPlayer.coins;
      await manager.claimCoinsReward(testPlayer);

      expect(manager.coinsClaimed, true);
      expect(testPlayer.coins, initialCoins + 10);
      expect(manager.hasUnclaimedCompletedMission, false);
    });

    test('claimScoreReward correctly claims reward and calls PlayerInfo', () async {
      await manager.init();
      await manager.trackGamePlayed(15);

      expect(manager.hasUnclaimedCompletedMission, true);

      int initialCoins = testPlayer.coins;
      await manager.claimScoreReward(testPlayer);

      expect(manager.scoreClaimed, true);
      expect(testPlayer.coins, initialCoins + 15);
      expect(manager.hasUnclaimedCompletedMission, false);
    });

    test('claimGamesReward correctly claims reward and calls PlayerInfo', () async {
      await manager.init();
      await manager.trackGamePlayed(0);
      await manager.trackGamePlayed(0);
      await manager.trackGamePlayed(0);

      expect(manager.hasUnclaimedCompletedMission, true);

      int initialCoins = testPlayer.coins;
      await manager.claimGamesReward(testPlayer);

      expect(manager.gamesClaimed, true);
      expect(testPlayer.coins, initialCoins + 10);
      expect(manager.hasUnclaimedCompletedMission, false);
    });

    test('daily reset correctly clears data when day changes', () async {
      // Simulate data from yesterday
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      SharedPreferences.setMockInitialValues({
        'dm_date': yesterdayStr,
        'dm_coins': 10,
        'dm_score': 15,
        'dm_games': 3,
        'dm_coins_claimed': true,
        'dm_score_claimed': true,
        'dm_games_claimed': true,
      });

      await manager.init();

      // Check reset cleared everything to today
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      expect(manager.date, todayStr);
      expect(manager.coinsProgress, 0);
      expect(manager.scoreProgress, 0);
      expect(manager.gamesPlayed, 0);
      expect(manager.coinsClaimed, false);
      expect(manager.scoreClaimed, false);
      expect(manager.gamesClaimed, false);
    });
  });
}
