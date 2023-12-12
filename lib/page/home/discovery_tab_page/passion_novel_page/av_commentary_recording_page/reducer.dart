import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PassionRecordingState> buildReducer() {
  return asReducer(
    <Object, Reducer<PassionRecordingState>>{
      PassionRecordingAction.action: _onAction,
    },
  );
}

PassionRecordingState _onAction(PassionRecordingState state, Action action) {
  final PassionRecordingState newState = state.clone();
  return newState;
}
