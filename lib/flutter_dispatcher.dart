import 'package:platform_channels/jobexecutor.dart';
import 'package:platform_channels/notifications.dart';
import 'package:workmanager/workmanager.dart';

void workManagerCallbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    initializeNotifications();

    final stream = Stream.periodic(Duration(seconds: 1), (count) => count);

    await for (final data in stream) {
      JobExecutor.sendData(data);

      await showNotification('Received: $data');

      if (data == 10) {
        print("Will finish");

        JobExecutor.stopSending();
        break;
      }
    }
    JobExecutor.stopSending();
    return true;
  });
}
