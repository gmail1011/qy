import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WorksListState implements Cloneable<WorksListState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();
  int worksType = 0;
  int pageNum = 1;
  int pageSize = 10;
  bool hasNext = true;

  List<VideoModel> videoList = [];

  bool delModel = false;

  @override
  WorksListState clone() {
    return WorksListState()
      ..refreshController = refreshController
      ..requestController = requestController
      ..pageNum = pageNum
      ..pageSize = pageSize
      ..hasNext = hasNext
      ..videoList = videoList
      ..worksType = worksType
      ..delModel = delModel;
  }
}

WorksListState initState(Map<String, dynamic> args) {
  return WorksListState()..worksType = args["worksType"] ?? 0;
}
