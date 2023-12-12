import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SpecialTopicState with EagleHelper implements Cloneable<SpecialTopicState> {
  List<ListBeanSp> list = List();
  List<AdsInfoBean> adsList;
  int pageNumber = 1;
  int pageSize = 10;
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();

  @override
  SpecialTopicState clone() {
    return SpecialTopicState()
      ..adsList = adsList
      ..list = list
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController;
  }
}

SpecialTopicState initState(Map<String, dynamic> args) {
  SpecialTopicState specialTopicState = SpecialTopicState();
  specialTopicState.pageNumber = 1;
  return specialTopicState;
}
