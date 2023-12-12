import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RecordingState> buildReducer() {
  return asReducer(
    <Object, Reducer<RecordingState>>{
      RecordingAction.action: _onAction,
    },
  );
}

RecordingState _onAction(RecordingState state, Action action) {
  final RecordingState newState = state.clone();
  return newState;
}
