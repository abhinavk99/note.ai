import 'dart:io' as io;
import 'dart:math';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:audio_recorder_example/widgets/drawer.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:core';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        drawer: getDrawer(context),
        appBar: new AppBar(
          title: new Text('Note.ai'),
        ),
        body: new AppBody(),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AppBody({localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AppBodyState();
}

class AppBodyState extends State<AppBody> {
  int _recordedtime = 0;
  bool isRecording = false;
  var time = "";
  Timer _timer;
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();

  void _updateTime() {
    if (isRecording) {
      // Stop updating the clock
      _stop();
      setState(() {
        _recordedtime = 0;
      });
      _timer.cancel();
    } else {
      // Continue incrementing our time
      _start();
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
    return new Center(
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
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    _controller.text = recording.path;
  }
}
