import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FilmTvVideoDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<FilmTvVideoDetailState>>{
      FilmTvVideoDetailAction.updateUI: _updateUI,
      FilmTvVideoDetailAction.upddateCurrentPlayDuration:
          _upddateCurrentPlayDuration,
      FilmTvVideoDetailAction.onCountDownTime: _onCountDownTime,
      FilmTvVideoDetailAction.setStopVideoState: _setStopVideoState,
    },
  );
}

FilmTvVideoDetailState _updateUI(FilmTvVideoDetailState state, Action action) {
  final FilmTvVideoDetailState newState = state.clone();
  return newState;
}

FilmTvVideoDetailState _upddateCurrentPlayDuration(
    FilmTvVideoDetailState state, Action action) {
  final FilmTvVideoDetailState newState = state.clone();
  newState.videoInited = false;
  newState.currentPlayDuration = action.payload as int;
  return newState;
}

FilmTvVideoDetailState _setStopVideoState(
    FilmTvVideoDetailState state, Action action) {
  final FilmTvVideoDetailState newState = state.clone();
  newState.isStopPlayStatus = true;
  return newState;
}

///倒计时
FilmTvVideoDetailState _onCountDownTime(
    FilmTvVideoDetailState state, Action action) {
  final FilmTvVideoDetailState newState = state.clone();
  newState.countdownTime = action.payload;
  return newState;
}
