import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MineFollowState with EagleHelper implements Cloneable<MineFollowState> {
  List<WatchModel> list;
  RefreshController refreshController;
  BaseRequestController baseRequestController;
  int pageIndex = 1;
  @override
  MineFollowState clone() {
    return MineFollowState()
      ..list = list
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController
      ..pageIndex = pageIndex;
  }
}

MineFollowState initState(Map<String, dynamic> args) {
  return MineFollowState()
    ..baseRequestController = BaseRequestController()
    ..refreshController = RefreshController();
}
