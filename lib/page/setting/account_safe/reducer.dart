import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AccountSafeState> buildReducer() {
  return asReducer(
    <Object, Reducer<AccountSafeState>>{
      AccountSafeAction.refreshUI: _refreshUI,
    },
  );
}

AccountSafeState _refreshUI(AccountSafeState state, Action action) {
  final AccountSafeState newState = state.clone();
  return newState;
}
