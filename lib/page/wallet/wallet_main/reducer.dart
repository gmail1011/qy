import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

/// UI Controller
Reducer<WalletState> buildReducer() {
  return asReducer(
    <Object, Reducer<WalletState>>{
      WalletAction.setRechargeList: _setRechargeList,
      WalletAction.setNakeChatRechargeList: _setNakeChatRechargeList,
      WalletAction.selctItem: _selctItem,
      WalletAction.selctNakeChatItem: _selctNakeChatItem
    },
  );
}

WalletState _selctItem(WalletState state, Action action) {
  WalletState newState = state.clone();
  var index = action.payload as int;
  newState.selectIndex = index;
  return newState;
}

WalletState _selctNakeChatItem(WalletState state, Action action) {
  WalletState newState = state.clone();
  var index = action.payload as int;
  newState.selectNakeChatIndex = index;
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

/// 给果币充值列表赋值
WalletState _setNakeChatRechargeList(WalletState state, Action action) {
  WalletState newState = state.clone();
  newState.nakeChatRechargeType = action.payload["rechargeList"];
  if (action.payload["dcModel"] != null) {
    newState.nakeChatDcModel = action.payload["dcModel"];
  }
  return newState;
}