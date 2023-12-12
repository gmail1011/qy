import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WithdrawIncomeState implements Cloneable<WithdrawIncomeState> {
  RefreshController refreshController = RefreshController();
  var pageSize = 10;
  var pageNumber = 1;
  List<ListBean> listData;
  BaseRequestController requestController = BaseRequestController();
  @override
  WithdrawIncomeState clone() {
    return WithdrawIncomeState()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..listData = listData
      ..requestController = requestController
      ..refreshController = refreshController;
  }
}

WithdrawIncomeState initState(Map<String, dynamic> args) {
  return WithdrawIncomeState();
}
