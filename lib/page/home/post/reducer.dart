import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<PostState> buildReducer() {
  return asReducer(
    <Object, Reducer<PostState>>{
      PostAction.getAdsSuccess: _getAdsSuccess,
      PostAction.setIsShowTopBtn: _setIsShowTopBtn,
      PostAction.refreshUI: _refreshUI,
      PostAction.getAnnounce: _getAnnounce,
    },
  );
}

PostState _refreshUI(PostState state, Action action) {
  return state.clone();
}

PostState _setIsShowTopBtn(PostState state, Action action) {
  final PostState newState = state.clone();
  newState.showToTopBtn = action.payload;
  return newState;
}

PostState _getAdsSuccess(PostState state, Action action) {
  final PostState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

PostState _getAnnounce(PostState state, Action action) {
  final PostState newState = state.clone();
  newState.announce = action.payload;
  return newState;
}
