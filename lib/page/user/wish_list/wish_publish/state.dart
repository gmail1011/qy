import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';

class WishPublishState implements Cloneable<WishPublishState> {
  TextEditingController editingController = TextEditingController();
  TextEditingController printEditingController = TextEditingController();
  List<String> localImagePathList = [];
  String setAmountValue;
  var amountArr = Config.releaseMoney ?? [2, 5, 10, 50, 100].toList();

  @override
  WishPublishState clone() {
    return WishPublishState()
      ..editingController = editingController
      ..printEditingController = printEditingController
      ..setAmountValue = setAmountValue
      ..amountArr = amountArr
      ..localImagePathList = localImagePathList;
  }
}

WishPublishState initState(Map<String, dynamic> args) {
  return WishPublishState();
}
