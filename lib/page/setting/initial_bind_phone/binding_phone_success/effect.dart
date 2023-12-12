import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<BindingPhoneSuccessState> buildEffect() {
  return combineEffects(<Object, Effect<BindingPhoneSuccessState>>{
    BindingPhoneSuccessAction.action: _onAction,
  });
}

void _onAction(Action action, Context<BindingPhoneSuccessState> ctx) {
}
