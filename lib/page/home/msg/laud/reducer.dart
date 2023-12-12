import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LaudState> buildReducer() {
  return asReducer(
    <Object, Reducer<LaudState>>{
      LaudAction.onLoadLaudAction: _onLoadLaud,
    },
  );
}

LaudState _onLoadLaud(LaudState state, Action action) {
  final LaudState newState = state.clone();
  if(newState.laudModelList == null) {
    newState.laudModelList = [];
  }
  newState.laudModelList.addAll(action.payload['data']);
  newState.hasNext = action.payload['haxNext'];
  newState.videoModelList.clear();
  newState.videoModelList.addAll(newState.laudModelList.map((item) => item.video));
  return newState;
}
