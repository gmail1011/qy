import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/invite_model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PromoteIncomeState implements Cloneable<PromoteIncomeState> {
  RefreshController refreshController = RefreshController();
  var pageNumber = 1;
  var pageSize = 10;
  InviteIncomeModel model;
  List<InviteItem> inviteIncomeList;
  BaseRequestController requestController = BaseRequestController();

  @override
  PromoteIncomeState clone() {
    return PromoteIncomeState()
      ..refreshController = refreshController
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..model = model
      ..inviteIncomeList = inviteIncomeList
      ..requestController = requestController;
  }
}

PromoteIncomeState initState(Map<String, dynamic> args) {
  return PromoteIncomeState();
}
