import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<RecoverMobileState> buildEffect() {
  return combineEffects(<Object, Effect<RecoverMobileState>>{
    RecoverMobileAction.action: _onAction,
    Lifecycle.dispose: _disponse,
  });
}

void _onAction(Action action, Context<RecoverMobileState> ctx) {}

void _disponse(Action action, Context<RecoverMobileState> ctx) {
  ctx.state.mobileEditingController?.dispose();
}
