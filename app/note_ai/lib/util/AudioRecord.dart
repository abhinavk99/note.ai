
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


startRecording() async {
  bool hasPerm = await AudioRecorder.hasPermissions;
  bool isRecording = await AudioRecorder.isRecording;
  await AudioRecorder.start(path:"/data/recordings" , audioOutputFormat: AudioOutputFormat.AAC);

}

stopRecording() async {
  Recording recording = await AudioRecorder.stop();
  print("Path : ${recording.path},  Format : ${recording.audioOutputFormat},"
      "  Duration : ${recording.duration},  Extension : ${recording.extension},");
}

_
