import 'package:fish_redux/fish_redux.dart';

enum WithDrawAction {
  changeWithdrawType,
  refreshUI,
  submitWithdraw,
  clearInputData,
  calcWithdrawAmount,
  refreshAmount,
}

class WithDrawActionCreator {
  static Action refreshUI() {
    return const Action(WithDrawAction.refreshUI);
  }

  static Action changeWithdrawType(int withdrawType) {
    return Action(WithDrawAction.changeWithdrawType, payload: withdrawType);
  }

  static Action submitWithdraw() {
    return const Action(WithDrawAction.submitWithdraw);
  }

  static Action clearInputData() {
    return const Action(WithDrawAction.clearInputData);
  }

  static Action calcWithdrawAmount(String withdrawAmount) {
    return Action(WithDrawAction.calcWithdrawAmount, payload: withdrawAmount);
  }

  static Action refreshAmount(int amount) {
    return Action(WithDrawAction.refreshAmount);
  }
}
