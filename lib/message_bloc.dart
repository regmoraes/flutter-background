import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

class MessageEvent {
  final message;

  MessageEvent(this.message);
}

class MessageState {
  final int count;

  MessageState(this.count);
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  var count = 0;
  final max = 11;
  bool sendingInBackground = false;

  ReceivePort receivePort;
  StreamSubscription receivePortSubscription;

  MessageBloc() : super(MessageState(0)) {
    print('My isolate is: ${Isolate.current.hashCode}');
    print('My instance is: $hashCode');
    receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "foreground-port");
    receivePortSubscription = receivePort.listen((message) {
      sendingInBackground = message;
    });
    sendPendingProofOfConclusion();
  }

  void sendPendingProofOfConclusion() {
    if(sendingInBackground) {
      print('already sending');
    } else {
      print('Enviar direto');
    }
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async*{
    if(event.message == "progress") {
      while(count < max) {
        await Future.delayed(Duration(seconds: 1));
        yield MessageState(count++);
      }
      count = 0;
    } else {
      count++;
      yield MessageState(count);
    }
  }

  @override
  Future<Function> close() {
    receivePortSubscription.cancel();
    IsolateNameServer.removePortNameMapping("foreground-port");
    super.close();
  }
}