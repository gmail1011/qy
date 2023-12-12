import 'package:fish_redux/fish_redux.dart';

import 'community_detail_action.dart';
import 'community_detail_state.dart';

Reducer<CommunityDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommunityDetailState>>{
      CommunityDetailAction.action: _onAction,
      CommunityDetailAction.updateUI: _updateUI,
      CommunityDetailAction.getAds: _onGetAds,
      CommunityDetailAction.getVideoModel: getVideoModel,
      CommunityDetailAction.pausePlay: pausePlay,
      CommunityDetailAction.startPlay: startPlay,
    },
  );
}

CommunityDetailState _updateUI(CommunityDetailState state, Action action) {
  final CommunityDetailState newState = state.clone();
  return newState;
}

CommunityDetailState _onAction(CommunityDetailState state, Action action) {
  final CommunityDetailState newState = state.clone();
  return newState;
}

CommunityDetailState _onGetAds(CommunityDetailState state, Action action) {
  final CommunityDetailState newState = state.clone();
  newState.adsList = action.payload;
  return newState;
}

CommunityDetailState getVideoModel(CommunityDetailState state, Action action) {
  final CommunityDetailState newState = state.clone();
  newState.videoModel = action.payload;
  return newState;
}

CommunityDetailState pausePlay(CommunityDetailState state, Action action) {
   if (state.chewieController != null) {
     state.chewieController.pause();
   }
   return state.clone();
}

CommunityDetailState startPlay(CommunityDetailState state, Action action) {
  if (state.chewieController != null) {
    state.chewieController.play();
  }
  return state.clone();
}
