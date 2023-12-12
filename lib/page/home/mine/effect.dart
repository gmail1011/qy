import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/dialog/bottom_list_dialog.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

// import 'package:image_pickers/Media.dart';
// import 'package:image_pickers/UIConfig.dart';
// import 'package:image_pickers/image_pickers.dart';

import 'action.dart';
import 'mine_work/action.dart';
import 'state.dart';

Effect<MineState> buildEffect() {
  return combineEffects(<Object, Effect<MineState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    MineAction.onUpdateUserInfo: _onUpdateUserInfo,
    MineAction.onUpdateWalletInfo: _onUpdateWalletInfo,
    MineAction.onHandleBg: _onHandleBg,
    MineAction.refresh: _initData,
  });
}

void _initState(Action action, Context<MineState> ctx) async {
  _initData(action, ctx);
}

void _initData(Action action, Context<MineState> ctx) async {
  await GlobalStore.updateUserInfo(null);
  await GlobalStore.refreshWallet();
  ctx.broadcast(MineWorkActionCreator.onGetWorkData());

  await Future.delayed(Duration(milliseconds: 500));
  //刷新成功
  ctx.state.refreshController?.refreshCompleted();
  ctx.state.requestController?.requestSuccess();
  var hasSaveQR = (await lightKV.getBool(Config.HAVE_SAVE_QR_CODE)) ?? false;
  if (!hasSaveQR) {
    _showSaveQrDialog(ctx.context);
  } else {
    if (!await ctx.state.hasEntered()) {
      ctx.state.setEntered(true);
    }
  }
}

/// 首次进入二维码页面提示保存二维码
Future _showSaveQrDialog(BuildContext ctx) async {
  var ret = await showConfirm(ctx,
      title: Lang.AVOID_ACCOUNT_LOSS,
      content: Lang.AVOID_ACCOUNT_LOSS_TIP,
      showCancelBtn: true,
      sureText: Lang.I_WANT_TO_SAVE,
      cancelText: Lang.I_ALREADY_SAVE);
  if (null != ret && ret) {
    await JRouter().go(PAGE_ACCOUNT_QR_CODE);
  } else if (null != ret && !ret) {
    lightKV.setBool(Config.HAVE_SAVE_QR_CODE, true);
  }
}

void _onUpdateUserInfo(Action action, Context<MineState> ctx) async {
  GlobalStore.updateUserInfo(null);
}

void _onUpdateWalletInfo(Action action, Context<MineState> ctx) async {
  GlobalStore.refreshWallet();
}

///添加背景
void _onAddBg(Action action, Context<MineState> ctx) async {
  int count = 9 - (ctx.state.meInfo?.background?.length ?? 0);
  if (count < 0) {
    showToast(msg: Lang.PHOTO_CHANGE);
    return;
  }
}

void _onHandleBg(Action action, Context<MineState> ctx) async {
  if (!GlobalStore.isRechargeVIP()) {
    showVipLevelDialog(
      ctx.context,
      Lang.VIP_LEVEL_DIALOG_MSG,
    );
    return;
  }

  var data = <ItemData>[
    ItemData(Lang.CHANGE_PHOTO_COVER),
    ItemData(Lang.ADD_PHOTO),
  ];
  var pos = await showListDialog(ctx.context, data);
  if (pos == null || pos == -1) {
    return;
  }
  if (pos == 0) {
    ///更换
    _onChangeBg(action, ctx);
  } else if (pos == 1) {
    ///新增
    _onAddBg(action, ctx);
  }
}

///更换背景
///目前是一对一的更换
void _onChangeBg(Action action, Context<MineState> ctx) async {}

void _dispose(Action action, Context<MineState> ctx) async {
  ctx.state.refreshController?.dispose();
  ctx.state.scrollController?.dispose();
}
