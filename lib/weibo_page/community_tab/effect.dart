import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/payfor_confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Effect<CommunityTabState> buildEffect() {
  return combineEffects(<Object, Effect<CommunityTabState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<CommunityTabState> ctx) async {
  try {
    if ((ctx.state.community ?? []).length == 1) {
      var model = await netManager.client.getTags(1);
      if ((model?.community ?? []).isNotEmpty) {
        ctx.dispatch(
            CommunityTabActionCreator.updateCommunityList(model?.community));
      }

      await Future.delayed(Duration(milliseconds: 500));
      _initTagController(ctx, ctx.state.community);
    } else {
      _initTagController(ctx, ctx.state.community);
    }
  } catch (e) {
    l.d("initTags", "$e");
  }
}

int darkNetIndex = -1;
bool isShowDialog = false;

///初始化标签TAB
void _initTagController(
    Context<CommunityTabState> ctx, List<TagDetailModel> community) {
  ctx.state.tabController = TabController(
      length: community?.length ?? 0,
      vsync: ScrollableState(),
      initialIndex: 0);
  ctx.dispatch(CommunityTabActionCreator.updateUI());

  for (int i = 0; i < community.length; i++) {
    if (community[i].name.contains("暗网")) {
      darkNetIndex = i;
    }
  }

  ctx.state.tabController.addListener(() {
    if (ctx.state.tabController.index == darkNetIndex) {
      //if (GlobalStore.isVIP()) {
      if (!isShowDialog && GlobalStore.isVIP()) {
          isShowDialog = true;
          showConfirm(ctx.context,
              barrierDismissible: false,
              showCancelBtn: true,
              title: "温馨提示",
              content: "该分类包含大量血腥暴力视频,是否确定进入?")
              .then((value) {
            isShowDialog = false;
            if (!value) {
              ctx.state.tabController.animateTo(darkNetIndex - 1);
            }
          });
        } else {
          if (!isShowDialog){
            isShowDialog = true;
            showVipLevelDialog(ctx.context, "当前分类仅对VIP开放,请前往购买VIP",barrierDismissibleValue: false).then((value) {
              isShowDialog = false;
              if (value == 1) {
                ctx.state.tabController.animateTo(darkNetIndex - 1);
              }
            });
          }
        }
      //}
    }
  });
}

void _dispose(Action action, Context<CommunityTabState> ctx) async {
  ctx.state.tabController?.dispose();
}
