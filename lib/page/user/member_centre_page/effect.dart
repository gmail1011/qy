import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/confirm_tips_dialog.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<MemberCentreState> buildEffect() {
  return combineEffects(<Object, Effect<MemberCentreState>>{
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
    MemberCentreAction.submitRedemptionCode: _submitRedemptionCode,
  });
}

void _init(Action action, Context<MemberCentreState> ctx) async {
  Config.isGameWallet = false;
  await Future.delayed(Duration(milliseconds: 400));

  GlobalStore.refreshWallet();
  _showTipsDialog(ctx);

  ///兑换会员UI展示
  if(ctx.state.startRedemptionMember ?? false) {
    String code = await showRedemptionCodeDialog(
        ctx.context);
    l.d("showRedemptionCodeDialog-result", "$code");
    if ((code ?? "").isNotEmpty) {
      _submitVipRedemptionCode(code);
    }
  }
}

///提交兑换码
void _submitRedemptionCode(
    Action action, Context<MemberCentreState> ctx) async {
  try {
    String code = action.payload ?? "";
    _submitVipRedemptionCode(code);
  } catch (e) {
    l.d('postExChangeCode', e.toString());
  }
}
///提交兑换码
void _submitVipRedemptionCode(String code) async {
  try {
    if (code.isEmpty) {
      return;
    }
    await netManager.client.postExChangeCode(code);
    showToast(msg: Lang.REDEMPTION_SUCCESS);
    GlobalStore.updateUserInfo(null);
  } catch (e) {
    l.d('postExChangeCode', e.toString());
  }
}
///提示风险弹出框
_showTipsDialog(Context<MemberCentreState> ctx) async {
  if (!await ctx.state.hasEntered()) {
    showTipsConfirm(ctx.context,
        child: Container(
          padding: EdgeInsets.only(top: 110, left: 16, right: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AssetsImages.BG_NOTIFY_TIPS,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(children: [
            Text(
              "温馨提示！",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 8),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "91猎奇收入来源于广告及赞助商产品安全无毒，可放心使用！\n\n",
                  style: TextStyle(
                      fontSize: Dimens.pt12, color: Color(0xffff9f19))),
              TextSpan(
                  text: "由于APP包含成人敏感内容，会被判断为恶意软件，如在支付过程中遇到恶意软件提醒请点击",
                  style: TextStyle(fontSize: Dimens.pt12, color: Colors.black)),
              TextSpan(
                  text: "忽略",
                  style: TextStyle(
                      fontSize: Dimens.pt14, color: Color(0xffff9f19))),
              TextSpan(
                  text: "即可。",
                  style: TextStyle(fontSize: Dimens.pt12, color: Colors.black)),
            ])),
            SizedBox(height: Dimens.pt10),
            const Image(image: AssetImage(AssetsImages.BG_NOTICE_PAY)),
          ]),
        ),
        sureText: Lang.I_KNOW);
    ctx.state.setEntered(true);
  }
}

void _dispose(Action action, Context<MemberCentreState> ctx) {
  ctx.state.tabBarController?.dispose();
}
