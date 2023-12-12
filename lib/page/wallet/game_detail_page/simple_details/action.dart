import 'package:fish_redux/fish_redux.dart';

enum WithdrawDetailsAction {
  loadData,
  onLoadData,
  onRefreshData,
  onError,
  showReason
}

class WithdrawDetailsActionCreator {
  static Action onRefreshData(model) {
    return Action(WithdrawDetailsAction.onRefreshData, payload: model);
  }

  static Action loadData() {
    return Action(WithdrawDetailsAction.loadData);
  }

  static Action onLoadData(map) {
    return Action(WithdrawDetailsAction.onLoadData, payload: map);
  }

  static Action onError(msg) {
    return Action(WithdrawDetailsAction.onLoadData, payload: msg);
  }

  static Action showReason(msg) {
    return Action(WithdrawDetailsAction.showReason, payload: msg);
  }
}
