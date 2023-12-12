import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/model/nove_details_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class NovelPlayerState implements Cloneable<NovelPlayerState> {
  bool isShowAppBar = false;
  List<String> currentTextList = [];

  bool tipArrowShow;
  var colorModel = ColorsModel(
      bgColor: Color(0xFF191C1B), textColor: Colors.white.withOpacity(0.6));
  String id;
  var bgColors = [
    ColorsModel(
        bgColor: Color(0xFFD1D1D1), textColor: Colors.black.withOpacity(0.6)),
    ColorsModel(
        bgColor: Color(0xFFBBC9D2), textColor: Colors.black.withOpacity(0.6)),
    ColorsModel(
        bgColor: Color(0xFFE0D1CA), textColor: Colors.black.withOpacity(0.6)),
    ColorsModel(
        bgColor: Color(0xFFD0CDBA), textColor: Colors.black.withOpacity(0.6)),
    ColorsModel(
        bgColor: Color(0xFF303030), textColor: Colors.white.withOpacity(0.6)),
    ColorsModel(
        bgColor: Color(0xFF191C1B), textColor: Colors.white.withOpacity(0.6)),
  ];
  NoveDetails novelData;

  ScrollController controller = ScrollController();
  BaseRequestController pullController = BaseRequestController();

  @override
  NovelPlayerState clone() {
    return NovelPlayerState()
      ..isShowAppBar = isShowAppBar
      ..pullController = pullController
      ..tipArrowShow = tipArrowShow
      ..novelData = novelData
      ..id = id
      ..colorModel = colorModel
      ..controller = controller
      ..currentTextList = currentTextList;
  }
}

NovelPlayerState initState(Map<String, dynamic> args) {
  return NovelPlayerState()
    ..tipArrowShow = false
    ..id = args['id'];
}

class ColorsModel {
  Color bgColor;
  Color textColor;
  ColorsModel({
    this.bgColor,
    this.textColor,
  });
}
