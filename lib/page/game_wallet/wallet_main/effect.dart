import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/wallet/recharge_list_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/array_util.dart';
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
    Lifecycle.dispose: _onDispose,
  });
}

void _onWithdraw(Action action, Context<WalletState> ctx) {
  Map<String, dynamic> map = Map();
  map['income'] = Config.gameBalanceEntity?.wlTransferable?.toString() ?? '0';
  map['from'] = 1;
  JRouter().go(PAGE_WITHDRAW_GAME, arguments: map).then((value) async{
    await netManager.client.getBalance().then((value) => (){

    });

    ctx.dispatch(WalletActionCreator.refreshAmount(Config.gameBalanceEntity.wlTransferable));
  });
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
  Config.isGameWallet = true;
  await getAds(ctx);
  Future.delayed(Duration(milliseconds: 200), () {
    _afterInitState(action, ctx);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });


  await netManager.client.getBalance();
  await netManager.client.transferTax();


  ctx.dispatch(WalletActionCreator.refreshAmount(Config.gameBalanceEntity.wlTransferable));


}


getAds(Context<WalletState> ctx) async{
  //var list = await getAdsByType(AdsType.dayMark);

  //ctx.dispatch(WalletActionCreator.getAds(list));
}

///获取某一个广告数据
Future<List<AdsInfoBean>> getAdsByType(AdsType adsType) async {
  if (null == adsType) return null;
  List<AdsInfoBean> resultList = await LocalAdsStore().getAllAds();
  if (ArrayUtil.isEmpty(resultList)) return <AdsInfoBean>[];

  //List<AdsInfoBean> adsList = resultList?.where((it) => it.position == adsType.index)?.toList();
  List<AdsInfoBean> adsList = resultList?.where((it) => it.position == 11)?.toList();

  return adsList;
}

void _afterInitState(Action action, Context<WalletState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    await GlobalStore.refreshWallet();
    _getRecharges(ctx);
  });
}

/// 获取充值金币列表
void _getRecharges(Context<WalletState> ctx) async {
  ctx.state.isResing = true;
  RechargeListModel model;
  try {

    /// 获取游戏充值金额列表
    model = await netManager.client.getNakeChatRechargeTypeList(2);
    l.e("error", "_getRecharges()...error:");

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
  ctx.state.isResing = true;
}

void _onDispose(Action action, Context<WalletState> ctx) {
  Config.isGameWallet = false;
}
