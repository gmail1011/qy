import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VideoRecordingState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoRecordingState>>{
      VideoRecordingAction.onAction1: _onAction1,
      VideoRecordingAction.onStarVideoRecording: _onStarVideoRecording,
      VideoRecordingAction.onSwitchTime: _onSwitchTime
    },
  );
}

VideoRecordingState _onAction1(VideoRecordingState state, Action action) {
  final VideoRecordingState newState = state.clone();
  Map<String, dynamic> map = action.payload;
  newState.cameras = map['c'];
  newState.controller = map['co'];
  return newState;
}

VideoRecordingState _onStarVideoRecording(VideoRecordingState state, Action action) {
  final VideoRecordingState newState = state.clone();
  int videoRecordStatus = action.payload;
  newState.videoRecordStatus = videoRecordStatus;
  return newState;
}

VideoRecordingState _onSwitchTime(VideoRecordingState state, Action action) {
  final VideoRecordingState newState = state.clone();
  int timeTag = action.payload;
  newState.timeTag = timeTag;
  return newState;
}
