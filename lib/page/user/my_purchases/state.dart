import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class MyPurchasesState implements Cloneable<MyPurchasesState> {
  TabController tabController =
      new TabController(length: 3, vsync: ScrollableState());

  @override
  MyPurchasesState clone() {
    return MyPurchasesState()..tabController = tabController;
  }
}

MyPurchasesState initState(Map<String, dynamic> args) {
  return MyPurchasesState();
}
