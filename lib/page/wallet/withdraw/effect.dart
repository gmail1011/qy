import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/wallet/alipay_ccdcapi_model.dart';
import 'package:flutter_app/model/wallet/withdraw_config_data.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/utils/loading_async_task.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<WithDrawState> buildEffect() {
  return combineEffects(<Object, Effect<WithDrawState>>{
    Lifecycle.initState: _initData,
    Lifecycle.dispose: _dispose,
    WithDrawAction.submitWithdraw: _submitWithdraw,
  });
}

void _initData(Action action, Context<WithDrawState> ctx) async {
  //获取支付宝或者银行卡的费率
  Future.delayed(Duration(milliseconds: 200), () async {
    var entity = await asyncTask<WalletModelEntity>(
        ctx.context, () => GlobalStore.refreshWallet());
    if (null == entity) {
      showToast(msg: "刷新钱包失败");
    }
    _withdrawConfigReq(ctx);
  });
}

///提现配置请求
void _withdrawConfigReq(Context<WithDrawState> ctx) async {
  try {
    WithdrawConfig configData = await netManager.client.withdrawConfig();
    l.e("configData-->", "$configData");
    if (configData != null) {
      ctx.state.configData = configData;
      if ((configData?.channels?.length ?? 0) > 1) {
        ctx.state.withdrawType = 1;
      } else {
        ctx.state.withdrawType = 0;
      }
    }
    ctx.dispatch(WithDrawActionCreator.refreshUI());
  } catch (e) {
    l.e("configData-e->", "$e");
  }
}

///提交提现
void _submitWithdraw(Action action, Context<WithDrawState> ctx) async {
  try {
    if(!GlobalStore.isRechargeVIP()){
      VipRankAlert.show(ctx.context, type: VipAlertType.vipWithdraw);
      return;
    }
    int withdrawType = ctx.state.withdrawType;
    Channel channel = ctx.state.configData?.channels[withdrawType];
    if ("bankcard" == channel?.payType) {
      //检验银行卡信息
      _bankNumberVerifyReq(ctx);
    } else if ("alipay" == channel?.payType || "usdt" == channel?.payType) {
      _commonWithdrawReq(ctx, false);
    }
  } catch (e) {
    showToast(msg: "提现错误:$e");
  }
}

///公用提现方法
void _commonWithdrawReq(Context<WithDrawState> ctx, bool isbankType,
    {String bank}) async {
  try {
    int withdrawType = ctx.state.withdrawType;
    Channel channel = ctx.state.configData?.channels[withdrawType];
    String money = ctx.state.moneyController?.text?.trim() ?? "";
    String withdrawName = ctx.state.nameController?.text?.trim() ?? "";
    String account = ctx.state.accountController?.text?.trim() ?? "";
    if (money.isEmpty) {
      showToast(msg: "提现金额不能为空");
      return;
    }
    if (withdrawName.isEmpty && ("usdt" != channel?.payType)) {
      showToast(msg: "姓名不能为空");
      return;
    }
    if (account.isEmpty) {
      showToast(msg: "提现账号不能为空");
      return;
    }

    double incomeMoneyYuan = (ctx.state.wallet?.income ?? 0) / 10;
    int withdrawMoneyYuan = int.parse(money);
    if (withdrawMoneyYuan > incomeMoneyYuan) {
      showToast(msg: "提现金额不能大于余额");
      return;
    }

    int minMoneyFen =
        ctx.state.configData?.channels[ctx.state.withdrawType].minMoney ?? 0;
    double minMoneyYuan = minMoneyFen / 100;
    if (withdrawMoneyYuan < minMoneyYuan) {
      showToast(msg: "单笔提现金额不小于$minMoneyYuan元");
      return;
    }
    int maxMoneyFen =
        ctx.state.configData?.channels[ctx.state.withdrawType].maxMoney ?? 0;
    double maxMoneyYuan = maxMoneyFen / 100;
    if (withdrawMoneyYuan > maxMoneyYuan) {
      showToast(msg: "单笔提现金额不大于$maxMoneyYuan元");
      return;
    }

    WBLoadingDialog.show(ctx.context);

    String deviceId = await getDeviceId();
    String payType = channel?.payType;
    //payType 提现方式，alipay，bankcard，usdt
    //money  提现金额
    //name 用户名
    //withdrawType 提现类型，0，代理提现； 1，金币提现
    //actName 交易账户持有人
    //act 交易账户
    //devID 设备id
    //productType 产品类型 0站群 1棋牌
    var result = await netManager.client.withdraw(
      payType,
      account,
      withdrawMoneyYuan * 100,
      GlobalStore.getMe()?.name ?? "",
      withdrawName ?? "",
      deviceId,
      bank ?? "",
      1,
      0,
    );
    WBLoadingDialog.dismiss(ctx.context);

    l.e("withdraw-提现结果：", "$result");
    GlobalStore.refreshWallet(true);
    showToast(msg: "提现提交成功～");

    ctx.dispatch(WithDrawActionCreator.clearInputData());
  } catch (e) {
    l.e("withdraw-e：", "$e");
    WBLoadingDialog.dismiss(ctx.context);
    showToast(msg: "提现失败～");
  }
}

///校验银行卡信息
void _bankNumberVerifyReq(Context<WithDrawState> ctx) async {
  String bankNum = ctx.state.accountController?.text?.trim() ?? "";
  if (bankNum.isEmpty || bankNum.length < 13) {
    showToast(msg: "银行卡号错误");
    return;
  }
  DioCli().getJSON(Address.ALI_CCD_API + bankNum).then((ret) {
    ctx.dispatch(WithDrawActionCreator.refreshUI());
    if (ret.err != null) {
      showToast(msg: "银行卡验证失败.");
      return;
    }
    final res = ret.data;
    if (res.statusCode == Code.SUCCESS) {
      ApcApiModel model = ApcApiModel.fromMap(res.data);
      if (model.validated) {
        // model.bank, model.cardType
        l.e("model.bank-->", "${model.bank}");
        l.e("model.cardType-->", "${model.cardType}");
        _commonWithdrawReq(ctx, true, bank: model?.bank);
      } else {
        showToast(msg: "银行卡验证失败");
      }
    } else {
      showToast(msg: "银行卡验证失败");
    }
  });
}

void _dispose(Action action, Context<WithDrawState> ctx) async {
  WBLoadingDialog.dismiss(ctx.context);
  ctx.state.moneyController?.dispose();
  ctx.state.nameController?.dispose();
  ctx.state.accountController?.dispose();
  ctx.state.focusNode?.dispose();
}
