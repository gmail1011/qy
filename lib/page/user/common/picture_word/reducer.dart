import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PictureWordState> buildReducer() {
  return asReducer(
    <Object, Reducer<PictureWordState>>{
      PictureWordAction.updateUI: _updateUI,
    },
  );
}

PictureWordState _updateUI(PictureWordState state, Action action) {
  final PictureWordState newState = state.clone();
  return newState;
}
