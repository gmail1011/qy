import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class WithdrawDetailsState with EagleHelper implements Cloneable<WithdrawDetailsState> {
//  final int pageSize = Config.PAGE_SIZE;
  int pageSize = 15;
  int pageNumber = 1;
  WithdrawDetailsModel model;
  EasyRefreshController controller = EasyRefreshController();
  String errorMsg = Lang.NO_DETAILS;
  int type = 0; // 0是收益明细 1，是提现明细

  @override
  WithdrawDetailsState clone() {
    return WithdrawDetailsState()
      ..model = model
      ..pageNumber = pageNumber
      ..controller = controller
      ..errorMsg = errorMsg
      ..type = type;
  }
}

WithdrawDetailsState initState(Map<String, dynamic> args) {
  return WithdrawDetailsState()
    ..type = (null != args ? (args['type'] ?? 0) : 0);
}
