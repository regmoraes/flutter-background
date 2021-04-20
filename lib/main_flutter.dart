import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_channels/jobexecutor.dart';
import 'package:platform_channels/message_bloc.dart';
import 'package:platform_channels/notifications.dart';
import 'package:platform_channels/scheduler.dart';
import 'package:workmanager/workmanager.dart';

import 'flutter_dispatcher.dart';

MessageBloc messageBloc;

MessageBloc get() {
  if (messageBloc == null) messageBloc = MessageBloc();
  return messageBloc;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) {
          final pa = get();
          return pa;
        },
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Workmanager.initialize(workManagerCallbackDispatcher);
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: JobExecutor.listenPort(),
              builder: (context, snapshot) {
                print('snapshot is: $snapshot');
                return snapshot.hasData
                    ? Center(
                        child: Container(
                          color: Colors.red,
                          child: Text('Receiving: ${snapshot.data}'),
                        ),
                      )
                    : Container();
              },
            ),
            BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                return Text('Current count is: ${state.count}');
              },
            )
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                scheduleJob();
                print('Job scheduled');
              },
              tooltip: 'Schedule',
              child: Icon(Icons.timer),
            ),
            FloatingActionButton(
              onPressed: () async {
                context.read<MessageBloc>().add(MessageEvent('pa'));
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
            ),
          ],
        ));
  }
}
