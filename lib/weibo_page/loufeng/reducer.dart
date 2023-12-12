import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<loufengState> buildReducer() {
  return asReducer(
    <Object, Reducer<loufengState>>{
      loufengAction.action: _onAction,
      loufengAction.updateLoading: _updateLoading,
    },
  );
}

loufengState _onAction(loufengState state, Action action) {
  final loufengState newState = state.clone();
  return newState;
}

loufengState _updateLoading(loufengState state, Action action) {
  final loufengState newState = state.clone();
  newState.isLoading = false;
  return newState;
}
