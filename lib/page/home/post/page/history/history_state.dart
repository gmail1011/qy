import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/liao_ba_history_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryState implements Cloneable<HistoryState> {
  int pageNumber = 1;
  int pageSize = 20;

  LiaoBaHistoryData liaoBaHistoryData;

  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();

  @override
  HistoryState clone() {
    return HistoryState()..
    pageNumber = pageNumber..
    pageSize = pageSize..
    refreshController = refreshController..
    baseRequestController = baseRequestController..
    liaoBaHistoryData = liaoBaHistoryData
    ;
  }
}

HistoryState initState(Map<String, dynamic> args) {
  return HistoryState();
}
