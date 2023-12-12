import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/message/fans_model.dart';

enum FansAction {
  refreshFansAction,
  loadMoreFansAction,
  onLoadFansAction,
  followUserAction,
  refreshUI,
}

class FansActionCreator {
  static Action refreshData() {
    return const Action(FansAction.refreshFansAction);
  }

  static Action loadMoreData() {
    return const Action(FansAction.loadMoreFansAction);
  }

  static Action refreshUI() {
    return const Action(FansAction.refreshUI);
  }

  static Action onLoadFans(List<FansModel> fansList, bool hasNext) {
    return Action(FansAction.onLoadFansAction, payload: {'data': fansList, 'hasNext': hasNext});
  }

  static Action followUser(Map<String, dynamic> map) {
    return Action(FansAction.followUserAction, payload: map);
  }
}
