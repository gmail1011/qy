import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AudiobookRecordState> buildReducer() {
  return asReducer(
    <Object, Reducer<AudiobookRecordState>>{
      AudiobookRecordAction.action: _onAction,
    },
  );
}

AudiobookRecordState _onAction(AudiobookRecordState state, Action action) {
  final AudiobookRecordState newState = state.clone();
  return newState;
}
