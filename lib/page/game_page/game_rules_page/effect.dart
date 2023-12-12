import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<GameRulesState> buildEffect() {
  return combineEffects(<Object, Effect<GameRulesState>>{
    GameRulesAction.action: _onAction,
  });
}

void _onAction(Action action, Context<GameRulesState> ctx) {
}
