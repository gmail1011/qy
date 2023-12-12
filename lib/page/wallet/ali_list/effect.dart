import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/common/config/config.dart';
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';

Effect<AliListState> buildEffect() {
  return combineEffects(<Object, Effect<AliListState>>{
    AliListAction.onBack: _onBack,
    AliListAction.onAddAliAccount: _addAccount,
    AliListAction.onUseAccount: _onUseAccount,
    Lifecycle.initState: _initState,
    AliListAction.onDeleteAccount: _onDeleteAccount,
  });
}

void _onBack(Action action, Context<AliListState> ctx) async {
  var result = await lightKV.getString(Config.LAST_A_ACCOUNT);
  AccountInfoModel listBean;
  if (result != null && result.isNotEmpty) {
    listBean = AccountInfoModel.fromMap(convert.jsonDecode(result));
  }
  Map<String, dynamic> _map = Map();
  _map['model'] = listBean;
  safePopPage(_map);
}

void _onDeleteAccount(Action action, Context<AliListState> ctx) async {
  var isDelete = await showConfirm(ctx.context,
      content: "是否确认删除账号\n${ctx.state.aliList[action.payload].act}",
      showCancelBtn: true);
  if (isDelete == null || !isDelete) {
    return;
  }
  String result;
  try {
    result = await netManager.client
        .bankCardDelete(ctx.state.aliList[action.payload].id);
  } catch (e) {
    l.e("ali_list", "_onDeleteAccount()...error:$e");
  }
  if (null != result) {
    var result = await lightKV.getString(Config.LAST_A_ACCOUNT);
    if (result != null) {
      AccountInfoModel listBean =
          AccountInfoModel.fromMap(convert.jsonDecode(result));
      if (ctx.state.aliList[action.payload].id == listBean.id) {
        lightKV.setString(Config.LAST_A_ACCOUNT, "");
      }
    }
    showToast(msg: "删除成功", gravity: ToastGravity.CENTER);
    ctx.state.aliList.removeAt(action.payload);
    ctx.dispatch(AliListActionCreator.updateUI());
  }
}

void _addAccount(Action action, Context<AliListState> ctx) async {
  // Map<String, dynamic> map = Map();
  // map['act'] = ctx.state.actController.text;
  // map['actName'] = ctx.state.actNameController.text;
  // BaseResponse res = await getAddAp(map);
  String act = ctx.state.actController.text;
  String actName = ctx.state.actNameController.text;
  try {
    await netManager.client.getAddAp(act, actName);
    showToast(msg: "添加成功");
    ctx.state.actNameController.clear();
    ctx.state.actController.clear();
    //第一次添加成功后返回
    if (ctx.state.aliList.length == 0) {
      Map<String, dynamic> _map = Map();
      AccountInfoModel listBean = AccountInfoModel()
        ..act = act
        ..actName = actName;
      _map['model'] = listBean;
      await lightKV.setString(
          Config.LAST_A_ACCOUNT, convert.jsonEncode(listBean));
      safePopPage(_map);
    } else {
      getAliListData(ctx);
    }
  } catch (e) {
    l.e('getAddAp', e.toString());
    showToast(msg: e.toString());
  }
  // if (res.code == 200) {
  //   showToast(msg: "添加成功");
  //   ctx.state.actNameController.clear();
  //   ctx.state.actController.clear();
  //   //第一次添加成功后返回
  //   if (ctx.state.aliList.length == 0) {
  //     Map<String, dynamic> _map = Map();
  //     AccountInfoModel listBean = AccountInfoModel()
  //       ..act = map['act']
  //       ..actName = map['actName'];
  //     _map['model'] = listBean;
  //     await lightKV.setString(
  //         Config.LAST_A_ACCOUNT, convert.jsonEncode(listBean));
  //     safePopPage(_map);
  //   } else {
  //     getAliListData(ctx);
  //   }
  // } else {
  //   showToast(msg: res.msg);
  // }
}

void _onUseAccount(Action action, Context<AliListState> ctx) async {
  Map<String, dynamic> map = Map();
  AccountInfoModel listBean = ctx.state.aliList[action.payload];
  await lightKV.setString(Config.LAST_A_ACCOUNT, convert.jsonEncode(listBean));
  map['model'] = listBean;
  safePopPage(map);
}

void _initState(Action action, Context<AliListState> ctx) {
  //获取支付宝列表

  Future.delayed(Duration(milliseconds: 200), () async {
    getAliListData(ctx);
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
  
}

void getAliListData(Context<AliListState> ctx) async {
  var result = await lightKV.getString(Config.LAST_A_ACCOUNT);
  if (result != null && result.isNotEmpty) {
    AccountInfoModel listBean =
        AccountInfoModel.fromMap(convert.jsonDecode(result));
    ctx.state.lastAccountName = listBean.act;
  }
  // BaseResponse res = await getAliPayList();
  try {
    ApBankListModel model = await netManager.client.getAliPayList();
    ctx.state.isLoading = false;
    ctx.state.aliList = [];
    ctx.dispatch(AliListActionCreator.onUpdateData(model));
  } catch (e) {
    l.e('getAliPayList', e.toString());
    showToast(msg: e.toString());
  }
  // ctx.state.isLoading = false;
  // if (res.code == Code.SUCCESS) {
  //   ctx.state.aliList = [];
  //   ApBankListModel model = ApBankListModel.fromMap(res.data);
  //   ctx.dispatch(AliListActionCreator.onUpdateData(model));
  // }
}
