import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/wallet/withdraw_config_data.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class WithDrawState extends GlobalBaseState
    with EagleHelper
    implements Cloneable<WithDrawState> {
  FocusNode focusNode;
  TextEditingController moneyController;
  TextEditingController nameController;
  TextEditingController accountController;

  WithdrawConfig configData;
  int withdrawType = 0; // 0支付宝 1银行卡
  int withdrawTypeIndex = 0; // 选中提现方式下标
  num handlingFee = 0; //手续费
  num actualAmount = 0; //实际到账金额

  @override
  WithDrawState clone() {
    return WithDrawState()
      ..configData = configData
      ..moneyController = moneyController
      ..focusNode = focusNode
      ..withdrawType = withdrawType
      ..nameController = nameController
      ..accountController = accountController
      ..handlingFee = handlingFee
      ..actualAmount = actualAmount
      ..withdrawTypeIndex = withdrawTypeIndex;
  }
}

WithDrawState initState(Map<String, dynamic> args) {
  WithDrawState newState = WithDrawState()
    ..focusNode = FocusNode()
    ..moneyController = TextEditingController()
    ..nameController = TextEditingController()
    ..accountController = TextEditingController();

  return newState;
}
