import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:path/path.dart' as path;

import 'action.dart';
import 'state.dart';

Reducer<VideoItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoItemState>>{
      VideoItemAction.buyProductSuccess: _buyProductSuccess,
      VideoItemAction.commentSuccess: _commentSuccess,
      VideoItemAction.refreshFollowStatus: _refreshFollowStatus,
      VideoItemAction.refreshUI: _refreshUI,
      VideoItemAction.refresh: _refresh,
      VideoItemAction.shareSuccess: _shareSuccess,
    },
  );
}

///刷新界面
VideoItemState _refreshUI(VideoItemState state, Action action) {
  if (state.uniqueId != action.payload) {
    return state;
  }
  return state.clone();
}

///刷新界面
VideoItemState _refresh(VideoItemState state, Action action) {
  VideoItemState newState = state.clone();
  return newState;
}

VideoItemState _refreshFollowStatus(VideoItemState state, Action action) {
  VideoItemState newState = state.clone();
  String uniqueId = action.payload;
  if (uniqueId != state.uniqueId) {
    return state;
  }
  return newState;
}

///购买商品成功
VideoItemState _buyProductSuccess(VideoItemState state, Action action) {
  if (state.uniqueId == action.payload) {
    final VideoItemState newState = state.clone();

    newState.videoModel.vidStatus.hasPaid = true;
    if (state.videoModel.isImg()) {
      for (int i = 0; i < newState.videoModel.seriesCover.length; i++) {
        newState.videoModel.seriesCover[i] = path.join(
            Address.baseImagePath, newState.videoModel.seriesCover[i]);
      }
    }
    return newState;
  }
  return state;
}

///评论成功
VideoItemState _commentSuccess(VideoItemState state, Action action) {
  if (state.uniqueId == action.payload) {
    final VideoItemState newState = state.clone();
    newState.videoModel.commentCount = newState.videoModel.commentCount + 1;
    return newState;
  }
  return state;
}

///分享成功
VideoItemState _shareSuccess(VideoItemState state, Action action) {
  final VideoItemState newState = state.clone();
  newState.videoModel.shareCount = action.payload;
  return newState;
}
