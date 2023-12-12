import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class ShouYiDetailState implements Cloneable<ShouYiDetailState> {
  BaseRequestController controller = BaseRequestController();
  BangDanRankType rankTypeData;

  @override
  ShouYiDetailState clone() {
    return ShouYiDetailState()
      ..rankTypeData = rankTypeData
      ..controller = controller;
  }
}

ShouYiDetailState initState(Map<String, dynamic> args) {
  return ShouYiDetailState()..rankTypeData = args["rankType"];
}
