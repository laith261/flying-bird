import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/models/player_data.dart';
import 'package:game/models/games_services_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/services.dart';

class MockGamesServicesWrapper extends Mock implements GamesServicesWrapper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('games_services');

  group('PlayerInfo.load()', () {
    late MockGamesServicesWrapper mockWrapper;
    late SharedPreferences prefs;

    setUp(() async {
      mockWrapper = MockGamesServicesWrapper();
      PlayerInfo.gamesServicesWrapper = mockWrapper;
      SharedPreferences.setMockInitialValues({});

      // Need to avoid init() hitting actual SharedPreferences or GameAuth.
      // We will mock GameAuth channel so init won't hang.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'signIn') {
          return 'success';
        }
        return null;
      });

      await PlayerInfo.init();
      prefs = await SharedPreferences.getInstance();
    });

    test('returns default data when no local or cloud data exists', () async {
      when(() => mockWrapper.getPlayerID()).thenAnswer((_) async => 'player1');
      when(() => mockWrapper.loadGame(name: any(named: 'name'))).thenAnswer((_) async => null);

      final playerInfo = await PlayerInfo.load();

      expect(playerInfo.playerId, 'player1');
      expect(playerInfo.coins, 0);
      expect(playerInfo.highScore, 0);
    });

    test('returns local data when local is newer than cloud', () async {
      when(() => mockWrapper.getPlayerID()).thenAnswer((_) async => 'player1');

      final localData = PlayerInfo(playerId: 'player1', coins: 10, lastModified: 100);
      prefs.setString('PlayerData', jsonEncode(localData.toJson()));

      final cloudData = PlayerInfo(playerId: 'player1', coins: 5, lastModified: 50);
      when(() => mockWrapper.loadGame(name: any(named: 'name')))
          .thenAnswer((_) async => jsonEncode(cloudData.toJson()));

      when(() => mockWrapper.saveGame(name: any(named: 'name'), data: any(named: 'data')))
          .thenAnswer((_) async => 'success');

      final playerInfo = await PlayerInfo.load();

      expect(playerInfo.coins, 10); // local data wins
      verify(() => mockWrapper.saveGame(name: 'PlayerData', data: any(named: 'data'))).called(1);
    });

    test('returns cloud data when cloud is newer than local', () async {
      when(() => mockWrapper.getPlayerID()).thenAnswer((_) async => 'player1');

      final localData = PlayerInfo(playerId: 'player1', coins: 10, lastModified: 50);
      prefs.setString('PlayerData', jsonEncode(localData.toJson()));

      final cloudData = PlayerInfo(playerId: 'player1', coins: 20, lastModified: 100);
      when(() => mockWrapper.loadGame(name: any(named: 'name')))
          .thenAnswer((_) async => jsonEncode(cloudData.toJson()));

      final playerInfo = await PlayerInfo.load();

      expect(playerInfo.coins, 20); // cloud data wins

      // Also verify local is updated
      final updatedLocalStr = prefs.getString('PlayerData');
      expect(updatedLocalStr, isNotNull);
      final updatedLocalData = PlayerInfo.fromJson(jsonDecode(updatedLocalStr!));
      expect(updatedLocalData.coins, 20);
    });

    test('ignores local data if playerId does not match', () async {
      when(() => mockWrapper.getPlayerID()).thenAnswer((_) async => 'player1');

      final localData = PlayerInfo(playerId: 'different_player', coins: 50, lastModified: 100);
      prefs.setString('PlayerData', jsonEncode(localData.toJson()));

      when(() => mockWrapper.loadGame(name: any(named: 'name'))).thenAnswer((_) async => null);

      final playerInfo = await PlayerInfo.load();

      // Local data should be ignored, returns default for 'player1'
      expect(playerInfo.playerId, 'player1');
      expect(playerInfo.coins, 0);
    });

    test('claims guest local data if local playerId is null', () async {
      when(() => mockWrapper.getPlayerID()).thenAnswer((_) async => 'player1');

      final localData = PlayerInfo(playerId: null, coins: 50, lastModified: 100);
      prefs.setString('PlayerData', jsonEncode(localData.toJson()));

      when(() => mockWrapper.loadGame(name: any(named: 'name'))).thenAnswer((_) async => null);

      final playerInfo = await PlayerInfo.load();

      expect(playerInfo.playerId, 'player1');
      expect(playerInfo.coins, 50);
    });
  });
}
