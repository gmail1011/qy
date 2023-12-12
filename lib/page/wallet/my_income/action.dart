import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/history_income_model.dart';

enum MyIncomeAction { onBack, withdraw, refreshData, loadData, onRefreshData, onLoadData,updateIncomeAction }

class MyIncomeActionCreator {

  static Action onBack() {
    return const Action(MyIncomeAction.onBack);
  }

  static Action onWithdraw() {
    return const Action(MyIncomeAction.withdraw);
  }

  static Action refreshData() {
    return Action(MyIncomeAction.refreshData);
  }
  static Action loadData() {
    return Action(MyIncomeAction.loadData);
  }
  static Action onRefreshData(HistoryIncomeModel model) {
    return Action(MyIncomeAction.onRefreshData, payload: model);
  }
  static Action onLoadData(map) {
    return Action(MyIncomeAction.onLoadData, payload: map);
  }
  static Action updateIncome(String income) {
    return Action(MyIncomeAction.updateIncomeAction, payload: income);
  }
}
