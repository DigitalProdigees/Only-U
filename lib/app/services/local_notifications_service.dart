import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';



@pragma('vm:entry-point')
Future<void> backGroundHandler(RemoteMessage message) async {
  if (GetPlatform.isAndroid) {
    LocalNotificationService.initialize();
    await Firebase.initializeApp();
  }
}

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");

class LocalNotificationService {
  static void initialize() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: androidInitializationSettings,
    );
    notificationsPlugin.initialize(initializationSettings);
  }

  static void displayNotification(RemoteMessage message, String number) async {
    if (GetPlatform.isIOS) {
      return;
    }
    try {
      final id = Random().nextInt(20000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "notification", "OnlyU Notifications Channel",
              channelDescription: "OnlyU Notifications Channel!",
              icon: "@mipmap/ic_launcher",
              importance: Importance.max,
              priority: Priority.high));
      await notificationsPlugin.show(
        id,
        message.notification!.title.toString() + number,
        message.notification!.body.toString(),
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      debugPrint("Error displaying notification: $e");
    }
  }
}
