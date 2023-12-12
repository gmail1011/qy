import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';

enum WithdrawIncomeAction {
  loadData,
  loadMoreData,
  setLoadData,
  setLoadMoreData,
}

class WithdrawIncomeActionCreator {
  static Action loadData() {
    return const Action(WithdrawIncomeAction.loadData);
  }

  static Action loadMoreData() {
    return const Action(WithdrawIncomeAction.loadMoreData);
  }

  static Action setLoadData(List<ListBean> list) {
    return Action(WithdrawIncomeAction.setLoadData, payload: list);
  }

  static Action setLoadMoreData(List<ListBean> list) {
    return Action(WithdrawIncomeAction.setLoadMoreData, payload: list);
  }
}
