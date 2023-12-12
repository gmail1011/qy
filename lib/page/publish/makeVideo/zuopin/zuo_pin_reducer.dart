import 'package:fish_redux/fish_redux.dart';

import 'zuo_pin_action.dart';
import 'zuo_pin_state.dart';

Reducer<ZuoPinState> buildReducer() {
  return asReducer(
    <Object, Reducer<ZuoPinState>>{
      ZuoPinAction.action: _onAction,
      ZuoPinAction.getDetail: _onGetDetail,
    },
  );
}

ZuoPinState _onAction(ZuoPinState state, Action action) {
  final ZuoPinState newState = state.clone();
  return newState;
}

ZuoPinState _onGetDetail(ZuoPinState state, Action action) {
  final ZuoPinState newState = state.clone();
  newState.entryVideoData = action.payload;
  return newState;
}
