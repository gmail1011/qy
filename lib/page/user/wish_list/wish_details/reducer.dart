import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WishDetailsState> buildReducer() {
  return asReducer(
    <Object, Reducer<WishDetailsState>>{
      WishDetailsAction.updateUI: _updateUI,
    },
  );
}

WishDetailsState _updateUI(WishDetailsState state, Action action) {
  final WishDetailsState newState = state.clone();
  return newState;
}
