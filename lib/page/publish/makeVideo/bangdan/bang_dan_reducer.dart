import 'package:fish_redux/fish_redux.dart';

import 'bang_dan_action.dart';
import 'bang_dan_state.dart';

Reducer<BangDanState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangDanState>>{
      BangDanAction.action: _onAction,
    },
  );
}

BangDanState _onAction(BangDanState state, Action action) {
  final BangDanState newState = state.clone();
  return newState;
}
