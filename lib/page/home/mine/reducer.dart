import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/mine/action.dart';

import 'state.dart';

Reducer<MineState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineState>>{
      MineAction.freeGoldDate: _onFindList,
    },
  );
}


MineState _onFindList(MineState state, Action action) {
  final MineState newState = state.clone()..freeGoldDate = action.payload;
  return newState;
}

