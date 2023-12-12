import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CommunityTabState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommunityTabState>>{
      CommunityTabAction.updateUI: _updateUI,
      CommunityTabAction.updateCommunityList: _updateCommunityList,
    },
  );
}

CommunityTabState _updateUI(CommunityTabState state, Action action) {
  final CommunityTabState newState = state.clone();
  return newState;
}

CommunityTabState _updateCommunityList(CommunityTabState state, Action action) {
  final CommunityTabState newState = state.clone();
  newState.community.addAll(action.payload);
  return newState;
}
