import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:game/models/player_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Benchmark runBatched vs addCoins directly', () async {
    // Setup MethodChannels
    const MethodChannel channel = MethodChannel('games_services');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
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
    for (int i = 0; i < 100; i++) {
      await playerData.addCoins(1);
    }

    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 100; i++) {
      // simulate the expensive cloud save that happens in runBatched
      await Future.delayed(const Duration(milliseconds: 10)); // fake latency
      await playerData.addCoins(1);
    }
    stopwatch.stop();
    final batchedTime = stopwatch.elapsedMilliseconds;

    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 100; i++) {
      await playerData.addCoins(1);
    }
    stopwatch.stop();
    final directTime = stopwatch.elapsedMilliseconds;

    print(
      'Simulated runBatched time for 100 iterations (with 10ms network latency): $batchedTime ms',
    );
    print('addCoins directly time for 100 iterations: $directTime ms');

    expect(
      directTime < batchedTime,
      true,
      reason:
          'Direct addCoins should be much faster since it avoids cloud save',
    );
  });
}
