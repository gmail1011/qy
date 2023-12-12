import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<loufengState> buildEffect() {
  return combineEffects(<Object, Effect<loufengState>>{
    loufengAction.action: _onAction,
  });
}

void _onAction(Action action, Context<loufengState> ctx) {
}
