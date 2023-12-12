import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';

//TODO replace with your own action
enum GameIncomeRecordAction {
  action,
  refreshData,
  setLoadData,
  loadData,
  loadMoreData,
  setMoreData
}

class GameIncomeRecordActionCreator {
  static Action onAction() {
    return const Action(GameIncomeRecordAction.action);
  }

  static Action refreshData(UserIncomeModel model) {
    return Action(GameIncomeRecordAction.refreshData, payload: model);
  }

  static Action onLoadData() {
    return const Action(GameIncomeRecordAction.loadData);
  }

  static Action loadMoreData() {
    return const Action(GameIncomeRecordAction.loadMoreData);
  }

  static Action onSetLoadData(GamePromotionData gamePromotionData) {
    return Action(GameIncomeRecordAction.setLoadData,
        payload: gamePromotionData);
  }

  static Action onSetMoreData(GamePromotionData gamePromotionData) {
    return Action(GameIncomeRecordAction.setMoreData,
        payload: gamePromotionData);
  }
}
