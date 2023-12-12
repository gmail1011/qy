import 'package:fish_redux/fish_redux.dart';

import 'qian_dao_action.dart';
import 'qian_dao_state.dart';

Reducer<qian_daoState> buildReducer() {
  return asReducer(
    <Object, Reducer<qian_daoState>>{
      qian_daoAction.action: _onAction,
      qian_daoAction.adsLists: _getAds,
      qian_daoAction.dayMark: _getDayMark,
      qian_daoAction.isSign: _isSign,
    },
  );
}

qian_daoState _onAction(qian_daoState state, Action action) {
  final qian_daoState newState = state.clone();
  return newState;
}

qian_daoState _getAds(qian_daoState state, Action action) {
  final qian_daoState newState = state.clone();
  newState.resultList = action.payload;
  return newState;
}

qian_daoState _getDayMark(qian_daoState state, Action action) {
  final qian_daoState newState = state.clone();
  newState.dayMarkData = action.payload;
  return newState;
}

qian_daoState _isSign(qian_daoState state, Action action) {
  final qian_daoState newState = state.clone();
  newState.isSign = action.payload;
  return newState;
}
