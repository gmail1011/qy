import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VoiceState> buildReducer() {
  return asReducer(
    <Object, Reducer<VoiceState>>{
      VoiceAction.action: _onAction,
    },
  );
}

VoiceState _onAction(VoiceState state, Action action) {
  final VoiceState newState = state.clone();
  return newState;
}
