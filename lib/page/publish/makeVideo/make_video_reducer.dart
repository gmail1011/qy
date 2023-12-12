import 'package:fish_redux/fish_redux.dart';

import 'make_video_action.dart';
import 'make_video_state.dart';

Reducer<MakeVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<MakeVideoState>>{
      MakeVideoAction.getDetail: _getDetail,
      MakeVideoAction.setCountDownTime: _onSetCountDownTime,
      MakeVideoAction.bangDanList: _bangDanList,
    },
  );
}

MakeVideoState _bangDanList(MakeVideoState state, Action action) {
  final MakeVideoState newState = state.clone();
  newState.rankTypeList = action.payload;
  return newState;
}

MakeVideoState _getDetail(MakeVideoState state, Action action) {
  final MakeVideoState newState = state.clone();
  newState.entryVideoData = action.payload;
  return newState;
}

MakeVideoState _onSetCountDownTime(MakeVideoState state, Action action) {
  final MakeVideoState newState = state.clone();
  newState.countDownTime = action.payload;
  return newState;
}

