import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WishlistState> buildReducer() {
  return asReducer(
    <Object, Reducer<WishlistState>>{
      WishlistAction.action: _onAction,
    },
  );
}

WishlistState _onAction(WishlistState state, Action action) {
  final WishlistState newState = state.clone();
  return newState;
}
