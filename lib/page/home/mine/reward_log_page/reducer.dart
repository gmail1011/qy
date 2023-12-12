import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<RewardLogState> buildReducer() {
  return asReducer(
    <Object, Reducer<RewardLogState>>{
      RewardLogAction.onRefreshOkay: _onRefreshOkay,
    },
  );
}

RewardLogState _onRefreshOkay(RewardLogState state, Action action) {
  var map = action.payload;
  final RewardLogState newState = state.clone()
  ..pageNum = map['pageNumber']
  ..list.addAll(map['list']);
  return newState;
}
