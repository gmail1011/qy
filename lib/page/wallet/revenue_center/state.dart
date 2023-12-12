import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_income_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RevenueCenterState implements Cloneable<RevenueCenterState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();
  VideoIncomeModel model;
  List<VideoIncome> videoIncomeList;

  var pageSize = 10;
  var pageNumber = 1;

  @override
  RevenueCenterState clone() {
    return RevenueCenterState()
      ..refreshController = refreshController
      ..requestController = requestController
      ..pageSize = pageSize
      ..pageNumber = pageNumber
      ..model = model
      ..videoIncomeList = videoIncomeList;
  }
}

RevenueCenterState initState(Map<String, dynamic> args) {
  return RevenueCenterState();
}
