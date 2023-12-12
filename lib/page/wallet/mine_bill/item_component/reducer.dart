import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MineBillItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineBillItemState>>{
      MineBilleItemAction.action: _onAction,
    },
  );
}

MineBillItemState _onAction(MineBillItemState state, Action action) {
  final MineBillItemState newState = state.clone();
  return newState;
}
