import 'package:fish_redux/fish_redux.dart';

import 'a_v_commentary_action.dart';
import 'a_v_commentary_state.dart';

Reducer<AVCommentaryState> buildReducer() {
  return asReducer(
    <Object, Reducer<AVCommentaryState>>{
      AVCommentaryAction.action: _onAction,
    },
  );
}

AVCommentaryState _onAction(AVCommentaryState state, Action action) {
  final AVCommentaryState newState = state.clone();
  return newState;
}
