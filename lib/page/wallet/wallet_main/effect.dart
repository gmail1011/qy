import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/wallet/recharge_list_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'action.dart';
import 'state.dart';

/// 接收者
Effect<WalletState> buildEffect() {
  return combineEffects(<Object, Effect<WalletState>>{
    WalletAction.withdraw: _onWithdraw,
    WalletAction.openMyIncomeAction: _openMyIncomeAction,
    WalletAction.backAction: _backAction,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _onWithdraw(Action action, Context<WalletState> ctx) {
  Map<String, dynamic> map = Map();
  map['income'] = ctx.state.wallet?.income?.toString() ?? '';
  map['from'] = 1;
  JRouter().go(PAGE_WITHDRAW, arguments: map);
}

void _openMyIncomeAction(Action action, Context<WalletState> ctx) {
  if (ctx.state.wallet == null) return;
  Map<String, dynamic> map = Map();
  map['income'] = ctx.state.wallet?.income?.toString() ?? "";
  map['from'] = 1;
  JRouter().go(PAGE_MY_INCOME, arguments: map);
}

void _backAction(Action action, Context<WalletState> ctx) {
  safePopPage();
}

void _initState(Action action, Context<WalletState> ctx) async {
  Config.isGameWallet = false;
  Future.delayed(Duration(milliseconds: 200), () {
    _afterInitState(action, ctx);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });

  bus.on(EventBusUtils.jumpWalletFromNakeChat, (arg) {
     ctx.state.tabBarController.animateTo(1);
  });
}

void _dispose(Action action, Context<WalletState> ctx) async {
  Config.isNakeChatCoin = false;
}

void _afterInitState(Action action, Context<WalletState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    await GlobalStore.refreshWallet();
    _getRecharges(ctx);
    _getNakeChatRecharges(ctx);
  });
}

/// 获取充值金币列表
void _getRecharges(Context<WalletState> ctx) async {
  ctx.state.isResing = true;
  RechargeListModel model;
  try {
    model = await netManager.client.getNakeChatRechargeTypeList(1);
    //model = await netManager.client.getRechargeTypeList();
    ctx.state.baseRequestController.requestSuccess();
  } catch (e) {
    ctx.state.baseRequestController.requestFail();
    l.e("error", "_getRecharges()...error:$e");
  }
  if (null != model) {
    VariableConfig.rechargeType = model.list;
    Map<String, dynamic> param = {
      "rechargeList": model.list,
      "dcModel": model.daichong,
    };
    ctx.dispatch(WalletActionCreator.setRechargeLists(param));
  }
  ctx.state.isResing = false;
}


/// 获取果币列表
void _getNakeChatRecharges(Context<WalletState> ctx) async {
  ctx.state.isResing = true;
  RechargeListModel model;
  try {
    model = await netManager.client.getNakeChatRechargeTypeList(3);
    //ctx.state.baseRequestController.requestSuccess();
  } catch (e) {
    //ctx.state.baseRequestController.requestFail();
    l.e("error", "_getRecharges()...error:$e");
  }
  if (null != model) {
    VariableConfig.rechargeNakeChatType = model.list;
    Map<String, dynamic> param = {
      "rechargeList": model.list,
      "dcModel": model.daichong,
    };
    ctx.dispatch(WalletActionCreator.setNakeChatRechargeLists(param));
  }
  ctx.state.isResing = false;
}