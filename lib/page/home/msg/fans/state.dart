import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/message/fans_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FansState with EagleHelper implements Cloneable<FansState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  final int pageSize = Config.PAGE_SIZE;
  int pageNumber = 1;

  List<FansModel> fansList = [];

  bool isViewAll = false;

  bool hasNext = false;

  @override
  FansState clone() {
    return FansState()
      ..refreshController = refreshController
      ..requestController = requestController
      ..pageNumber = pageNumber
      ..fansList = fansList
      ..hasNext = hasNext
      ..isViewAll = isViewAll;
  }
}

FansState initState(Map<String, dynamic> args) {
  return FansState();
}
