import 'package:flutter/material.dart';
import 'package:platform_channels/channels.dart';

import 'flutter_dispatcher.dart';
import 'native_dispatcher.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
    initializePlatformChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'Envio de Comprovantes Agendado: ${_scheduled ? 'Sim': 'Não'}',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await backgroundChannel.invokeMethod("schedule");
          setState(() => _scheduled = result);
        },
        tooltip: 'Schedule',
        child: Icon(Icons.timer),
      ),
    );
  }
}
