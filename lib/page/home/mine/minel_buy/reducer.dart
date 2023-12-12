import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'component/state.dart';
import 'state.dart';

Reducer<MineBuyPostState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineBuyPostState>>{
      MineBuyPostAction.loadDataFail: _loadDataFail,
      MineBuyPostAction.loadDataSuccess: _loadDataSuccess,
      MineBuyPostAction.onDelRefresh: _onDelRefresh,
    },
  );
}

MineBuyPostState _onDelRefresh(MineBuyPostState state, Action action) {
  final MineBuyPostState newState = state.clone();
  var item = action.payload as MineBuyItemState;
  newState.videoList.remove(item);
  return newState;
}

MineBuyPostState _loadDataFail(MineBuyPostState state, Action action) {
  final MineBuyPostState newState = state.clone();
  return newState;
}

MineBuyPostState _loadDataSuccess(MineBuyPostState state, Action action) {
  final MineBuyPostState newState = state.clone();
  newState.videoList.addAll(action.payload);
  return newState;
}
