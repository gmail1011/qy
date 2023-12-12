import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<GamePromotionState> buildReducer() {
  return asReducer(
    <Object, Reducer<GamePromotionState>>{
      GamePromotionAction.refreshData: _refreshData,
      GamePromotionAction.setUserData: _setUserData,
    },
  );
}

GamePromotionState _refreshData(GamePromotionState state, Action action) {
  final GamePromotionState newState = state.clone();
  newState.gamePromotionData = action.payload;
  return newState;
}

GamePromotionState _setUserData(GamePromotionState state, Action action) {
  final GamePromotionState newState = state.clone();
  newState.userIncomeModel = action.payload;
  return newState;
}
