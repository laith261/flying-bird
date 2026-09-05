import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:game/models/player_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    PlayerInfo.setPrefsForTesting(prefs);
  });

  test('Benchmark runBatched vs addCoins directly', () async {
    // Setup MethodChannels
    const MethodChannel channel = MethodChannel('games_services');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'saveGame') {
            await Future.delayed(
              const Duration(milliseconds: 10),
            ); // simulate latency
          }
          if (methodCall.method == 'getPlayerID') {
            return 'test_id';
          }
          return null;
        });

    const EventChannel eventChannel = EventChannel('games_services_events');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          eventChannel,
          MockStreamHandler.inline(
            onListen: (dynamic arguments, MockStreamHandlerEventSink events) {},
          ),
        );

    final playerData = PlayerInfo();

    // Warm up
    for (int i = 0; i < 5; i++) {
      await playerData.runBatched([
        () async {
          await playerData.addCoins(1);
        },
      ]);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 50; i++) {
      await playerData.runBatched([
        () async {
          await playerData.addCoins(1);
        },
      ]);
    }
    stopwatch.stop();
    final batchedTime = stopwatch.elapsedMilliseconds;

    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 50; i++) {
      await playerData.addCoins(1);
    }
    stopwatch.stop();
    final directTime = stopwatch.elapsedMilliseconds;

    print('Actual runBatched time for 50 iterations: $batchedTime ms');
    print('addCoins directly time for 50 iterations: $directTime ms');

    // Due to debouncing, runBatched should be very fast, almost identical to directTime.
    // Ensure that runBatched isn't artificially delayed by waiting on save() directly.
    expect(
      batchedTime < 500, // It should take way less than 50 * 10ms = 500ms
      true,
      reason:
          'runBatched should be much faster now since it debounces cloud saves',
    );
  });
}
