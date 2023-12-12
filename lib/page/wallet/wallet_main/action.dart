import 'package:fish_redux/fish_redux.dart';

/// 交互事件
enum WalletAction {
  backAction,
  openMyBillAction,
  openMyIncomeAction,
  withdraw,
  setRechargeList,
  setNakeChatRechargeList,
  selctItem,
  selctNakeChatItem,
}

class WalletActionCreator {
  static Action onBack() {
    return const Action(WalletAction.backAction);
  }

  static Action selctItem(int index) {
    return Action(WalletAction.selctItem, payload: index);
  }

  static Action selctNakeChatItem(int index) {
    return Action(WalletAction.selctNakeChatItem, payload: index);
  }

  static Action openMyBill() {
    return const Action(WalletAction.openMyBillAction);
  }

  static Action openMyIncome() {
    return const Action(WalletAction.openMyIncomeAction);
  }

  static Action onWithdraw() {
    return const Action(WalletAction.withdraw);
  }

  static Action setRechargeLists(Map<String, dynamic> param) {
    return Action(WalletAction.setRechargeList, payload: param);
  }

  static Action setNakeChatRechargeLists(Map<String, dynamic> param) {
    return Action(WalletAction.setNakeChatRechargeList, payload: param);
  }
}
