import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UserLikePostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserLikePostState>>{
      UserLikePostAction.loadDataFail: _loadDataFail,
      UserLikePostAction.loadDataSuccess: _loadDataSuccess,
      UserLikePostAction.initView:_initView,
    },
  );
}

UserLikePostState _loadDataFail(UserLikePostState state, Action action) {
  final UserLikePostState newState = state.clone();
  return newState;
}

UserLikePostState _loadDataSuccess(UserLikePostState state, Action action) {
  final UserLikePostState newState = state.clone();
  newState.videoList.addAll(action.payload);
  return newState;
}

UserLikePostState _initView(UserLikePostState state, Action action) {
  final UserLikePostState newState = UserLikePostState();
  newState.uniqueId = state.uniqueId;
  newState.uid = state.uid;
  return newState;
}
