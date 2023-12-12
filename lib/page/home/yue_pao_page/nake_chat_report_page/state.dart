import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class NakeChatReportState implements Cloneable<NakeChatReportState> {
  // 类型
  int type = 1;
  // 文本框控制器
  TextEditingController editingController = TextEditingController();
  // 上传的图片地址
  List<String> localPicList = [];
  // 
  String id='';
  @override
  NakeChatReportState clone() {
    return NakeChatReportState()
    ..editingController = editingController
    ..localPicList = localPicList
    ..id = id
    ..type = type;
  }
}

NakeChatReportState initState(Map<String, dynamic> args) {
  return NakeChatReportState()
  ..id = args['id']??'';
}
