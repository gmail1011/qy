import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OfflineCacheState implements Cloneable<OfflineCacheState> {
  TabController tabController =
      new TabController(length: 2, vsync: ScrollableState());

  @override
  OfflineCacheState clone() {
    return OfflineCacheState()..tabController = tabController;
  }
}

OfflineCacheState initState(Map<String, dynamic> args) {
  return OfflineCacheState();
}
