import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SearchUserState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchUserState>>{
      SearchUserAction.setLoadData: _setVideoData,
      SearchUserAction.setLoadMoreData: _setLoadMoreData,
      SearchUserAction.setKeywords: _setKeywords,
      SearchUserAction.refreshFollowUser: _refreshFollowUser,
    },
  );
}

SearchUserState _refreshFollowUser(SearchUserState state, Action action) {
  final SearchUserState newState = state.clone();
  var index = action.payload as int;
  var user = newState.searchUsers[index];
  user.hasFollowed = !user.hasFollowed;
  return newState;
}

SearchUserState _setKeywords(SearchUserState state, Action action) {
  final SearchUserState newState = state.clone();
  newState.keywords = action.payload;
  return newState;
}

SearchUserState _setVideoData(SearchUserState state, Action action) {
  final SearchUserState newState = state.clone();
  newState.searchUsers = action.payload;
  newState.pageNumber = 1;
  return newState;
}

SearchUserState _setLoadMoreData(SearchUserState state, Action action) {
  final SearchUserState newState = state.clone();
  newState.searchUsers.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
