import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VoiceAnchorInfoState> buildReducer() {
  return asReducer(
    <Object, Reducer<VoiceAnchorInfoState>>{
      VoiceAnchorInfoAction.refreshCollect: _refreshCollect,
    },
  );
}

VoiceAnchorInfoState _refreshCollect(
    VoiceAnchorInfoState state, Action action) {
  final VoiceAnchorInfoState newState = state.clone();
  newState.model.isCollect = !newState.model.isCollect;
  if (newState.model.isCollect) {
    newState.model.countCollect++;
  } else {
    newState.model.countCollect--;
  }
  return newState;
}
