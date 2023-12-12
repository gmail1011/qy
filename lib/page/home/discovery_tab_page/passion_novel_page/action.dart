import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;

//TODO replace with your own action
enum PassionNovelAction { onAssignmentTab }

class PassionNovelActionCreator {
  static Action onAssignmentTab(
      List<String> tabNames, List<Widget> tabViewList) {
    return Action(PassionNovelAction.onAssignmentTab, payload: {
      'tabNames': tabNames,
      'tabViewList': tabViewList,
    });
  }
}
