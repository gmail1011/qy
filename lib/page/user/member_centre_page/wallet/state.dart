import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class WalletState extends GlobalBaseState implements Cloneable<WalletState> {
  BaseRequestController requestController = BaseRequestController();

  ///钱包
  List<RechargeTypeModel> rechargeType = [];
  int selectIndex = 0;

  ///代充
  DCModel dcModel;

  @override
  WalletState clone() {
    return WalletState()
      ..rechargeType = rechargeType
      ..selectIndex = selectIndex
      ..dcModel = dcModel
      ..requestController = requestController;
  }
}

WalletState initState(Map<String, dynamic> args) {
  return WalletState();
}
