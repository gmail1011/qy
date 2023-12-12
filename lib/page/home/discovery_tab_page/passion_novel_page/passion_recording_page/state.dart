import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class PassionRecordingState implements Cloneable<PassionRecordingState> {
  TabController tabController = TabController(length: 2, vsync: ScrollableState());
  @override
  PassionRecordingState clone() {
    return PassionRecordingState()
    ..tabController = tabController;
  }
}

PassionRecordingState initState(Map<String, dynamic> args) {
  return PassionRecordingState();
}
