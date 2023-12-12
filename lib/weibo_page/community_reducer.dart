import 'package:fish_redux/fish_redux.dart';

import 'community_action.dart';
import 'community_state.dart';

Reducer<CommunityState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommunityState>>{
      CommunityAction.action: _onAction,
      CommunityAction.showNewPersonCutDownTime: _showNewPersonCutDownTime,
    },
  );
}

CommunityState _onAction(CommunityState state, Action action) {
  final CommunityState newState = state.clone();
  return newState;
}

CommunityState _showNewPersonCutDownTime(CommunityState state, Action action) {
  final CommunityState newState = state.clone();
  newState.showCutDownTimeButton = action.payload;
  return newState;
}
