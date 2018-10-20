import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:async';
import 'package:note_ai/widgets/drawer.dart';
import 'package:note_ai/util/AudioRecord.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Note.ai',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: new MyHomePage(title: 'Note.ai'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _recordedtime = 0;
  bool isRecording = false;
  var time = "";
  Timer _timer;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _updateTime() {
    if (isRecording) {
      // Stop updating the clock
      stopRecording();
      setState(() {
        _recordedtime = 0;
      });
      _timer.cancel();
    } else {
      // Continue incrementing our time
      startRecording();
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer t) {
          setState(() {
            _recordedtime++;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      drawer: getDrawer(context),
      body: new Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
            ),
            Text(
              _recordedtime.toString(),
              style: TextStyle(
                color: Colors.red,
                fontSize: 150.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
            ),
            SizedBox(
              height: 100.0,
              width: 100.0,
              child: RaisedButton(
                color: Colors.red,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  print("Started Recording");
                  isRecording = isRecording ? false : true;
                  _updateTime();
                  // Add code to trigger recording
                },
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 45.0,
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
