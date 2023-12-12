import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AgentRecordState> buildReducer() {
  return asReducer(
    <Object, Reducer<AgentRecordState>>{
      AgentRecordAction.action: _onAction,
    },
  );
}

AgentRecordState _onAction(AgentRecordState state, Action action) {
  final AgentRecordState newState = state.clone();
  return newState;
}
