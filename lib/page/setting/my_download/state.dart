import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyDownloadState with EagleHelper implements Cloneable<MyDownloadState> {
  List<VideoModel> list;
  BaseRequestController requestController;
  // RefreshController refreshController;
  @override
  MyDownloadState clone() {
    return MyDownloadState()
      ..requestController = requestController
      ..list = list;
  }
}

MyDownloadState initState(Map<String, dynamic> args) {
  return MyDownloadState()
    ..requestController = BaseRequestController()
    ..list = [];
}
