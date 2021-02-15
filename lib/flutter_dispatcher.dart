import 'dart:ui';

import 'package:platform_channels/main_flutter.dart';
import 'package:platform_channels/message_bloc.dart';
import 'package:platform_channels/notifications.dart';
import 'package:workmanager/workmanager.dart';

void workManagerCallbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    initializeNotifications();
    final messabloc = get();
    messabloc.add(MessageEvent('progress'));

    await for (final data in messabloc) {
      print('received ${data.count}');

      IsolateNameServer.lookupPortByName("foreground-port")?.send(true);

      await showNotification('Received: ${data.count}');

      if (data.count == 10) {
        print("Will finish");
        break;
      }
    }
    IsolateNameServer.lookupPortByName("foreground-port")?.send(false);
    return true;
  });
}
