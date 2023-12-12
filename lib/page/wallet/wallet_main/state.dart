import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/page/wallet/pay_for_nake_chat/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class WalletState extends GlobalBaseState with EagleHelper implements Cloneable<WalletState> {
  /// 金币
  List<RechargeTypeModel> rechargeType = [];
  /// 果币
  List<RechargeTypeModel> nakeChatRechargeType = [];
  bool paying = false; //是否处于支付中
  bool isResing = false;
  int selectIndex = 0;
  int selectNakeChatIndex = 0;
  BaseRequestController baseRequestController = BaseRequestController();
  // 总model
  DCModel dcModel;

  DCModel nakeChatDcModel;

  TabController tabBarController = new TabController(initialIndex: Config.isNakeChatCoin ? 1 : 0,length: 2,vsync: ScrollableState());

  WalletState() {
    if (VariableConfig.rechargeType != null &&
        VariableConfig.rechargeType.isNotEmpty) {
      rechargeType = VariableConfig.rechargeType;
    }


    if (VariableConfig.rechargeNakeChatType != null &&
        VariableConfig.rechargeNakeChatType.isNotEmpty) {
      nakeChatRechargeType = VariableConfig.rechargeNakeChatType;
    }
  }

  @override
  WalletState clone() {
    return WalletState()
      ..baseRequestController = baseRequestController
      ..rechargeType = rechargeType
      ..tabBarController = tabBarController
      ..nakeChatRechargeType = nakeChatRechargeType
      ..selectIndex = selectIndex
      ..selectNakeChatIndex = selectNakeChatIndex
      ..dcModel = dcModel
      ..nakeChatDcModel = nakeChatDcModel
      ..paying = paying;
  }
}

class PayForCOnnector extends ConnOp<WalletState, PayForState> {
  @override
  PayForState get(WalletState state) {
    if ((state.rechargeType?.length ?? 0) >= 1) {
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


class PayForNakeChatCOnnector extends ConnOp<WalletState, PayForNakeChatState> {
  @override
  PayForNakeChatState get(WalletState state) {
    if ((state.nakeChatRechargeType?.length ?? 0) >= 1) {
      var args = PayForNakeArgs(
          dcModel: state.nakeChatDcModel,
          isDialog: false,
          rechargeModel: state.nakeChatRechargeType[state.selectNakeChatIndex]);
      return PayForNakeChatState(args: args)..isPayLoading = state.paying;
    }
    return PayForNakeChatState();
  }

  @override
  void set(WalletState state, PayForNakeChatState subState) {
    state.paying = subState.isPayLoading;
  }
}

WalletState initState(Map<String, dynamic> args) {
  return WalletState();
}
