import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoTopicState with EagleHelper implements Cloneable<VideoTopicState> {
  List<ListBeanSp> list = List();
  List<AdsInfoBean> adsList;
  int pageNumber = 1;
  int pageSize = 10;
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();

  @override
  VideoTopicState clone() {
    return VideoTopicState()
      ..adsList = adsList
      ..list = list
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController;
  }
}

VideoTopicState initState(Map<String, dynamic> args) {
  VideoTopicState videoTopicState = VideoTopicState();
  videoTopicState.pageNumber = 1;
  return videoTopicState;
}
