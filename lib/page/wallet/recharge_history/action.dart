import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/recharge_history_model.dart';

enum RechargeHistoryAction { backAction, onRequestData, requestData, onError}

class RechargeHistoryActionCreator {
  static Action onBack() {
    return const Action(RechargeHistoryAction.backAction);
  }

  static Action onRequestData(List<RechargeHistoryModel> list) {
    return Action(RechargeHistoryAction.onRequestData, payload: list);
  }

  static Action requestData() {
    return Action(RechargeHistoryAction.requestData);
  }

  static Action onError(msg) {
    return Action(RechargeHistoryAction.onError, payload: msg);
  }
}
