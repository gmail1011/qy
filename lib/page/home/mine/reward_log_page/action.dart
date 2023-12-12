import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/reward_list_model.dart';

//TODO replace with your own action
enum RewardLogAction { onLoadMore, onRefreshOkay }

class RewardLogActionCreator {
  static Action onLoadMore() {
    return Action(RewardLogAction.onLoadMore);
  }
  static Action onRefreshOkay(List<RewardItem> list, int pageNumber) {
    return Action(RewardLogAction.onRefreshOkay, payload: {
      'list' : list??[],
      'pageNumber' : pageNumber,
    });
  }
}
