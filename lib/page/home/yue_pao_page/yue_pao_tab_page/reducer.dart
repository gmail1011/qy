import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoTabState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoTabState>>{
      YuePaoTabAction.action: _onAction,
      YuePaoTabAction.getAds: _onGetAds,
      YuePaoTabAction.getAnnounce: _onGetAnnounce,
    },
  );
}

YuePaoTabState _onAction(YuePaoTabState state, Action action) {
  final YuePaoTabState newState = state.clone();
  return newState;
}

YuePaoTabState _onGetAds(YuePaoTabState state, Action action) {
  final YuePaoTabState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

YuePaoTabState _onGetAnnounce(YuePaoTabState state, Action action) {
  final YuePaoTabState newState = state.clone();
  newState.announce = action.payload;
  return newState;
}
