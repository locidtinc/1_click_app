import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one_click/shared/services/notification/notification.dart';

import 'initializer/app_initializer.dart';
import 'presentation/app/my_app.dart';
import 'presentation/config/app_config.dart';
import 'shared/constants/local_storage/app_shared_preference.dart';
import 'shared/utils/log_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppSharedPreference.instance.initSharedPreferences();
  await AppInitializer(AppConfig.getInstance()).init();
  final message = await FirebaseMessaging.instance.getInitialMessage();
  await runZonedGuarded(() => _runMyApp(message), _reportError);
  FirebaseMessaging.onBackgroundMessage(
      NotiService.firebaseMessagingBackroundHandler);
}

Future<void> _runMyApp(RemoteMessage? message) async {
  runApp(
    MyApp(
      initialMessage: message,
    ),
  );
}

void _reportError(Object error, StackTrace stackTrace) {
  Log.e(error, stackTrace: stackTrace, name: 'Uncaught exception');
}
