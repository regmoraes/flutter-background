import 'package:flutter/services.dart';

const mainChannelName = 'com.regmoraes.platformchannels/main';
final mainChannel = MethodChannel(mainChannelName);

const backgroundChannelName = 'com.regmoraes.platformchannels/background';
final backgroundChannel = MethodChannel(backgroundChannelName);