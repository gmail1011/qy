import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';

enum MineFollowAction {
  onRefresh,
  onLoadMore,
  onFollow,
  onFollowOkay,
  onRefreshOkay,
  onLoadMoreOkay,
}

class MineFollowActionCreator {
  static Action onRefresh() {
    return const Action(MineFollowAction.onRefresh);
  }

  static Action onLoadMore() {
    return const Action(MineFollowAction.onLoadMore);
  }

  static Action onFollow(int index) {
    return Action(MineFollowAction.onFollow, payload: index);
  }

  static Action onFollowOkay(int index, bool follow) {
    return Action(MineFollowAction.onFollowOkay,
        payload: {"index": index, "follow": follow});
  }

  static Action onRefreshOkay(List<WatchModel> list) {
    return Action(MineFollowAction.onRefreshOkay, payload: list);
  }

  static Action onLoadMoreOkay(List<WatchModel> list) {
    return Action(MineFollowAction.onLoadMoreOkay, payload: list);
  }
}
