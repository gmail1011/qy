import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class PromoteHomeState implements Cloneable<PromoteHomeState> {
  TabController tabController;
  @override
  PromoteHomeState clone() {
    return PromoteHomeState()..tabController = tabController;
  }
}

PromoteHomeState initState(Map<String, dynamic> args) {
  return PromoteHomeState()
    ..tabController =
        TabController(initialIndex: 0, length: 2, vsync: ScrollableState());
}
