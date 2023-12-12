import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_income_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoIncomeState implements Cloneable<VideoIncomeState> {
  RefreshController refreshController = RefreshController();
  var pageSize = 10;
  var pageNumber = 1;
  VideoIncomeModel model;
  List<VideoIncome> videoIncomeList;
  BaseRequestController requestController = BaseRequestController();

  @override
  VideoIncomeState clone() {
    return VideoIncomeState()
      ..refreshController = refreshController
      ..requestController = requestController
      ..pageSize = pageSize
      ..pageNumber = pageNumber
      ..model = model
      ..videoIncomeList = videoIncomeList;
  }
}

VideoIncomeState initState(Map<String, dynamic> args) {
  return VideoIncomeState();
}
