import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class AliListState with EagleHelper implements Cloneable<AliListState> {
  List<AccountInfoModel> aliList = [];

  TextEditingController actController;
  TextEditingController actNameController;

  bool isLoading = true;

  String lastAccountName;

  @override
  AliListState clone() {
    return AliListState()
      ..actController = actController
      ..lastAccountName = lastAccountName
      ..actNameController = actNameController
      ..aliList = aliList
      ..isLoading = isLoading;
  }
}

AliListState initState(Map<String, dynamic> args) {
  return AliListState()
    ..actNameController = new TextEditingController()
    ..actController = new TextEditingController();
}
