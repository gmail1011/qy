import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/mine/mine_work/state.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';

enum MineWorkAction {
  onRefreshWork,
  onLoadWork,
  onItemClick,
  delWorkItem,
  getWorkData,
  refreshItem,
}

class MineWorkActionCreator {
  static Action onRefreshItem(MineWorkPageType type) {
    return Action(MineWorkAction.refreshItem, payload: type);
  }

  static Action onRefreshWork(MineVideo model) {
    return Action(MineWorkAction.onRefreshWork, payload: model);
  }

  static Action onGetWorkData() {
    return Action(MineWorkAction.getWorkData);
  }

  static Action onLoadWork() {
    return Action(MineWorkAction.onLoadWork);
  }

  static Action onItemClick(PostItemState state) {
    return Action(MineWorkAction.onItemClick, payload: state);
  }

  static Action delWorkItem(VideoModel videoModel) {
    return Action(MineWorkAction.delWorkItem, payload: videoModel);
  }
}
