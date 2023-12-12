import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BindingPhoneSuccessState> buildReducer() {
  return asReducer(
    <Object, Reducer<BindingPhoneSuccessState>>{
      BindingPhoneSuccessAction.action: _onAction,
    },
  );
}

BindingPhoneSuccessState _onAction(BindingPhoneSuccessState state, Action action) {
  final BindingPhoneSuccessState newState = state.clone();
  return newState;
}
