import 'package:camera/camera.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class VideoRecordingState with EagleHelper implements Cloneable<VideoRecordingState> {
  List<CameraDescription> cameras = [];
  CameraController controller;

  String filePath;

  ///0：未录制   1：录制中   2：录制完成
  int videoRecordStatus = 0;

  ///0:15s    1:2min
  int timeTag = 0;

  @override
  VideoRecordingState clone() {
    VideoRecordingState videoRecordingState = VideoRecordingState();
    videoRecordingState.cameras = cameras;
    videoRecordingState.controller = controller;
    videoRecordingState.videoRecordStatus = videoRecordStatus;
    videoRecordingState.filePath = filePath;
    videoRecordingState.timeTag = timeTag;
    return videoRecordingState;
  }
}

VideoRecordingState initState(Map<String, dynamic> args) {
  VideoRecordingState videoRecordingState = VideoRecordingState();
  return videoRecordingState;
}
