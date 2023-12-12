import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/recharge_history_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class RechargeHistoryState with EagleHelper implements Cloneable<RechargeHistoryState> {
  final int pageSize = Config.PAGE_SIZE;
  int pageNumber = 1;

  List<RechargeHistoryModel> list;

  String errorMsg = Lang.NO_RECHARGE_HISTORY;
  EasyRefreshController controller = EasyRefreshController();

  @override
  RechargeHistoryState clone() {
    return RechargeHistoryState()
      ..list = list
      ..pageNumber = pageNumber
      ..errorMsg = errorMsg
      ..controller = controller;
  }
}

RechargeHistoryState initState(Map<String, dynamic> args) {
  return RechargeHistoryState();
}
