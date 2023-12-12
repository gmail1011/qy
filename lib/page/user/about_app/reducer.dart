import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AboutAppState> buildReducer() {
  return asReducer(
    <Object, Reducer<AboutAppState>>{
      AboutAppAction.copy: _onAction,
    },
  );
}

AboutAppState _onAction(AboutAppState state, Action action) {
  final AboutAppState newState = state.clone();
  return newState;
}
