import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyCertificationState> buildReducer() {
  return asReducer(
    <Object, Reducer<MyCertificationState>>{
      MyCertificationAction.updateUI: _updateUI,
    },
  );
}

MyCertificationState _updateUI(MyCertificationState state, Action action) {
  final MyCertificationState newState = state.clone();
  return newState;
}
