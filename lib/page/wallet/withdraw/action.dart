import 'package:fish_redux/fish_redux.dart';

enum WithDrawAction {
  changeWithdrawType,
  refreshUI,
  submitWithdraw,
  clearInputData,
  calcWithdrawAmount,
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
}
