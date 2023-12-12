import 'package:fish_redux/fish_redux.dart';

enum VideoRecordingAction { onAction1 ,onStarVideoRecorder,onStarVideoRecording,onStopVideoRecorder,
  onUploadVideo,onLocalVideo,onSwitchCamera,onSwitchTime,onReLoadVideo}

class VideoRecordingActionCreator {
  static Action onAction1(Map<String,dynamic> map) {
    return Action(VideoRecordingAction.onAction1,payload: map);
  }


  static Action onStarVideoRecorder() {
    return const Action(VideoRecordingAction.onStarVideoRecorder);
  }
  static Action onStarVideoRecording(int videoRecordStatus) {
    return Action(VideoRecordingAction.onStarVideoRecording,payload: videoRecordStatus);
  }


  static Action onStopVideoRecorder() {
    return const Action(VideoRecordingAction.onStopVideoRecorder);
  }

  static Action onUploadVideo(String videoPath) {
    return Action(VideoRecordingAction.onUploadVideo,payload: videoPath);
  }

  static Action onLocalVideo() {
    return Action(VideoRecordingAction.onLocalVideo);
  }

  static Action onSwitchCamera() {
    return Action(VideoRecordingAction.onSwitchCamera);
  }


  static Action onSwitchTime(int timeTag) {
    return Action(VideoRecordingAction.onSwitchTime,payload: timeTag);
  }


  static Action onReLoadVideo() {
    return Action(VideoRecordingAction.onReLoadVideo);
  }

}





