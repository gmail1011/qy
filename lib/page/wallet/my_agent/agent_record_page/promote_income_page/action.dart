import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/invite_model.dart';

enum PromoteIncomeAction {
  loadData,
  setLoadData,
  loadMoreData,
  setMoreLoadData,
}

class PromoteIncomeActionCreator {
  static Action loadData() {
    return const Action(PromoteIncomeAction.loadData);
  }

  static Action setLoadData(InviteIncomeModel model) {
    return Action(PromoteIncomeAction.setLoadData, payload: model);
  }

  static Action loadMoreData() {
    return const Action(PromoteIncomeAction.loadMoreData);
  }

  static Action setMoreLoadData(List<InviteItem> list) {
    return Action(PromoteIncomeAction.setMoreLoadData, payload: list);
  }
}
