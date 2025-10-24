
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChannelsDefault {
  static const AndroidNotificationChannel channel_1 =
      AndroidNotificationChannel(
    'com.example.lhe_manager.urgent', 'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
}