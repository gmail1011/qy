import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LongVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<LongVideoState>>{
      LongVideoAction.updateUI: _updateUI,
    },
  );
}

LongVideoState _updateUI(LongVideoState state, Action action) {
  final LongVideoState newState = state.clone();
  return newState;
}
