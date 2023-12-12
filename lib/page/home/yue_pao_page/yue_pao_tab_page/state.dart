import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/ads_model.dart';

class YuePaoTabState implements Cloneable<YuePaoTabState> {
  TabController tabController =
      TabController(length: 2, vsync: ScrollableState());
  int pageTitle;

  List<AdsInfoBean> adsList = [];

  String announce;

  @override
  YuePaoTabState clone() {
    return YuePaoTabState()
      ..pageTitle = pageTitle
      ..adsList = adsList
      ..announce = announce
      ..tabController = tabController;
  }
}

YuePaoTabState initState(Map<String, dynamic> args) {
  var map = args ?? {};
  return YuePaoTabState()..pageTitle = map['pageTitle'] ?? 0;
}
