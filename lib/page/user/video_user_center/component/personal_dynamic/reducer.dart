import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UserDynamicPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserDynamicPostState>>{
      UserDynamicPostAction.loadDataSuccess: _loadDataSuccess,
      UserDynamicPostAction.loadDataFail:_loadDataFail,
      UserDynamicPostAction.initView:_initView
    },
  );
}

UserDynamicPostState _loadDataSuccess(UserDynamicPostState state, Action action) {
  final UserDynamicPostState newState = state.clone();
  state.videoList.addAll(action.payload);
  state.loadComplete = true;
  return newState;
}

UserDynamicPostState _loadDataFail(UserDynamicPostState state, Action action) {
  final UserDynamicPostState newState = state.clone();
  return newState;
}

UserDynamicPostState _initView(UserDynamicPostState state, Action action) {
  final UserDynamicPostState newState = UserDynamicPostState();
  newState.uniqueId = state.uniqueId;
  newState.uid = state.uid;
  return newState;
}
