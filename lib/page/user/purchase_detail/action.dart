import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/vip_buy_history.dart';

enum PurchaseDetailAction {
  action,
  loadMore,
  setRefreshDetail,
  setLoadDetails,
  loadData,
}

class PurchaseDetailActionCreator {
  static Action onAction() {
    return const Action(PurchaseDetailAction.action);
  }

  static Action loadData() {
    return const Action(PurchaseDetailAction.loadData);
  }

  static Action setRefreshDetail(List<ListBean> list) {
    return Action(PurchaseDetailAction.setRefreshDetail, payload: list);
  }

  static Action loadMore() {
    return Action(PurchaseDetailAction.loadMore);
  }

  static Action setLoadDetails(List<ListBean> list) {
    return Action(PurchaseDetailAction.setLoadDetails, payload: list);
  }
}
