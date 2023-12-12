import 'package:fish_redux/fish_redux.dart';

import 'game_page_action.dart';
import 'game_page_state.dart';

Effect<GamePageState> buildEffect() {
  return combineEffects(<Object, Effect<GamePageState>>{
    GamePageAction.action: _onAction,
  });
}

void _onAction(Action action, Context<GamePageState> ctx) {
}
