import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';

enum VideoListAdapterAction {
  buyProductSuccess,
  refreshItemUI,
  commentSuccess,
}

///推荐界面action
class VideoListAdapterActionCreator {
  ///本页面刷新
  static Action buyProductSuccess(VideoItemState oldState) {
    return Action(VideoListAdapterAction.buyProductSuccess, payload: oldState);
  }

  static Action refreshItemUI(VideoItemState oldState) {
    return Action(VideoListAdapterAction.refreshItemUI, payload: oldState);
  }

  static Action commentSuccess(VideoItemState oldState) {
    return Action(VideoListAdapterAction.commentSuccess, payload: oldState);
  }
}
