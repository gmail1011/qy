import 'package:fish_redux/fish_redux.dart';

import 'hot_video_detail_action.dart';
import 'hot_video_detail_state.dart';

Reducer<HotVideoDetailState> buildReducer() {
  return asReducer(
    <Object, Reducer<HotVideoDetailState>>{
      HotVideoDetailAction.action: _onAction,
      HotVideoDetailAction.getHotVideo: _onGetHotVideo,
    },
  );
}

HotVideoDetailState _onAction(HotVideoDetailState state, Action action) {
  final HotVideoDetailState newState = state.clone();
  return newState;
}

HotVideoDetailState _onGetHotVideo(
    HotVideoDetailState state, Action action) {
  final HotVideoDetailState newState = state.clone();
  newState.commonPostResHotVideo = action.payload;
  return newState;
}
