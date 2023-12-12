import 'package:fish_redux/fish_redux.dart';

import 'ren_wu_action.dart';
import 'ren_wu_state.dart';

Reducer<RenWuState> buildReducer() {
  return asReducer(
    <Object, Reducer<RenWuState>>{
      RenWuAction.action: _onAction,
      RenWuAction.task: _onTask,
    },
  );
}

RenWuState _onAction(RenWuState state, Action action) {
  final RenWuState newState = state.clone();
  return newState;
}

RenWuState _onTask(RenWuState state, Action action) {
  final RenWuState newState = state.clone();
  newState.taskData = action.payload;
  return newState;
}
