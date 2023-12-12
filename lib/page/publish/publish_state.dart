import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class PublishState implements Cloneable<PublishState> {

  TabController tabController = new TabController(length: 1, vsync: ScrollableState());

  @override
  PublishState clone() {
    return PublishState()..tabController = tabController;
  }
}

PublishState initState(Map<String, dynamic> args) {
  return PublishState();
}
