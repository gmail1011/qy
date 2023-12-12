import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PromoteHomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<PromoteHomeState>>{
      PromoteHomeAction.action: _onAction,
    },
  );
}

PromoteHomeState _onAction(PromoteHomeState state, Action action) {
  final PromoteHomeState newState = state.clone();
  return newState;
}
