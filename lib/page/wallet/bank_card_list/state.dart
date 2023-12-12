import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class BankCardListState with EagleHelper implements Cloneable<BankCardListState> {
  ApBankListModel model;
  TextEditingController actController;
  TextEditingController actNameController;
  bool isLoading = true;
  String lastAccountName; //保存最近使用的银行卡
  String validatedBankName; //已经验证过的银行名称

  @override
  BankCardListState clone() {
    return BankCardListState()
      ..model = model
      ..actController = actController
      ..actNameController = actNameController
      ..isLoading = isLoading
      ..lastAccountName = lastAccountName
      ..validatedBankName = validatedBankName;
  }
}

BankCardListState initState(Map<String, dynamic> args) {
  return BankCardListState()
  ..actController = new TextEditingController()
  ..actNameController = new TextEditingController();
}
