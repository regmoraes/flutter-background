import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initializeNotifications() {
  var initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (id, title, body, payload) async {
      // your call back to the UI
    },
  );

  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  return FlutterLocalNotificationsPlugin().initialize(
    initializationSettings,
  );
}

Future<void> showNotification(String message) async {
  var androidChannelSpecifics = AndroidNotificationDetails(
    'CHANNEL_ID',
    'CHANNEL_NAME',
    "CHANNEL_DESCRIPTION",
    importance: Importance.low,
    priority: Priority.defaultPriority,
    styleInformation: DefaultStyleInformation(false, false),
  );
  var iosChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidChannelSpecifics,
    iOS: iosChannelSpecifics,
  );

  await FlutterLocalNotificationsPlugin().show(
    1, // Notification ID
    'Cobli', // Notification Title
    message, // Notification Body, set as null to remove the body
    platformChannelSpecifics,
  );
}
