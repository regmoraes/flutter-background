import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

class JobExecutor {
  static String _jobPortName = "background-name";

  static bool _sendingData = false;

  static bool get hasJobRunning => _sendingData;

  static Stream<dynamic> listenPort() {
    final ReceivePort foregroundReceivePort = ReceivePort();
    if (IsolateNameServer.registerPortWithName(
        foregroundReceivePort.sendPort, _jobPortName)) {
      print('port registered. Returning stream');
      return foregroundReceivePort.map(
        (event) {
          _sendingData = true;
          return event;
        },
      );
    } else {
      print('Error');
      return Stream.empty();
    }
  }

  static void sendData(int data) {
    print('Sending: $data');
    IsolateNameServer.lookupPortByName(_jobPortName)?.send(data);
  }

  static stopSending() {
    print('Remove port');
    IsolateNameServer.removePortNameMapping(_jobPortName);
  }
}
