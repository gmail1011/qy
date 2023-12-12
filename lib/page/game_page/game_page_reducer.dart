import 'package:fish_redux/fish_redux.dart';

import 'game_page_action.dart';
import 'game_page_state.dart';

Reducer<GamePageState> buildReducer() {
  return asReducer(
    <Object, Reducer<GamePageState>>{
      GamePageAction.action: _onAction,
    },
  );
}

GamePageState _onAction(GamePageState state, Action action) {
  final GamePageState newState = state.clone();
  return newState;
}
