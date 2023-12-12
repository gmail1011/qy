import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

/// 交互事件
enum WalletAction {
  backAction,
  openMyBillAction,
  openMyIncomeAction,
  withdraw,
  setRechargeList,
  selctItem,
  selctBannerItem,
  refreshAmount,
  getAds,
}

class WalletActionCreator {
  static Action onBack() {
    return const Action(WalletAction.backAction);
  }

  static Action selctItem(int index) {
    return Action(WalletAction.selctItem, payload: index);
  }

  static Action selctBannerItem(int index) {
    return Action(WalletAction.selctBannerItem, payload: index);
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

  static Action refreshAmount(int amount) {
    return const Action(WalletAction.refreshAmount);
  }

  static Action getAds(List<AdsInfoBean> resultList) {
    return  Action(WalletAction.getAds,payload: resultList);
  }
}
