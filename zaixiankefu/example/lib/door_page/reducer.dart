import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DoorState> buildReducer() {
  return asReducer(
    <Object, Reducer<DoorState>>{
      DoorAction.action: _onAction,
    },
  );
}

DoorState _onAction(DoorState state, Action action) {
  final DoorState newState = state.clone();
  return newState;
}
