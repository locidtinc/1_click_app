import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/services/notification/localNotiPlugin.dart';

import 'channels.dart';

class LocalNotificationsPlugin {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
}

class NotiService {
  //------------- Handle Event Noti when Device on Background mode ----------
  static final _router = getIt.get<AppRouter>();
  static Future<void> firebaseMessagingBackroundHandler(
    RemoteMessage message,
  ) async {
    // await Firebase.initializeApp();
    try {
      print('message ${message.data}');
    } catch (e) {
      print(e);
    }
    await showLocalNoti(
      localNotificationsPlugin.flutterLocalNotificationsPlugin,
      message,
    );
  }

  //-------------- Initialize Noti service -----------------
  static Future<void> intinializeNotiService(BuildContext context) async {
    await Firebase.initializeApp();

    final firebaseMessaging = FirebaseMessaging.instance;

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        LocalNotificationsPlugin.flutterLocalNotificationsPlugin;
    // icon notification
    const androidInitialize =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const IosInitialize = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: IosInitialize,
    );

    // await flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (details) async {
    //     // try {
    //     //     if (details.payload != null && !details.payload!.isEmpty) {
    //     //       Get.toNamed(Routes.routeTabView, arguments: TabItemCode.ORDER);
    //     //     } else
    //     //       return;
    //     //   } catch (e) {
    //     //     debugPrint('err : $e');
    //     //   }
    //   },
    // );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final id = int.parse(payload);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(Duration.zero, () {
                context.router.push(
                  OrderDetailRoute(
                    order: id,
                    typeOrder: TypeOrder.cHTH,
                  ),
                );
              });
            });
          } catch (e) {
            print(' Error in onDidReceiveNotificationResponse: $e');
          }
        }
      },
    );
    const AndroidNotificationChannel channel = ChannelsDefault.channel_1;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // setting notification
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // request permission for device
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    final RemoteMessage? initMessage =
        await firebaseMessaging.getInitialMessage();
    if (initMessage != null) {
      // Get.toNamed(
      //   Routes.routeOrderDetail,
      //   arguments: OrderModel(systemOrderId: 1, systemKey: "AD"),
      // );
    }

    // event listening when have noti when device on fore
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showLocalNoti(flutterLocalNotificationsPlugin, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final id = int.tryParse(event.data['order_id'] ?? '');
      if (id != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration.zero, () {
            context.router.push(
              OrderDetailRoute(
                order: id,
                typeOrder: TypeOrder.cHTH,
              ),
            );
          });
        });
        // Get.toNamed(
        //   Routes.routeOrderDetail,
        //   arguments: OrderModel(
        //     systemOrderId: int.parse(message.data["system_order_id"]),
        //     systemKey: "AD",
        //   ),
        // );
        // context.router.push(
        //     OrderDetailRoute(
        //       order: order.id,
        //       typeOrder: item.typeOrder ?? TypeOrder.cHTH,
        //       isDrafOrder: item.status.id == PrefKeys.idOrderDrafStatus,
        //     ),
        //   );
      }
    });
  }

  // ------------ event to show local noti pop model -----------
  static Future showLocalNoti(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message,
  ) async {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;
    final payload = message.data['order_id'] ?? '';
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      // import channels.dart
      ChannelsDefault.channel_1.id,
      ChannelsDefault.channel_1.name,
      importance: ChannelsDefault.channel_1.importance,
      priority: Priority.high,
      ticker: 'ticker',
      icon: android?.smallIcon,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      notification!.title,
      notification.body,
      notificationDetails,
      payload: payload,
    );
  }

  // ---------- get device token to push notification ----------
  static Future getDeviceToken() async {
    FirebaseMessaging.instance.requestPermission();
    final FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
    final String? deviceToken = await firebaseMessage.getToken();
    print('=========deviceToken$deviceToken');
    return (deviceToken == null) ? '' : deviceToken;
  }
}
