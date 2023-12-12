import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class WorksManagerState implements Cloneable<WorksManagerState> {
  TabController tabBarController =
      TabController(length: 3, vsync: ScrollableState());

  bool isEditModel = false;
  int position = 0;
  @override
  WorksManagerState clone() {
    return WorksManagerState()
      ..tabBarController = tabBarController
      ..isEditModel = isEditModel
      ..position = position;
  }
}

WorksManagerState initState(Map<String, dynamic> args) {
  return WorksManagerState()
    ..position = args["position"];
}
