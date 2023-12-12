import 'package:fish_redux/fish_redux.dart';

import 'community_follow_action.dart';
import 'community_follow_state.dart';

Reducer<CommunityFollowState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommunityFollowState>>{
      CommunityFollowAction.action: _onAction,
      CommunityFollowAction.getData: _onGetData,
      CommunityFollowAction.onLoadMore: _onLoadMore,
    },
  );
}

CommunityFollowState _onAction(CommunityFollowState state, Action action) {
  final CommunityFollowState newState = state.clone();
  return newState;
}

CommunityFollowState _onGetData(CommunityFollowState state, Action action) {
  final CommunityFollowState newState = state.clone();
  newState.commonPostRes = action.payload;
  return newState;
}


CommunityFollowState _onLoadMore(CommunityFollowState state, Action action) {
  final CommunityFollowState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}
