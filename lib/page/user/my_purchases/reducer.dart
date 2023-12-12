import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyPurchasesState> buildReducer() {
  return asReducer(
    <Object, Reducer<MyPurchasesState>>{
      MyPurchasesAction.action: _onAction,
    },
  );
}

MyPurchasesState _onAction(MyPurchasesState state, Action action) {
  final MyPurchasesState newState = state.clone();
  return newState;
}
