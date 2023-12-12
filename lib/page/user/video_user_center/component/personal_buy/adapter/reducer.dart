import 'package:fish_redux/fish_redux.dart';

import '../state.dart';
import 'action.dart';

Reducer<UserBuyPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserBuyPostState>>{
      UserBuyAction.action: _onAction,
    },
  );
}

UserBuyPostState _onAction(UserBuyPostState state, Action action) {
  final UserBuyPostState newState = state.clone();
  return newState;
}
