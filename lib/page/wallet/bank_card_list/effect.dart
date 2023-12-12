import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter_app/model/bankcard_info.dart';
import 'package:flutter_app/model/wallet/alipay_ccdcapi_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';
import 'dart:convert' as convert;

Effect<BankCardListState> buildEffect() {
  return combineEffects(<Object, Effect<BankCardListState>>{
    BankCardListAction.action: _onAction,
    BankCardListAction.back: _onBack,
    BankCardListAction.onAddBankCard: _onAddBankCard,
    BankCardListAction.onDeleteBankCard: _onDeleteBankCard,
    Lifecycle.initState: _initState,
    BankCardListAction.onRefreshList: _onRefreshList,
    BankCardListAction.onItemBankClicked: _onItemBankClicked,
    BankCardListAction.validatedBankCard: _validatedBankCard,
  });
}

void _onAction(Action action, Context<BankCardListState> ctx) {}

void _onBack(Action action, Context<BankCardListState> ctx) async {
  var result = await lightKV.getString(Config.LAST_BANK_ACCOUNT);
  AccountInfoModel listBean;
  if (result != null && result.isNotEmpty) {
    listBean = AccountInfoModel.fromMap(convert.jsonDecode(result));
  }
  Map<String, dynamic> _map = Map();
  _map['model'] = listBean;
  safePopPage(_map);
}

void _validatedBankCard(Action action, Context<BankCardListState> ctx) {
  DioCli().getJSON(Address.ALI_CCD_API + _getBankNumber(ctx)).then((ret) {
    if (ret.err != null) {
      return;
    }
    final res = ret.data;
    if (res.statusCode == Code.SUCCESS) {
      ApcApiModel model = ApcApiModel.fromMap(res.data);
      if (model.validated) {
        ctx.state.validatedBankName = BankcardInfo().getBankName(model.bank);
        ctx.dispatch(BankCardListActionCreator.updateUI());
      }
    }
  });
}

void _onDeleteBankCard(Action action, Context<BankCardListState> ctx) async {
  var result =
      await showConfirm(ctx.context, content: "是否确认删除此账号?", showCancelBtn: true);
  if (result) {
    ctx.state.isLoading = true;
    ctx.dispatch(BankCardListActionCreator.updateUI());
    String result;
    try {
      result = await netManager.client
          .bankCardDelete(ctx.state.model.list[action.payload].id);
    } catch (e) {
      l.e('bankCardDelete', e.toString());
    }
    if (null != result) {
      showToast(msg: "删除成功");
      ctx.state.isLoading = false;
      ctx.state.model.list.removeAt(action.payload);
      ctx.dispatch(BankCardListActionCreator.updateUI());
    }
  }
}

void _onItemBankClicked(Action action, Context<BankCardListState> ctx) async {
  int index = action.payload;
  //保存最近使用的银行卡账号
  AccountInfoModel listBean = ctx.state.model.list[index];
  lightKV.setString(Config.LAST_BANK_ACCOUNT, convert.jsonEncode(listBean));
  //跳回
  Map<String, dynamic> map = Map();
  map['model'] = listBean;
  safePopPage(map);
}

String _getBankNumber(Context<BankCardListState> ctx) {
  var bankNumber = ctx.state.actController.text.replaceAll("-", "");
  bankNumber = bankNumber.replaceAll(" ", "");
  return bankNumber;
}

void _onAddBankCard(Action action, Context<BankCardListState> ctx) async {
  ctx.state.isLoading = true;
  ctx.dispatch(BankCardListActionCreator.updateUI());
  DioCli().getJSON(Address.ALI_CCD_API + _getBankNumber(ctx)).then((ret) {
    ctx.state.isLoading = false;
    ctx.dispatch(BankCardListActionCreator.updateUI());
    if (ret.err != null) {
      showToast(msg: "银行卡验证失败.");
      return;
    }
    final res = ret.data;
    if (res.statusCode == Code.SUCCESS) {
      ApcApiModel model = ApcApiModel.fromMap(res.data);
      if (model.validated) {
        _addBankCard(action, ctx, model.bank, model.cardType);
      } else {
        showToast(msg: "银行卡验证失败");
      }
    } else {
      showToast(msg: "银行卡验证失败");
    }
  });
}

void _addBankCard(Action action, Context<BankCardListState> ctx,
    String bankCode, String cardType) async {
  ctx.state.isLoading = true;
  ctx.dispatch(BankCardListActionCreator.updateUI());
  // Map<String, dynamic> map = Map();
  // map['act'] = _getBankNumber(ctx);
  // map['actName'] = ctx.state.actNameController.text;
  // map['bankCode'] = bankCode;
  // map['cardType'] = cardType;
  String act = _getBankNumber(ctx);
  String actName = ctx.state.actNameController.text;
  try {
    await netManager.client.getAddBankCard(act, actName, bankCode, cardType);
    showToast(msg: "银行卡添加成功");
    ctx.state.actController.clear();
    ctx.state.actNameController.clear();
    ctx.state.validatedBankName = null;
    //第一次添加成功后返回
    if (ctx.state.model.list.length == 0) {
      Map<String, dynamic> _map = Map();
      AccountInfoModel listBean = AccountInfoModel()
        ..act = act
        ..actName = actName
        ..bankCode = bankCode
        ..cardType = cardType;
      _map['model'] = listBean;
      //保存最近使用的银行卡账号
      await lightKV.setString(
          Config.LAST_BANK_ACCOUNT, convert.jsonEncode(listBean));
      safePopPage(_map);
    }
    //重新刷新数据
    ctx.dispatch(BankCardListActionCreator.onRefreshList());
  } catch (e) {
    l.e('getAddBankCard', e.toString());
    ctx.state.isLoading = false;
    ctx.dispatch(BankCardListActionCreator.updateUI());
    showToast(msg: e.toString());
  }

  // getAddBankCard(map).then((res) async {
  //   if (res.code == 200) {
  //     showToast(msg: "银行卡添加成功");
  //     ctx.state.actController.clear();
  //     ctx.state.actNameController.clear();
  //     ctx.state.validatedBankName = null;
  //     //第一次添加成功后返回
  //     if (ctx.state.model.list.length == 0) {
  //       Map<String, dynamic> _map = Map();
  //       AccountInfoModel listBean = AccountInfoModel()
  //         ..act = map['act']
  //         ..actName = map['actName']
  //         ..bankCode = map['bankCode']
  //         ..cardType = map['cardType'];
  //       _map['model'] = listBean;
  //       //保存最近使用的银行卡账号
  //       await lightKV.setString(
  //           Config.LAST_BANK_ACCOUNT, convert.jsonEncode(listBean));
  //       safePopPage(_map);
  //     }
  //     //重新刷新数据
  //     ctx.dispatch(BankCardListActionCreator.onRefreshList());
  //   } else {
  //     ctx.state.isLoading = false;
  //     ctx.dispatch(BankCardListActionCreator.updateUI());
  //     showToast(msg: res.msg);
  //   }
  // });
}

void _initState(Action action, Context<BankCardListState> ctx) {
  //获取银行卡列表

  Future.delayed(Duration(milliseconds: 200), () async {
    _getBankListData(ctx);
    //eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

void _onRefreshList(Action action, Context<BankCardListState> ctx) {
  //获取银行卡列表
  _getBankListData(ctx);
}

void _getBankListData(Context<BankCardListState> ctx) async {
  var result = await lightKV.getString(Config.LAST_BANK_ACCOUNT);
  if (result != null && result.isNotEmpty) {
    AccountInfoModel listBean =
        AccountInfoModel.fromMap(convert.jsonDecode(result));
    ctx.state.lastAccountName = listBean.act;
  }
  try {
    ApBankListModel model = await netManager.client.getBankCardList();
    ctx.dispatch(BankCardListActionCreator.onUpdateData(model));
  } catch (e) {
    l.e('getBankCardList', e.toString());
    //失败
    showToast(msg: e.toString());
  } finally {
    ctx.state.isLoading = false;
    ctx.dispatch(BankCardListActionCreator.updateUI());
  }

  // getBankCardList().then((res) async {
  //   ctx.state.isLoading = false;
  //   ctx.dispatch(BankCardListActionCreator.updateUI());
  //   if (res.code == 200) {
  //     ApBankListModel model = ApBankListModel.fromJson(res.data);
  //     ctx.dispatch(BankCardListActionCreator.onUpdateData(model));
  //   } else {
  //     //失败
  //     showToast(msg: res.msg);
  //   }
  // });
}
