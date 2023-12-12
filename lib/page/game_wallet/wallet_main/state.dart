import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class WalletState extends GlobalBaseState
    with EagleHelper
    implements Cloneable<WalletState> {
  /// 金币
  List<RechargeTypeModel> rechargeType = [];
  bool paying = false; //是否处于支付中
  bool isResing = false;
  int selectIndex = 0;
  BaseRequestController baseRequestController = BaseRequestController();
  // 总model
  DCModel dcModel;
  int amount = 0;

  List<AdsInfoBean> resultList = [];

  int selectBannerIndex = 0;

  WalletState() {
    if (VariableConfig.rechargeType != null &&
        VariableConfig.rechargeType.isNotEmpty) {
      rechargeType = VariableConfig.rechargeType;
    }
  }

  @override
  WalletState clone() {
    return WalletState()
      ..baseRequestController = baseRequestController
      ..rechargeType = rechargeType
      ..selectIndex = selectIndex
      ..selectBannerIndex = selectBannerIndex
      ..dcModel = dcModel
      ..amount = amount
      ..resultList = resultList
      ..paying = paying;
  }
}

class PayForCOnnector extends ConnOp<WalletState, PayForState> {
  @override
  PayForState get(WalletState state) {
    if ((state.rechargeType?.length ?? 0) > 1) {
      var args = PayForArgs(
          dcModel: state.dcModel,
          isDialog: false,
          rechargeModel: state.rechargeType[state.selectIndex]);
      return PayForState(args: args)..isPayLoading = state.paying;
    }
    return PayForState();
  }

  @override
  void set(WalletState state, PayForState subState) {
    state.paying = subState.isPayLoading;
  }
}

WalletState initState(Map<String, dynamic> args) {
  return WalletState();
}
