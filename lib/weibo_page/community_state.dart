import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';

class CommunityState implements Cloneable<CommunityState> {
  TabController tabController =
      new TabController(length: 2, vsync: ScrollableState(), initialIndex: 1);

  /// 是否处理过系统弹窗
  bool isOnceSystemDialog = false;
  List<TagDetailModel> community = [];
  bool showCutDownTimeButton = false;

  @override
  CommunityState clone() {
    return CommunityState()
      ..community = community
      ..tabController = tabController
      ..isOnceSystemDialog = isOnceSystemDialog
      ..showCutDownTimeButton = showCutDownTimeButton;
  }
}

CommunityState initState(Map<String, dynamic> args) {
  return CommunityState()..community = (args == null ? [] : args["initList"]);
}
