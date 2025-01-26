// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> initializeNotifications() async {
    // Listener for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notificación recibida en primer plano: ${message.notification?.title}');
      // Here we could use flutter_local_notifications for displaying the notification
    });

    // Listener for background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificación abierta: ${message.notification?.title}');
      // Here we can navigate to a specific screen
    });
  }
}