import 'package:fish_redux/fish_redux.dart';

import '../state.dart';
import 'action.dart';

Reducer<MineLikePostState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineLikePostState>>{
      MineLikeAction.action: _onAction,
    },
  );
}

MineLikePostState _onAction(MineLikePostState state, Action action) {
  final MineLikePostState newState = state.clone();
  return newState;
}
