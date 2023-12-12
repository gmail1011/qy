import 'package:fish_redux/fish_redux.dart';

import '../state.dart';
import 'action.dart';

Reducer<UserLikePostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserLikePostState>>{
      UserLikeAction.action: _onAction,
    },
  );
}

UserLikePostState _onAction(UserLikePostState state, Action action) {
  final UserLikePostState newState = state.clone();
  return newState;
}
