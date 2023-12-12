import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/vip_buy_history.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PurchaseDetailState
    with EagleHelper
    implements Cloneable<PurchaseDetailState> {
  int pageNumber = 1;
  int pageSize = 10;
  List<ListBean> list;
  BaseRequestController baseRequestController = BaseRequestController();

  RefreshController refreshController = RefreshController();
  @override
  PurchaseDetailState clone() {
    return PurchaseDetailState()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..list = list
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController;
  }
}

PurchaseDetailState initState(Map<String, dynamic> args) {
  return PurchaseDetailState();
}
