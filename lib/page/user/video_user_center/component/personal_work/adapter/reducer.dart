import 'package:fish_redux/fish_redux.dart';

import '../state.dart';
import 'action.dart';

Reducer<UserWorkPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserWorkPostState>>{
      UserWorkAction.action: _onAction,
    },
  );
}

UserWorkPostState _onAction(UserWorkPostState state, Action action) {
  final UserWorkPostState newState = state.clone();
  return newState;
}
