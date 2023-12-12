import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/nove_details_model.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';
import 'txt_manage/txt_helper.dart';

bool _collectClick = false;
Effect<NovelPlayerState> buildEffect() {
  return combineEffects(<Object, Effect<NovelPlayerState>>{
    Lifecycle.initState: _init,
    NovelPlayerAction.onCollect: _onCollect,
    NovelPlayerAction.onLoadData: _onLoadData,
  });
}

void _onLoadData(Action action, Context<NovelPlayerState> ctx) async {
  _getData(ctx);
}

void _init(Action action, Context<NovelPlayerState> ctx) async {
  var arrowTipSaved = await lightKV.getString('TOPIC_TIP_SHOWa');
  var color = await lightKV.getInt('novelBgColor');
  var textColor = await lightKV.getInt('novelTextColor');
  if (color > 0 && textColor > 0) {
    var colorModel =
        ColorsModel(bgColor: Color(color), textColor: Color(textColor));
    ctx.dispatch(NovelPlayerActionCreator.changeColor(colorModel));
  }

  if (TextUtil.isEmpty(arrowTipSaved)) {
    ctx.dispatch(NovelPlayerActionCreator.changeTipArrow(true));
  }

  _collectClick = false;
  var controller = ctx.state.controller;
  controller.addListener(() {
    if (ctx.state.isShowAppBar) {
      ctx.dispatch(NovelPlayerActionCreator.showAppBar(false));
    }
  });
  Future.delayed(Duration(milliseconds: 300), () {
    _getData(ctx);
    _setBrowse(ctx.state.id);
  });
}

/// 收藏
void _onCollect(Action action, Context<NovelPlayerState> ctx) async {
  var noveDetails = ctx.state.novelData;
  if (noveDetails == null) {
    showToast(msg: '还没加载好，请稍等！');
    return;
  }
  if (_collectClick) {
    return;
  }
  _collectClick = true;
  try {
    bool isCollect = !noveDetails.isCollect;
    await netManager.client.postCollect(ctx.state.id, 'fiction', isCollect);
    noveDetails.isCollect = isCollect;
    int countCollect = noveDetails.countCollect;
    noveDetails.countCollect = isCollect ? countCollect + 1 : countCollect - 1;
    ctx.dispatch(NovelPlayerActionCreator.saveData(noveDetails));
    String msg = isCollect ? Lang.COLLECTION_SUCCESS : Lang.CANCEL_COLLECTION;
    showToast(msg: msg);
  } catch (e) {
    l.e('postCollect', e.toString());
  }
  _collectClick = false;
}

/// 增加浏览次数
void _setBrowse(String id) async {
  try {
    await netManager.client.fictionBrowse(id);
  } catch (e) {
    l.e('fictionBrowse', e.toString());
  }
}

/// 获取数据
void _getData(Context<NovelPlayerState> ctx) async {
  if (!GlobalStore.isVIP()) {
    showVipLevelDialog(
      ctx.context,
      Lang.VIP_LEVEL_DIALOG_MSG2,
    );
    ctx.state.pullController.requestFail();
    return;
  }
  try {
    NoveDetailsModel noveDetailsModel =
        await netManager.client.fictionGet(ctx.state.id);
    NoveDetails noveDetails = noveDetailsModel.fiction;
    ctx.dispatch(NovelPlayerActionCreator.saveData(noveDetails));

    if (!TextUtil.isEmpty(noveDetails.contentUrl)) {
      String path = _dealWithPath(noveDetails.contentUrl);
      List<String> _txtList = await TxtHelper().getSplitTxtList(path);
      if ((_txtList.length ?? 0) == 0) {
        showToast(msg: '资源下载失败');
        ctx.state.pullController.requestFail();
        return;
      } else {
        ctx.dispatch(NovelPlayerActionCreator.saveCurrentText(_txtList));
      }
    } else {
      showToast(msg: '资源不存在！');
    }
    Future.delayed(Duration(seconds: 1), () {
      ctx.state.pullController.requestSuccess();
    });
  } catch (e) {
    l.e('fictionGet', e.toString());
    ctx.state.pullController.requestFail();
  }
}

/// 获取地址
String _dealWithPath(String path) {
  String newPath = path.startsWith('/') ? path : '/$path';
  return newPath;
}
