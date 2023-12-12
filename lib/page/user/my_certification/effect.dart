import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';

import 'action.dart';
import 'state.dart';

Effect<MyCertificationState> buildEffect() {
  return combineEffects(<Object, Effect<MyCertificationState>>{
    MyCertificationAction.submit: _submit,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<MyCertificationState> ctx) async {
  try {
    var result = await netManager.client.getOfficialCertStatus();
    l.d("getOfficialCertStatus-result:", "$result");
    if (result != null) {
      ctx.state.userCertification = result;
      ctx.state.userCertification?.productInfo?.rchgType = []; // 置空普通支付模式
      ctx.state.userCertification?.productInfo?.isAmountPay = true; //展示金币购买
      ctx.state.userCertification?.productInfo?.productType =
          16; //设置认证购买类型为16 628b01abd2d46c0dd2fa1352
      ctx.state.userCertification?.productInfo?.productName = "认证";
      ctx.state.requestController?.requestSuccess();
    } else {
      ctx.state.requestController?.requestFail();
    }
    ctx.dispatch(MyCertificationActionCreator.updateUI());
  } catch (e) {
    ctx.state.requestController?.requestFail();
  }
}

///提交我的认证审核
void _submit(Action action, Context<MyCertificationState> ctx) async {
  try {
    var args = PayForArgs();
    args.dcModel = ctx.state.userCertification?.daichong;
    args.vipitem = ctx.state.userCertification?.productInfo;
    args.isDialog = false;
    args.needBackArgs = true;
    var result = await showPayListDialog(ctx.context, args);
    l.d("提交我的认证返回", "$result");
    if ("pay_vip_success" == result) {
      safePopPage();
    }
  } catch (e) {
    l.d("提交认证审核失败", "$e");
    showToast(msg: "提交认证审核失败:$e");
  }
}

void _dispose(Action action, Context<MyCertificationState> ctx) {}
