import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class YuePaoVerificationState implements Cloneable<YuePaoVerificationState> {
  
  TextEditingController editingController = TextEditingController();
  // id
  String productID = '';
  // 上传的本地图片地址
  List<String> localPicList = [];
  @override
  YuePaoVerificationState clone() {
    return YuePaoVerificationState()
    ..localPicList = localPicList
    ..editingController = editingController
    ..productID = productID;
  }
}

YuePaoVerificationState initState(Map<String, dynamic> args) {
  var map = args??{};
  return YuePaoVerificationState()
  ..productID = map['productID']??'';
}
