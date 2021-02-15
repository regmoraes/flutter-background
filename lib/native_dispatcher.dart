import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:platform_channels/channels.dart';

void initializePlatformChannel() {
  final callbackHandle = PluginUtilities.getCallbackHandle(callbackDispatcher);

  print("Sending Callback Registration to Native");

  backgroundChannel.invokeMethod(
    'initialize',
    callbackHandle.toRawHandle(),
  );
}

void callbackDispatcher() {
  print("I was executed");
}