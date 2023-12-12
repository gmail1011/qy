import 'package:fish_redux/fish_redux.dart';

import 'common_post_detail_action.dart';
import 'common_post_detail_state.dart';

Reducer<common_post_detailState> buildReducer() {
  return asReducer(
    <Object, Reducer<common_post_detailState>>{
      common_post_detailAction.action: _onAction,
      common_post_detailAction.initData: _onInitData,
      common_post_detailAction.selectedData: _onSelectedData,
    },
  );
}

common_post_detailState _onAction(common_post_detailState state, Action action) {
  final common_post_detailState newState = state.clone();
  return newState;
}

common_post_detailState _onInitData(common_post_detailState state, Action action) {
  final common_post_detailState newState = state.clone();
  newState.liaoBaHistoryData = action.payload;
  return newState;
}

common_post_detailState _onSelectedData(common_post_detailState state, Action action) {
  final common_post_detailState newState = state.clone();
  newState.selectedBean = action.payload;
  return newState;
}
