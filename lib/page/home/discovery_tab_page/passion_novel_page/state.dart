import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class PassionNovelState implements Cloneable<PassionNovelState> {
  TabController tabController;
  // tab名
  List<String> tabNames = [];
  // tabView列表
  List<Widget> tabViewList = [];
  bool showTitle = false;

  @override
  PassionNovelState clone() {
    return PassionNovelState()
      ..tabNames = tabNames
      ..tabViewList = tabViewList
      ..showTitle = showTitle
      ..tabController = tabController;
  }
}

PassionNovelState initState(Map<String, dynamic> args) {
  bool sT =
      (args != null && args['showTitle'] != null) ? args["showTitle"] : false;
  return PassionNovelState()..showTitle = sT;
}
