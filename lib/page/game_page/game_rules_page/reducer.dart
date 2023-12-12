import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<GameRulesState> buildReducer() {
  return asReducer(
    <Object, Reducer<GameRulesState>>{
      GameRulesAction.action: _onAction,
    },
  );
}

GameRulesState _onAction(GameRulesState state, Action action) {
  final GameRulesState newState = state.clone();
  return newState;
}
