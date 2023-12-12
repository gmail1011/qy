import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';

//TODO replace with your own action
enum SexyPlazaAction { action ,getAdSuccess , loadDataSuccess, onLoadMore}

class SexyPlazaActionCreator {
  static Action onAction() {
    return const Action(SexyPlazaAction.action);
  }

  static Action getAdsSuccess(List<AdsInfoBean> list) {
    return Action(SexyPlazaAction.getAdSuccess, payload: list);
  }

  static Action loadDataSuccess(List<PostItemState> list) {
    return Action(SexyPlazaAction.loadDataSuccess, payload: list);
  }

  static Action onLoadMore(int pageNumber) {
    return Action(SexyPlazaAction.onLoadMore, payload: pageNumber);
  }
}
