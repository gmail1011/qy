import 'package:fish_redux/fish_redux.dart';

import 'sexy_plaza_action.dart';
import 'sexy_plaza_state.dart';

Reducer<SexyPlazaState> buildReducer() {
  return asReducer(
    <Object, Reducer<SexyPlazaState>>{
      SexyPlazaAction.action: _onAction,
      SexyPlazaAction.getAdSuccess: _getAdsSuccess,
      SexyPlazaAction.loadDataSuccess: _loadDataSuccess,
      SexyPlazaAction.onLoadMore: _loadMore,
    },
  );
}

SexyPlazaState _onAction(SexyPlazaState state, Action action) {
  final SexyPlazaState newState = state.clone();
  return newState;
}

SexyPlazaState _getAdsSuccess(SexyPlazaState state, Action action) {
  final SexyPlazaState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

SexyPlazaState _loadDataSuccess(SexyPlazaState state, Action action) {
  final SexyPlazaState newState = state.clone();
  state.videoList.addAll(action.payload);
  state.loadComplete = true;
  return newState;
}

SexyPlazaState _loadMore(SexyPlazaState state, Action action) {
  final SexyPlazaState newState = state.clone();
  state.pageNum = action.payload;
  return newState;
}
