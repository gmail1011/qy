import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UserBuyPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<UserBuyPostState>>{
      UserBuyPostAction.loadDataFail: _loadDataFail,
      UserBuyPostAction.loadDataSuccess: _loadDataSuccess,
    },
  );
}

UserBuyPostState _loadDataFail(UserBuyPostState state, Action action) {
  final UserBuyPostState newState = state.clone();
  return newState;
}

UserBuyPostState _loadDataSuccess(UserBuyPostState state, Action action) {
  final UserBuyPostState newState = state.clone();
  newState.videoList.addAll(action.payload);
  return newState;
}
