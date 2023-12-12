import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VoiceAnchorListState> buildReducer() {
  return asReducer(
    <Object, Reducer<VoiceAnchorListState>>{
      VoiceAnchorListAction.action: _onAction,
    },
  );
}

VoiceAnchorListState _onAction(VoiceAnchorListState state, Action action) {
  final VoiceAnchorListState newState = state.clone();
  return newState;
}
