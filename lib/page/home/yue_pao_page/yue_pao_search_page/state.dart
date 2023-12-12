import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class YuePaoSearchState implements Cloneable<YuePaoSearchState> {
  
  TextEditingController textEditingController = TextEditingController();
  // 楼风列表
  List<LouFengItem> louFengList = [];

  int pageNumber = 1;
  int pageSize = 10;
  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();
  @override
  YuePaoSearchState clone() {
    return YuePaoSearchState()
    ..louFengList = louFengList
    ..pageNumber = pageNumber
    ..pageSize = pageSize
    ..baseRequestController = baseRequestController
    ..refreshController = refreshController
    ..textEditingController = textEditingController;
  }
}

YuePaoSearchState initState(Map<String, dynamic> args) {
  return YuePaoSearchState();
}
