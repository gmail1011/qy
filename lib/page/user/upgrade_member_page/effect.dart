import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/upgrade_vip_info.dart';
import 'package:flutter_app/widget/goldcoin_recharge_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';
import 'package:dio/dio.dart';

Effect<UpgradeMemberState> buildEffect() {
  return combineEffects(<Object, Effect<UpgradeMemberState>>{
    // UpgradeMemberAction.getInfo: _getInfo,
    Lifecycle.initState: _getInfo,
    UpgradeMemberAction.upgrade: _upgradeVip,
  });
}

void _getInfo(Action action, Context<UpgradeMemberState> ctx) async {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (!GlobalStore.isRechargeVIP()) {
    } else {
      UpGradeVipInfo upgradeInfo;
      try {
        upgradeInfo = await netManager.client.getUpVipInfo();
      } catch (e) {
        l.e("upgrade_vip", "getUpVipInfo()...error:$e");
      }
      if (null != upgradeInfo) {
        ctx.dispatch(UpgradeMemberActionCreator.getInfoOkay(upgradeInfo));
      }
    }
  });
}

void _upgradeVip(Action action, Context<UpgradeMemberState> ctx) async {
  try {
    await netManager.client.upgradVip();
    showToast(msg: "恭喜您升级为永久会员");
    await GlobalStore.updateUserInfo(null);
    GlobalStore.refreshWallet();
    safePopPage(true);
  } catch (e) {
    l.e("upgrade_vip", "getUpVipInfo()...error:$e");
    if (e is DioError && e.error is ApiException) {
      var t = e.error as ApiException;
      if (t.code == 8000) {
        // JRouter().go(PAGE_WALLET);
        await showGoldCoinRechargeDialog(ctx.context);
      }
    }
  }
}
