import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

/// UI Controller
Reducer<WalletState> buildReducer() {
  return asReducer(
    <Object, Reducer<WalletState>>{
      WalletAction.setRechargeList: _setRechargeList,
      WalletAction.selctItem: _selctItem,
      WalletAction.selctBannerItem: _selctBannerItem,
      WalletAction.refreshAmount: _refreshAmount,
      WalletAction.getAds: _getAds
    },
  );
}


WalletState _getAds(WalletState state, Action action) {
  final WalletState newState = state.clone();
  newState.resultList = action.payload;
  return newState;
}

WalletState _selctItem(WalletState state, Action action) {
  WalletState newState = state.clone();
  var index = action.payload as int;
  newState.selectIndex = index;
  return newState;
}

WalletState _selctBannerItem(WalletState state, Action action) {
  WalletState newState = state.clone();
  var index = action.payload as int;
  newState.selectBannerIndex = index;
  return newState;
}

/// 给充值列表赋值
WalletState _setRechargeList(WalletState state, Action action) {
  WalletState newState = state.clone();
  newState.rechargeType = action.payload["rechargeList"];
  if (action.payload["dcModel"] != null) {
    newState.dcModel = action.payload["dcModel"];
  }
  return newState;
}

WalletState _refreshAmount(WalletState state, Action action) {
  WalletState newState = state.clone();
  var index = action.payload as int;
  newState.amount = index;
  return newState;
}
