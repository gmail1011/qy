import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WishQuestionState> buildReducer() {
  return asReducer(
    <Object, Reducer<WishQuestionState>>{
      WishQuestionAction.updateUI: _updateUI,
    },
  );
}

WishQuestionState _updateUI(WishQuestionState state, Action action) {
  final WishQuestionState newState = state.clone();
  return newState;
}
