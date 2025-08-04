import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleNotification(TimeOfDay time, String message, int id) async {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final tzScheduled = tz.TZDateTime.from(
      scheduledTime.isBefore(now) ? scheduledTime.add(Duration(days: 1)) : scheduledTime,
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      'Fasting Reminder',
      message,
      tzScheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fasting_channel_id',
          'Fasting Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
