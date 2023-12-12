import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UserWorkPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserWorkPostState>>{
      UserWorkPostAction.loadDataSuccess: _loadDataSuccess,
      UserWorkPostAction.loadDataFail:_loadDataFail,
      UserWorkPostAction.initView:_initView,
    },
  );
}

UserWorkPostState _loadDataSuccess(UserWorkPostState state, Action action) {
  final UserWorkPostState newState = state.clone();
  state.videoList.addAll(action.payload);
  state.loadComplete = true;
  //state.works.list.addAll(action.payload);
  return newState;
}

UserWorkPostState _loadDataSuccess1(UserWorkPostState state, Action action) {
  final UserWorkPostState newState = state.clone();
  //state.videoList.addAll(action.payload);
  //state.loadComplete = true;
  state.works.list.addAll(action.payload);
  return newState;
}

UserWorkPostState _loadDataFail(UserWorkPostState state, Action action) {
  final UserWorkPostState newState = state.clone();
  return newState;
}

UserWorkPostState _initView(UserWorkPostState state, Action action) {
  final UserWorkPostState newState = UserWorkPostState();
  newState.uniqueId = state.uniqueId;
  newState.uid = state.uid;
  return newState;
}
