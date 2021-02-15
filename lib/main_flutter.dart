import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_channels/message_bloc.dart';
import 'package:platform_channels/notifications.dart';
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
  bool _scheduled = false;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                return Text('Current count is: ${state.count}');
              },
            ),
            Text(
              'Envio de Comprovantes Agendado: ${_scheduled ? 'Sim' : 'Não'}',
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Workmanager.registerOneOffTask("background-task-id", "schedule",
                  constraints: Constraints(
                    networkType: NetworkType.connected,
                    requiresCharging: true,
                  ));
              setState(() {
                _scheduled = true;
              });
            },
            tooltip: 'Schedule',
            child: Icon(Icons.timer),
          ),
          FloatingActionButton(
            onPressed: () async {
              setState(() {
                context.read<MessageBloc>().add(MessageEvent('pa'));
              });
            },
            tooltip: 'Add',
            child: Icon(Icons.add),
          ),
        ],
      )
    );
  }
}
