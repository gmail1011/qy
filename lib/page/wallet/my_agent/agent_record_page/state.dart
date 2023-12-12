import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AgentRecordState implements Cloneable<AgentRecordState> {
  TabController tabController;
  @override
  AgentRecordState clone() {
    return AgentRecordState()..tabController = tabController;
  }
}

AgentRecordState initState(Map<String, dynamic> args) {
  return AgentRecordState()
    ..tabController =
        TabController(initialIndex: 0, length: 3, vsync: ScrollableState());
}
