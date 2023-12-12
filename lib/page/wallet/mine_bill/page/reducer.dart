import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MineBillState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineBillState>>{
      MineBillAction.loadDataSuccess: _loadDataSuccess,
      MineBillAction.loadDataFail:_loadDataFail,
    },
  );
}

MineBillState _loadDataSuccess(MineBillState state, Action action) {
  final MineBillState newState = state.clone();
  return newState;
}

MineBillState _loadDataFail(MineBillState state, Action action) {
  final MineBillState newState = state.clone();
  newState.dataIsNormal = false;
  newState.requestComplete = true;
  return newState;
}
