import 'dart:async';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/cached_history_video_store.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/page/video/player_manager.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_word_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/task_manager/dialog_manager.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Effect<HomeState> buildEffect() {
  return combineEffects(<Object, Effect<HomeState>>{
    HomeAction.changeTab: _changeTab,
    Lifecycle.dispose: _dispose,
    Lifecycle.initState: _initState,
  });
}

void _dispose(Action action, Context<HomeState> ctx) {
  bus.emit(EventBusUtils.closeActivityFloating);
  ctx.state.pageController.dispose();
  ImageCacheManager()?.store?.emptyMemoryCache();
  ImageCache()?.clearLiveImages();
}

void _initState(Action action, Context<HomeState> ctx) {
  //_cacheVipBg();

  bus.on(EventBusUtils.avCommentary, (arg) {
    ctx.state.pageController.jumpToPage(2);
    ctx.dispatch(HomeActionCreator.changeTab(2));
  });

  bus.on(EventBusUtils.gamePage, (arg) {
    ctx.state.pageController.jumpToPage(3);
    ctx.dispatch(HomeActionCreator.changeTab(3));
  });

  bus.on(EventBusUtils.louFengPage, (arg) {
    ctx.state.pageController.jumpToPage(4);
    ctx.dispatch(HomeActionCreator.changeTab(4));
  });


  bus.on(EventBusUtils.memberlongvideo, (arg) {
    ctx.state.pageController.jumpToPage(3);
    ctx.dispatch(HomeActionCreator.changeTab(3));
  });

  ///获取钱包信息和用户信息
  GlobalStore.refreshWallet();
  GlobalStore.updateUserInfo(null);

  ///检查删除旧历史记录
  CachedHistoryVideoStore().deleleOldVideo();
}

void _changeTab(Action action, Context<HomeState> ctx) async {

  int index = action.payload;
  // if (index != 4) autoPlayModel.setEnable(index == 0);
  // 自动播放模型
  autoPlayModel.setEnable(index == 1);
  if (index == 1) {
    autoPlayModel.startAvailblePlayer();
  } else {
    autoPlayModel.pauseAll();
  }
  if (index != 1) {
    PlayerManager.canShowFollowDialog = false;
    PlayerManager.canShowRecommendDialog = false;
  }

  ctx.state.pageController.jumpToPage(index);

  ///刷新消息
  // if (index == 3) {
  //   ctx.broadcast(MsgActionCreator.loadMessageType());
  // }


  if (index == 0) {
    bus.emit(EventBusUtils.showActivityFloating);
  }else{
    bus.emit(EventBusUtils.closeActivityFloating);
  }



  ctx.dispatch(HomeActionCreator.changeTabOkay(index));
}
