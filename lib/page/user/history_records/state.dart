import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class HistoryRecordsState implements Cloneable<HistoryRecordsState> {
  TabController tabController =
      new TabController(length: 2, vsync: ScrollableState());

  @override
  HistoryRecordsState clone() {
    return HistoryRecordsState()..tabController = tabController;
  }
}

HistoryRecordsState initState(Map<String, dynamic> args) {
  return HistoryRecordsState();
}
