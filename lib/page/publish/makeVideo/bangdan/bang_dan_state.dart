import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';

class BangDanState implements Cloneable<BangDanState> {
  int index = 0;
  List<BangDanRankType> rankTypeList = [];
  TabController tabController;

  @override
  BangDanState clone() {
    return BangDanState()
      ..index = index
      ..rankTypeList = rankTypeList
      ..tabController = tabController;
  }
}

BangDanState initState(Map<String, dynamic> args) {
  BangDanState bangDanState = BangDanState();
  bangDanState.index = args["index"];
  bangDanState.rankTypeList = args["rankTypeList"];
  bangDanState.tabController = TabController(
      length: bangDanState.rankTypeList?.length ?? 0, vsync: ScrollableState());
  bangDanState.tabController.animateTo(args["index"]);
  return bangDanState;
}
