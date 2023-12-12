import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ShortVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<ShortVideoState>>{
      ShortVideoAction.updateUI: _updateUI,
    },
  );
}

ShortVideoState _updateUI(ShortVideoState state, Action action) {
  final ShortVideoState newState = state.clone();
  return newState;
}
