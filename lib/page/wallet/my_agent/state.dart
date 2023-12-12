import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class MyAgentState extends GlobalBaseState
    with EagleHelper
    implements Cloneable<MyAgentState> {
  BaseRequestController requestController = BaseRequestController();
  WalletModelEntity userIncomeModel;

  String marquee;

  @override
  MyAgentState clone() {
    return MyAgentState()
      ..userIncomeModel = userIncomeModel
      ..marquee = marquee
      ..requestController = requestController;
  }
}

MyAgentState initState(Map<String, dynamic> args) {
  return MyAgentState();
}
