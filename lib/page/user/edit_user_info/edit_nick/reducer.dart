import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EditNickNameState> buildReducer() {
  return asReducer(
    <Object, Reducer<EditNickNameState>>{
      EditNickNameAction.updateUI: _updateUI,
    },
  );
}

EditNickNameState _updateUI(EditNickNameState state, Action action) {
  final EditNickNameState newState = state.clone();
  return newState;
}
