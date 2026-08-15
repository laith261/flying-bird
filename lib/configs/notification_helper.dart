import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static const int retentionNotificationId = 4848;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('launcher_icon');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );

      await _notificationsPlugin.initialize(settings: initializationSettings);
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Notification initialization error: $e');
      }
    }
  }

  Future<void> scheduleReturnReminder() async {
    try {
      if (!_isInitialized) {
        await init();
      }

      // Cancel any previously scheduled reminder so the 48h timer resets from now
      await _notificationsPlugin.cancel(id: retentionNotificationId);

      final tz.TZDateTime scheduledDate = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(hours: 48));

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'retention_channel_id',
            'Game Reminders',
            channelDescription:
                'Reminders to return to the game and beat your high score',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'launcher_icon',
          );

      const DarwinNotificationDetails darwinDetails =
          DarwinNotificationDetails();

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: retentionNotificationId,
        title: 'We miss you! 🐦',
        body: 'Come back to Flying Bird and beat your high score! 🏆',
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling notification: $e');
      }
    }
  }
}
