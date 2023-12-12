import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/ads_model.dart';

class FuLiGuangChangState implements Cloneable<FuLiGuangChangState> {

  TabController tabController = TabController(
    length: 2,
    vsync: ScrollableState(),
  );

  @override
  FuLiGuangChangState clone() {
    return FuLiGuangChangState()..tabController = tabController;
  }
}

FuLiGuangChangState initState(Map<String, dynamic> args) {
  return FuLiGuangChangState();
}
