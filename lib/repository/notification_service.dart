import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService({required this.flutterLocalNotificationsPlugin});

  Future<void> showWelcomeNotification(String title, String description) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'dri_weather_api',
          'Dri Weather Welcome Notifications',
          channelDescription: 'Notification channel for welcoming user',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'Dri Weather Payload',
    );
  }
}