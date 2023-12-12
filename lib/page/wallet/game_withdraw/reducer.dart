import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Reducer<WithDrawState> buildReducer() {
  return asReducer(
    <Object, Reducer<WithDrawState>>{
      WithDrawAction.refreshUI: _refreshUI,
      WithDrawAction.changeWithdrawType: _changeWithdrawType,
      WithDrawAction.clearInputData: _clearInputData,
      WithDrawAction.calcWithdrawAmount: _calcWithdrawAmount,
      WithDrawAction.refreshAmount: _refreshAmount,
    },
  );
}

///更新提现类型
WithDrawState _changeWithdrawType(WithDrawState state, Action action) {
  final WithDrawState newState = state.clone();
  newState.withdrawType = action.payload;
  print(newState.withdrawType);
  return newState;
}

WithDrawState _refreshUI(WithDrawState state, Action action) {
  final WithDrawState newState = state.clone();
  return newState;
}

WithDrawState _clearInputData(WithDrawState state, Action action) {
  final WithDrawState newState = state.clone();
  newState.nameController?.clear();
  newState.accountController?.clear();
  newState.moneyController?.clear();
  return newState;
}

///计算提现手续费、实际到账金额
WithDrawState _calcWithdrawAmount(WithDrawState state, Action action) {
  final WithDrawState newState = state.clone();

  try {
    String withdrawAmount = action.payload;
    if ((withdrawAmount ?? "").isEmpty) {
      newState.handlingFee = 0;
      newState.actualAmount = 0;
    } else {
      num withdrawAmoutNum = num.parse(withdrawAmount);
      int gameTax = state.configData?.gameTax ?? 0;
      if (gameTax == 0) {
        newState.handlingFee = 0;
        newState.actualAmount = withdrawAmoutNum;
      } else {
        newState.handlingFee = withdrawAmoutNum * (gameTax / 100);
        newState.actualAmount = withdrawAmoutNum - newState.handlingFee;
      }
    }
  } catch (e) {
    l.e("计算提现手续费、实际到账金额", "$e");
  }
  return newState;
}

WithDrawState _refreshAmount(WithDrawState state, Action action) {
  WithDrawState newState = state.clone();
  var index = action.payload as int;
  newState.gameBalance = index;
  return newState;
}
