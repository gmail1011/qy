import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MineLikePostState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineLikePostState>>{
      MineLikePostAction.loadDataFail: _loadDataFail,
      MineLikePostAction.loadDataSuccess: _loadDataSuccess,
      //MineLikePostAction.loadDataSuccess: _loadDataSuccess1,
      MineLikePostAction.initView:_initView,
      MineLikePostAction.setLoadFinish:_setLoadFinish,
    },
  );
}

MineLikePostState _loadDataFail(MineLikePostState state, Action action) {
  final MineLikePostState newState = state.clone();
  return newState;
}

MineLikePostState _loadDataSuccess(MineLikePostState state, Action action) {
  final MineLikePostState newState = state.clone();
  newState.videoList.addAll(action.payload);
  return newState;
}

MineLikePostState _loadDataSuccess1(MineLikePostState state, Action action) {
  final MineLikePostState newState = state.clone();
  newState.works = action.payload;
  return newState;
}

MineLikePostState _initView(MineLikePostState state, Action action) {
  final MineLikePostState newState = MineLikePostState();
  newState.uniqueId = state.uniqueId;
  newState.uid = state.uid;
  return newState;
}

MineLikePostState _setLoadFinish(MineLikePostState state, Action action) {
  MineLikePostState newState = state.clone();
  newState.loadComplete = action.payload;
  return newState;
}
