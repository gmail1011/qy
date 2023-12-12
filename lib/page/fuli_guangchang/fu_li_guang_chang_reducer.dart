import 'package:fish_redux/fish_redux.dart';

import 'fu_li_guang_chang_action.dart';
import 'fu_li_guang_chang_state.dart';

Reducer<FuLiGuangChangState> buildReducer() {
  return asReducer(
    <Object, Reducer<FuLiGuangChangState>>{
      FuLiGuangChangAction.action: _onAction,
    },
  );
}

FuLiGuangChangState _onAction(FuLiGuangChangState state, Action action) {
  final FuLiGuangChangState newState = state.clone();
  return newState;
}
