import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<PromoteHomeState> buildEffect() {
  return combineEffects(<Object, Effect<PromoteHomeState>>{
    PromoteHomeAction.action: _onAction,
  });
}

void _onAction(Action action, Context<PromoteHomeState> ctx) {
}
