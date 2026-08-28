import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:game/configs/shop_helper.dart';
import 'package:game/component/skins/skin_enum.dart';
import 'package:game/main.dart';
import 'package:game/models/player_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:game/component/player.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockMyWorld extends Mock implements MyWorld {}

class MockPlayerInfo extends Mock implements PlayerInfo {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockTheBird extends Mock implements TheBird {}

void main() {
  setUpAll(() {
    registerFallbackValue(Skins.bird);
  });

  group('ShopHelper.buySkin', () {
    late MockBuildContext mockContext;
    late MockMyWorld mockGame;
    late MockPlayerInfo mockPlayerData;
    late MockFirebaseAnalytics mockAnalytics;
    late MockTheBird mockPlayer;

    setUp(() {
      mockContext = MockBuildContext();
      mockGame = MockMyWorld();
      mockPlayerData = MockPlayerInfo();
      mockAnalytics = MockFirebaseAnalytics();
      mockPlayer = MockTheBird();

      when(() => mockGame.playerData).thenReturn(mockPlayerData);
      when(() => mockGame.analytics).thenReturn(mockAnalytics);
      when(() => mockGame.player).thenReturn(mockPlayer);
      when(() => mockContext.mounted).thenReturn(false);
    });

    test(
      'should not deduct coins or unlock skin if coins are less than price',
      () async {
        final skin = Skins.magnet;
        final initialCoins = ShopHelper.getPrice(skin) - 1;

        when(() => mockPlayerData.coins).thenReturn(initialCoins);
        bool onCompleteCalled = false;

        await ShopHelper.buySkin(mockContext, mockGame, skin, () {
          onCompleteCalled = true;
        });

        expect(onCompleteCalled, false);
        verifyNever(() => mockPlayerData.runBatched(any()));
      },
    );

    test(
      'should deduct coins, unlock skin, equip skin and call onComplete if coins are enough',
      () async {
        final skin = Skins.magnet;
        final initialCoins = ShopHelper.getPrice(skin) + 50;

        when(() => mockPlayerData.coins).thenReturn(initialCoins);
        when(() => mockGame.tempSkin).thenReturn(null);

        when(() => mockPlayerData.runBatched(any())).thenAnswer((
          invocation,
        ) async {
          final actions =
              invocation.positionalArguments[0]
                  as List<Future<void> Function()>;
          for (var action in actions) {
            await action();
          }
        });
        when(
          () => mockPlayerData.subtractCoins(any()),
        ).thenAnswer((_) async => true);
        when(() => mockPlayerData.unlockSkin(any())).thenAnswer((_) async {});
        when(() => mockPlayerData.equipSkin(any())).thenAnswer((_) async {});
        when(() => mockPlayer.updateSkin(any())).thenAnswer((_) async {});

        bool onCompleteCalled = false;

        await ShopHelper.buySkin(mockContext, mockGame, skin, () {
          onCompleteCalled = true;
        });

        expect(onCompleteCalled, true);
        verify(() => mockPlayerData.runBatched(any())).called(1);
        verify(
          () => mockPlayerData.subtractCoins(ShopHelper.getPrice(skin)),
        ).called(1);
        verify(() => mockPlayerData.unlockSkin(skin.name)).called(1);
        verify(() => mockPlayerData.equipSkin(skin)).called(1);
        verify(() => mockPlayer.updateSkin(skin)).called(1);
      },
    );
  });
}
