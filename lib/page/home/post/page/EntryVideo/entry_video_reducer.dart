import 'package:fish_redux/fish_redux.dart';

import 'entry_video_action.dart';
import 'entry_video_state.dart';

Reducer<EntryVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<EntryVideoState>>{
      EntryVideoAction.action: _onAction,
      EntryVideoAction.initData: _oninitData,
      EntryVideoAction.initData1: _oninitData1,
      EntryVideoAction.getCountDownTime: _onCountDownTime,
      EntryVideoAction.onSelected: _onSelected,

      EntryVideoAction.onDataLoadMore: _onLoadMore,
      EntryVideoAction.onDataLoadMore1: _onLoadMore1,

      EntryVideoAction.isBeforeToday: _onIsBeforeToday,
    },
  );
}

EntryVideoState _onAction(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  return newState;
}


EntryVideoState _oninitData(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.entryVideoData = action.payload;
  return newState;
}

EntryVideoState _oninitData1(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.entryVideoData1 = action.payload;
  return newState;
}

EntryVideoState _onCountDownTime(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.countDownTime = action.payload;
  return newState;
}

EntryVideoState _onSelected(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.activityId = action.payload;
  return newState;
}

EntryVideoState _onLoadMore(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

EntryVideoState _onLoadMore1(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.pageNumber1 = action.payload;
  return newState;
}

EntryVideoState _onIsBeforeToday(EntryVideoState state, Action action) {
  final EntryVideoState newState = state.clone();
  newState.isBeforeToday = action.payload;
  return newState;
}
