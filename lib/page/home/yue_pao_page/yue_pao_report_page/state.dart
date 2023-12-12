import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class YuePaoReportState implements Cloneable<YuePaoReportState> {
  // 类型
  int type = 1;
  // 文本框控制器
  TextEditingController editingController = TextEditingController();
  // 上传的图片地址
  List<String> localPicList = [];
  // 
  String id='';
  @override
  YuePaoReportState clone() {
    return YuePaoReportState()
    ..editingController = editingController
    ..localPicList = localPicList
    ..id = id
    ..type = type;
  }
}

YuePaoReportState initState(Map<String, dynamic> args) {
  return YuePaoReportState()
  ..id = args['id']??'';
}
