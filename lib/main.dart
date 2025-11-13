import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:only_u/firebase_options.dart';

import 'app/routes/app_pages.dart';
import 'app/services/local_notifications_service.dart';

final messages = FirebaseMessaging.instance;

Future<void> initializeNotificationsService() async {
  try {
    if (GetPlatform.isAndroid) {
      LocalNotificationService.initialize();
      RemoteMessage? initialMessage = await messages.getInitialMessage();
      if (initialMessage != null) {
        // Handle the initial message
        debugPrint("Initial message: ${initialMessage.messageId}");
      }
      var token = await messages.getToken();
      debugPrint("FCM Token: $token");
    }
    FirebaseMessaging.onBackgroundMessage(backGroundHandler);
    await messages.requestPermission(alert: true, badge: true, sound: true);
    await messages.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeNotificationsService();
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "OnlyU",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
