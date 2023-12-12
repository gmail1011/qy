import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MineWorkState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineWorkState>>{
      MineWorkAction.onRefreshWork: _onRefreshWork,
     
    },
  );
}

///作品
MineWorkState _onRefreshWork(MineWorkState state, Action action) {
  final MineWorkState newState = state.clone();
  return newState;
}


