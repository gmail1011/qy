import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_base/utils/page_intro_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MineState extends GlobalBaseState
    with EagleHelper, PageIntroHelper
    implements Cloneable<MineState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();
  ScrollController scrollController = new ScrollController();

  var picIndex = 0;
  String freeGoldDate;

  @override
  MineState clone() {
    return new MineState()
      ..picIndex = picIndex
      ..freeGoldDate = freeGoldDate
      ..scrollController = scrollController
      ..refreshController = refreshController
      ..requestController = requestController;
  }
}

MineState initState(Map<String, dynamic> args) {
  MineState newState = MineState();
  return newState;
}
