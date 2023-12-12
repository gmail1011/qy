import 'package:fish_redux/fish_redux.dart';

import 'shou_yi_detail_action.dart';
import 'shou_yi_detail_state.dart';

Reducer<ShouYiDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<ShouYiDetailState>>{
      ShouYiDetailAction.refreshUI: _refreshUI,
    },
  );
}

ShouYiDetailState _refreshUI(ShouYiDetailState state, Action action) {
  final ShouYiDetailState newState = state.clone();
  return newState;
}
