import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

enum MineAction {
  delVideoItem,
  onUpdateUserInfo,
  onUpdateWalletInfo,
  onHandleBg,
  freeGoldDate,
  refresh,
}

class MineActionCreator {

  static Action onUpdateUserInfo() {
    return Action(MineAction.onUpdateUserInfo);
  }

  static Action onUpdateWalletInfo() {
    return Action(MineAction.onUpdateWalletInfo);
  }

  ///选择处理背景图
  static Action onHandleBg() {
    return Action(MineAction.onHandleBg);
  }

  static Action delVideoItem(VideoModel videoModel) {
    return Action(MineAction.delVideoItem, payload: videoModel);
  }

  ///选择处理背景图
  static Action freeGoldDate(String date) {
    return Action(MineAction.freeGoldDate,payload: date);
  }

  ///下拉刷新
  static Action onRefresh() {
    return Action(MineAction.refresh);
  }
}
