import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VIPState> buildReducer() {
  return asReducer(
    <Object, Reducer<VIPState>>{
      VIPAction.updateUI: _updateUI,
      VIPAction.changeItem: _onChangeItem,
    },
  );
}

VIPState _updateUI(VIPState state, Action action) {
  final VIPState newState = state.clone();
  return newState;
}

VIPState _onChangeItem(VIPState state, Action action) {
  Map map = action.payload as Map;
  return state.clone()..selectVipItem = map["vipItem"]..tabIndex = map["index"];
}
