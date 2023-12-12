import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/cached_history_video_store.dart';
import 'package:flutter_app/common/manager/event_manager.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/fiction_update_model.dart';
import 'package:flutter_app/common/provider/lou_feng_update_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/city/city_video/page.dart';
import 'package:flutter_app/page/city/nearby/action.dart';
import 'package:flutter_app/page/home/post/page/common_post/action.dart';
import 'package:flutter_app/page/home/post/vipPop_banner_widget.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/user/video_user_center/action.dart';
import 'package:flutter_app/page/video/main_play_list/action.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/page/video/video_item_commponent/coin_buy_alert.dart';
import 'package:flutter_app/page/video/video_list_adapter/action.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_app/weibo_page/community_recommend/topic_detail/topic_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/task_manager/dialog_task_manager.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:provider/provider.dart';

import '../../../common/local_store/cached_video_store.dart';
import '../../alert/vip_rank_alert.dart';
import 'action.dart';
import 'state.dart';

final String _tag = "VideoItemEffect";

Effect<VideoItemState> buildEffect() {
  return combineEffects(<Object, Effect<VideoItemState>>{
    VideoItemAction.onVideoClick: _onVideoClick,
    VideoItemAction.onVideoUpdate: _onVideoUpdate,
    VideoItemAction.onVideoInited: _onVideoInited,
    VideoItemAction.onVideoRefresh: _onVideoRefresh,
    VideoItemAction.onVideoDoubleClick: _onVideoDoubleClick,
    VideoItemAction.onClickCity: _onClickCity,
    VideoItemAction.onBuyProduct: _onBuyProduct,
    VideoItemAction.onClickComment: _onClickComment,
    VideoItemAction.onShowShare: _onShowShare,
    VideoItemAction.onShowVipDialog: _onShowVipDialog,
    VideoItemAction.onFollow: _onFollow,
    VideoItemAction.onTapTag: _onTapTag,
    // VideoItemAction.onDownloadImg: _onDownloadImg,
    // VideoItemAction.onDownloadVideo: _onDownloadVideo,
    VideoItemAction.cacheVideo: _cacheVideo,
    Lifecycle.initState: _initState,
    VideoItemAction.onLove: _onLove,
    VideoItemAction.onUser: _onUser,
    Lifecycle.dispose: _dispose,
    VideoItemAction.stopPlayVideo: _stopPlayVideo,
  });
}

void _initState(Action action, Context<VideoItemState> ctx) async {
  try {
    ctx.state.tabController = TabController(
        initialIndex: 0,
        length: ctx.state.videoModel.seriesCover.length,
        vsync: ScrollableState());

    ctx.state.tabController.addListener(() {
      if (ctx.state.tabController.index > 4) {
        if (ctx.state.videoModel.isCoinVideo()) {
          if (needBuyVideo(ctx.state.videoModel)) {
            _onBuyProduct(action, ctx);
          }
        } else {
          if (!GlobalStore.isVIP()) {
            _onShowVipDialog(action, ctx);
          }
        }
      }
    });

    CachedHistoryVideoStore()
        .setCachedVideo(ctx.state.videoModel, cacheType: HISTORY_CACHED_SHORT);

    Future.delayed(Duration(milliseconds: 300), () {
      //_getLouFeng(ctx);
      //_getFiction(ctx);
    });
  } catch (e) {
    l.d('getNextNovel==', e.toString());
  }
}

/// 获取随机小说
void _getFiction(Context<VideoItemState> ctx) async {
  try {
    NovelModel novelModel = await netManager.client.getNextNovel();
    Provider.of<FictionUpdate>(ctx.context, listen: false)
        .setCountdown(novelModel);
  } catch (e) {
    l.d('getNextNovel==', e.toString());
  }
}

/// 获取随机楼凤
void _getLouFeng(Context<VideoItemState> ctx) async {
  try {
    LouFengModel louFengModel = await netManager.client.getNextLouFeng();
    Provider.of<LouFengUpdate>(ctx.context, listen: false)
        .setCountdown(louFengModel);
  } catch (e) {
    l.d('getNextLouFeng==', e.toString());
  }
}

void _stopPlayVideo(Action action, Context<VideoItemState> ctx) async {
  autoPlayModel.pauseAll();
}

void _dispose(Action action, Context<VideoItemState> ctx) async {
  ctx.state.tabController?.dispose();
  bus.off(EventBusUtils.buySuccess);
}

/// 下载视频
// void _onDownloadVideo(Action action, Context<VideoItemState> ctx) async {
//   // if (!GlobalStore.checkPermissions(13)) {
//   //   showVipLevelDialog(ctx.context);
//   //   return;
//   // }

//   if (!GlobalStore.isVIP()) {
//     showVipLevelDialog(ctx.context);
//     return;
//   }

//   if (ctx.state.cacheStatus == CacheStatus.CACHED) {
//     showToast(msg: Lang.ALREADY_CACHED_TIP);
//     return;
//   }

//   if (ctx.state.cacheStatus == CacheStatus.CACHEING) {
//     showToast(msg: Lang.CACHING_TIP);
//     return;
//   }
//   ctx.state.cacheStatus = CacheStatus.CACHEING;
//   ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));

//   var taskId = ctx.state.videoModel.sourceURL;
//   CachedVideoStore().setDownloadCachedVideo(
//       CachedVideoModel()..videoModel = ctx.state.videoModel);
// var success = await taskManager.addTaskToQueue(VideoDownloadTask(taskId),
//     (progress, {msg, isSuccess}) {
//   if (progress >= 0.3) {
//     ctx.state.cacheStatus = CacheStatus.CACHED;
//     ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
//   }
// });
//   if (success) {
//     ctx.state.cacheStatus = CacheStatus.CACHED;
//   } else {
//     ctx.state.cacheStatus = CacheStatus.UNCACHED;
//     showToast(msg: Lang.CACHE_FAILED);
//   }
//   ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
// }

///下载图片
// void _onDownloadImg(Action action, Context<VideoItemState> ctx) async {
//   // if (!GlobalStore.checkPermissions(7)) {
//   //   showVipLevelDialog(ctx.context);
//   //   return;
//   // }
//   var index = ctx.state.tabController.index;
//   ctx.state.imgDownloadIndex = index;
//   if (ctx.state.cacheStatus == CacheStatus.CACHEING) {
//     showToast(msg: Lang.DOWNLOADING_TIP);
//     return;
//   }
//   ctx.state.cacheStatus = CacheStatus.CACHEING;
//   ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
//   String imagePath = ctx.state.videoModel.seriesCover[index];
//   if (!imagePath.startsWith("http")) {
//     imagePath = path.join(Address.baseImagePath, imagePath);
//   }
//   http.Response response = await http.get(imagePath);
//   http.Response newResponse = http.Response.bytes(
//       decryptImage(response.bodyBytes), response.statusCode);
//   ctx.state.imgDownloadIndex = -1;
//   ctx.state.cacheStatus = CacheStatus.CACHED;
//   ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
//   if (newResponse.statusCode == 200 || newResponse.statusCode == 201) {
//     await PermissionHandler()
//         .requestPermissions([PermissionGroup.photos, PermissionGroup.storage]);
//     await ImageGallerySaver.saveImage(newResponse.bodyBytes);
//     showToast(msg: Lang.DOWNLOAD_SUC_AND_VIEWALBUM_TIP);
//   }
// }

/// 视频初始化回调
_onVideoInited(Action action, Context<VideoItemState> ctx) async {
  l.i(_tag, "_onVideoInited()...");
  var controller = action.payload as IjkBaseVideoController;
  controller.start();
  var model = ctx.state.videoModel;
  // if (controller.state == FijkState.prepared) {
  //   l.i(_tag, "_onVideoInited()...prepared waiting for start");
  //   await Future.delayed(Duration(milliseconds: 500));
  // }
  _checkOrPlay(ctx, controller, model);

  controller.start();
  if (!await needBuyVip(model) && !needBuyVideo(model)) {
    recordPlayCount(ctx.state.videoModel, ctx.context);
  }
}

/// 视频刷新回调
_onVideoUpdate(Action action, Context<VideoItemState> ctx) async {
  // l.i(_tag, "_onVideoUpdate()...");
  var controller = action.payload as IjkBaseVideoController;
  if (controller.state == FijkState.started) {
    ctx.state.musicKey.currentState?.startPlay();
  } else {
    ctx.state.musicKey.currentState?.stopPlay();
  }
  try {
    _videoFinish(action, ctx, controller);
  } catch (e) {}

  ///如果不是播放状态，则不执行弹出VIP和购买弹窗
  if (controller.state != FijkState.started) {
    return;
  }
  // l.i("inSeconds", "${controller.currentPos.inSeconds}");
  // l.i("controller.state", "${controller.state}");

  ///检查免费时间,是否需要弹出购买视频
  if (!ctx.state.videoModel.isAd() &&
      !controller.isDisposed &&
      controller.isPlayable() &&
      controller.currentPos.inSeconds >= ctx.state.videoModel.freeTime &&
      needBuyVideo(ctx.state.videoModel)) {
    if (controller.isPlaying) {
      controller.pause();
      ctx.dispatch(VideoItemActionCreator.onBuyProduct());
      return;
    }
  }

  ///不是VIP，超过时间限制，未支付的视频
  if (!GlobalStore.isVIP() &&
      controller.currentPos.inSeconds >= ctx.state.videoModel.freeTime &&
      (ctx.state.videoModel?.vidStatus?.hasPaid == false) &&
      !GlobalStore.isMe(ctx.state.videoModel?.publisher?.uid)) {
    controller.pause();
    l.i("freeTime", "${ctx.state.videoModel.freeTime}");

    ///点击的必须弹出
    l.i(_tag, "onShowVipDialog3");
    ctx.dispatch(VideoItemActionCreator.onShowVipDialog());
  }
}

///统计视频完播率
_videoFinish(Action action, Context<VideoItemState> ctx,
    IjkBaseVideoController controller) async {
  int playTime = ctx.state.videoModel.playTime ?? 99999;
  if (controller.currentPos.inSeconds >= playTime * 0.1 &&
      ctx.state.isDone == false) {
    ctx.state.isDone = true;
    EventTrackingManager()
        .addVideoDatas(ctx.state.videoModel.id, ctx.state.videoModel.title);
    AnalyticsEvent.clickToPlayFinished(
        PlayFinishedType.movie,
        ctx.state.videoModel.id,
        (ctx.state.videoModel.tags ?? []).map((e) => e.name).toList(),
        ctx.state.videoModel.title);
  }
}

_onVideoRefresh(Action action, Context<VideoItemState> ctx) async {
  l.i(_tag, "_onVideoRefresh()...");
  var controller = action.payload as IjkBaseVideoController;
  if (controller.isDisposed) return;
  if (controller.isPlaying) {
    controller.pause();
  } else {
    _checkOrPlay(ctx, controller, ctx.state.videoModel);
  }
}

/// ���击视频控制播放暂停
_onVideoClick(Action action, Context<VideoItemState> ctx) async {
  var controller = action.payload as IjkBaseVideoController;
  if (controller.isDisposed) return;
  if (controller.isPlaying) {
    controller.pause();
  } else {
    _checkOrPlay(ctx, controller, ctx.state.videoModel, isClick: true);
  }
}

/// 视频双击
_onVideoDoubleClick(Action action, Context<VideoItemState> ctx) async {
  // 双击点赞
  if (ctx.state.videoModel.vidStatus.hasLiked) {
    return;
  }
  eagleClick(ctx.state.selfId(),
      sourceId: ctx.state.eagleId(ctx.context),
      label: "${ctx.state.type?.index}_double_like");
  ctx.state.videoModel.vidStatus.hasLiked = true;
  ctx.state.videoModel.likeCount++;
  // TODO FIXME CONTROLLER
  () async {
    try {
      await netManager.client.sendLike(ctx.state.videoModel.id, "video");
    } catch (e) {
      l.e(_tag, "sendLike()...error:$e");
    }
  }();
  ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
}

// 自动检查有条件可以播放
_checkOrPlay(Context<VideoItemState> ctx, IjkBaseVideoController controller,
    VideoModel videoModel,
    {bool isClick = false}) async {
  if (null == controller || controller.isDisposed || null == videoModel) {
    l.e(_tag, "_checkOrPlay()... something error");
    return;
  }
  if (controller.uniqueId != ctx.state.uniqueId) {
    l.e(_tag, "_checkOrPlay()... uniqueId not equal");
    return;
  }

  if (!autoPlayModel.enable() && controller.isPlaying) {
    l.e(_tag,
        "_checkOrPlay()...not enable may not in curPage:${controller.state.toString()}");
    controller.pause();
    // else {
    //   l.e(_tag, "_checkOrPlay()...not enable force call pause");
    //   controller.pause();
    // }
    return;
  }

  if (videoModel.isAd()) {
    if (!controller.isPlaying) {
      await controller.start();
    }
    l.e(_tag, "_checkOrPlay()...cur video is ad");
    return;
  }
  var buyVip = await needBuyVip(videoModel);
  l.i(_tag,
      "_checkOrPlay()...controllerSource:${controller?.sourceUrl} ==> cur:${ctx.state?.videoModel?.sourceURL}");
  if (buyVip) {
    // 买了之后怎么通知
    l.i(_tag, "_checkOrPlay()...need buy vip");
    if (controller.isInitialed && controller.isPlaying) {
      await controller.pause();
    }
    if (isClick) {
      if (!GlobalStore.isVIP() &&
          controller.currentPos.inSeconds >= ctx.state.videoModel.freeTime &&
          (ctx.state.videoModel?.vidStatus?.hasPaid == false)) {
        ///点击的必须弹出
        l.i(_tag, "onShowVipDialog1");
        ctx.dispatch(VideoItemActionCreator.onShowVipDialog());
      } else {
        controller.start();
      }
    } else {
      String temp = await lightKV.getString(Config.VIP_SHOW_TIME);
      bool isShow = false;
      DateTime currentTime = DateTime.now();
      if (TextUtil.isEmpty(temp)) {
        isShow = true;
      } else {
        DateTime localTime = DateTime.parse(temp);
        localTime =
            DateTime(localTime.year, localTime.month, localTime.day, 24, 0);
        if (localTime.isBefore(currentTime)) {
          isShow = true;
        }
      }
      if (isShow) {
        if (!GlobalStore.isVIP() &&
            controller.currentPos.inSeconds >= ctx.state.videoModel.freeTime &&
            (ctx.state.videoModel?.vidStatus?.hasPaid == false)) {
          l.i(_tag, "onShowVipDialog2");
          ctx.dispatch(VideoItemActionCreator.onShowVipDialog());
        } else {
          controller.start();
        }
      }
    }
  } else if (needBuyVideo(videoModel)) {
    l.i(_tag, "_checkOrPlay()...need buy video");
    try {
      await controller.seekTo(0);
      await controller.start();
    } catch (e) {
      l.e(_tag, "_checkOrPlay()...error:$e");
    }
  } else {
    l.i(_tag, "_checkOrPlay()...may begin play");
    if (controller.isPlayable() && !controller.isPlaying) {
      l.i(_tag, "_checkOrPlay()...begin real play");
      controller.start();
      // ctx.dispatch(VideoItemActionCreator.refreshItem(ctx.state.uniqueId));
    }
  }
}

void _onTapTag(Action action, Context<VideoItemState> ctx) async {
  var map = action.payload;
  String tagId = map['tagId'];
  GlobalVariable.eventBus.fire(LoadOriginEvent(3));
  Map<String, dynamic> parameter = Map();
  parameter['tagId'] = tagId;
  autoPlayModel.pauseAll();
  // await JRouter().go(PAGE_TAG, arguments: parameter);
  /*Gets.Get.to(TagPage().buildPage(parameter),opaque: false).then((value) {
    autoPlayModel.playAll();
  });*/
  //autoPlayModel.startAvailblePlayer();

  TagsBean tagsBean = new TagsBean();
  tagsBean.id = tagId;
  tagsBean.name = map['name'];
  tagsBean.coverImg = map['cover'];
  tagsBean.playCount = map['playCount'];

  Navigator.of(ctx.context).push(
    MaterialPageRoute(
      builder: (context) {
        return TopicDetailPage().buildPage({"tagsBean": tagsBean});
      },
    ),
  ).then((value) {
    autoPlayModel.playAll();
  });
}

void _onUser(Action action, Context<VideoItemState> ctx) async {
  //autoPlayModel.disposeAll();
  autoPlayModel.pauseAll();
  if (ctx.state.type == VideoListType.SECOND &&
      GlobalStore.isMe(ctx.state.videoModel.publisher.uid)) {
    safePopPage(); // 短视频自己主页不跳转
  } else {
    Map<String, dynamic> arguments = {
      'uid': ctx.state.videoModel.publisher.uid,
      'uniqueId': DateTime.now().toIso8601String(),
      // KEY_VIDEO_LIST_TYPE: VideoListType.NONE
    };
    // await JRouter().go(PAGE_VIDEO_USER_CENTER, arguments: arguments);

    Gets.Get.to(
      BloggerPage(arguments),
    ).then((value) {
      autoPlayModel.playAll();
    });
    // autoPlayModel.startAvailblePlayer();
  }
}

///点赞或取消点赞回调
_onLove(Action action, Context<VideoItemState> ctx) async {
  bool hasLiked = !ctx.state.videoModel.vidStatus.hasLiked;
  // var req = {
  //   "objID": ctx.state.videoModel.id,
  //   "type": "video",
  // };
  String objID = ctx.state.videoModel.id;
  String type = 'video';
  if (hasLiked) {
    ctx.state.videoModel.vidStatus.hasLiked = true;
    ctx.state.videoModel.likeCount++;
    () async {
      try {
        await netManager.client.sendLike(objID, type);
      } catch (e) {
        l.e(_tag, "sendLike()...error:$e");
      }
    }();
  } else {
    ctx.state.videoModel.vidStatus.hasLiked = false;
    ctx.state.videoModel.likeCount--;
    () async {
      try {
        await netManager.client.cancelLike(objID, type);
      } catch (e) {
        l.e(_tag, "cancelLike()...error:$e");
      }
    }();
  }
  // GlobalVariable.eventBus
  //     .fire(FullPlayerLoveStatusEvent(ctx.state.videoModel.vidStatus.hasLiked));
  ctx.dispatch(VideoListAdapterActionCreator.refreshItemUI(ctx.state));
}

void _onFollow(Action action, Context<VideoItemState> ctx) async {
  Map<String, dynamic> map = action.payload;

  if (GlobalStore.isMe(ctx.state.videoModel.publisher.uid)) {
    showToast(msg: Lang.GLOBAL_TIP_TXT1);
    return;
  }
  bool isFollow = map['isFollow'];
  if (ctx.state.videoModel.publisher.hasFollowed != isFollow) {
    ctx.state.videoModel.publisher.hasFollowed = isFollow;
  }
  // Map<String, dynamic> parameter = {
  //   "followUID": ctx.state.videoModel.publisher.uid,
  //   "isFollow": isFollow,
  // };
  // BaseResponse baseResponse = await getFollow(parameter);

  int followUID = ctx.state.videoModel.publisher.uid;
  try {
    await netManager.client.getFollow(followUID, isFollow);
    ctx.dispatch(
        VideoItemActionCreator.refreshFollowStatus(ctx.state.uniqueId));

    ///刷新以下四个界面的数据 1、 用户中心 2、附近 3、撩吧 4、推荐
    map.remove('uniqueId');
    ctx.broadcast(MainPlayerListActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(NearbyActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(CommonPostActionCreator.onRefreshFollowStatus(map));
    ctx.broadcast(VideoUserCenterActionCreator.onRefreshFollowStatus(map));
  } catch (e) {
    l.e('getFollow', e.toString());
    showToast(msg: e.toString());
  }
}

///點擊城市
_onClickCity(Action action, Context<VideoItemState> ctx) async {
  GlobalVariable.eventBus.fire(LoadOriginEvent(3));
  Map<String, String> parameter = {
    "city": ctx.state.videoModel.location.city,
    "id": ctx.state.videoModel.location.id,
  };
  autoPlayModel.pauseAll();
  // await JRouter().go(PAGE_CITY_VIDEO, arguments: parameter);
  Gets.Get.to(CityVideoPage().buildPage(parameter), opaque: false)
      .then((value) {
    autoPlayModel.playAll();
  });
}

bool isBeforeToday() {
  var startDate = GlobalStore.getMe().goldVideoFreeExpire;
  var endDate = new DateTime.now();
  return DateTime.parse(startDate).isBefore(endDate);
}

bool isShowBuyDialog = false;

///弹出购买提示���
_onBuyProduct(Action action, Context<VideoItemState> ctx) async {
  // l.i("videoItem Effect", "_onBuyProduct()...");
  /*if (!autoPlayModel.enable()) {
    return;
  }*/

  ///购买vip后10金币以下免费
  /*var result;
  if(ctx.state.videoModel.coins <= 10 && !isBeforeToday()){
    result = true;
  }else{
    //购买视频
    result = await showBuyVideo(ctx.context, ctx.state.videoModel);
  }*/

  autoPlayModel.pauseAll();

  if (!isShowBuyDialog) {
    showDialog(
        context: ctx.context,
        builder: (context) {
          return CoinBuyAlert(videoModel: ctx.state.videoModel);
        }).then((value) {
      isShowBuyDialog = false;
      GlobalStore.updateUserInfo(null);

      ///true表示支付成功
      if (value != null && value is bool && value) {
        if (ctx.state.videoModel.isVideo()) {
          ctx.dispatch(
              VideoListAdapterActionCreator.buyProductSuccess(ctx.state));
          // 支付成功���制播放
          autoPlayModel.startAvailblePlayer();
          Config.videoId.add(ctx.state.videoModel.id);
          bus.emit(EventBusUtils.buySuccess);
          //_checkOrPlay(ctx, autoPlayModel.curPlayCtrl, ctx.state.videoModel);
        } else {
          Config.videoId.add(ctx.state.videoModel.id);
          ctx.state.videoModel?.vidStatus?.hasPaid = true;
          ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
        }
      }
    });
  }

  ///购买视频
  /*var result = await showBuyVideo(ctx.context, ctx.state.videoModel);

  ///true表示支付成功
  if (result != null && result is bool && result) {
    ctx.dispatch(VideoListAdapterActionCreator.buyProductSuccess(ctx.state));
    if (ctx.state.videoModel.isVideo()) {
      // 支付成功���制播放
      // autoPlayModel.startAvailblePlayer();
      _checkOrPlay(ctx, autoPlayModel.curPlayCtrl, ctx.state.videoModel);
    }
  }*/
}

///弹出评论提示框
_onClickComment(Action action, Context<VideoItemState> ctx) {
  if (ctx.state.videoModel.status != 1 && ctx.state.videoModel.status != 3) {
    ///审核未通过，不弹出提示框
    showToast(msg: Lang.GLOBAL_TIP_TXT2, gravity: ToastGravity.CENTER);
    return;
  }

  showCommentDialog(
    context: ctx.context,
    id: ctx.state.videoModel.id,
    index: ctx.state.index,
    province: ctx.state.videoModel?.location?.province ?? "",
    city: ctx.state.videoModel?.location?.city ?? "",
    visitNum: "${ctx.state.videoModel?.location?.visit ?? 0}",
    height: screen.screenHeight * 0.65,
    callback: (Map<String, dynamic> map) {
      ctx.dispatch(VideoListAdapterActionCreator.commentSuccess(ctx.state));
    },
  );
}

///弹出分享提示框
_onShowShare(Action action, Context<VideoItemState> ctx) {
  autoPlayModel.disposeAll();
  showShareVideoDialog(ctx.context, () async {
    await Future.delayed(Duration(milliseconds: 500));
    autoPlayModel.startAvailblePlayer();
  },
      videoModel: ctx.state.videoModel,
      isLongVideo: isHorizontalVideo(
          resolutionWidth(ctx.state.videoModel.resolution),
          resolutionHeight(ctx.state.videoModel.resolution)));
}

_onShowVipDialog(Action action, Context<VideoItemState> ctx) async {
  if (!autoPlayModel.enable()) {
    l.i(_tag, "弹出购买vip视频  but bot enable,may not in current page");
    return;
  }

  /*var result = await dialogManager.addDialogToQueue(() {
    return showDialog(
        context: ctx.context,
        builder: (BuildContext context) {
          return VipDialog();
        });
  }, uniqueId: "VipDialog");*/
  l.i(_tag, "弹出购买vip视频");

  if ((Config?.pops?.length ?? 0) > 0) {
    var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
      return showDialog(
          context: ctx.context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white.withOpacity(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17)),
              child: StatefulBuilder(builder: (context, states) {
                return Container(
                  child: VipPopBannerWidget(
                    Config.pops,
                    width: ScreenUtil().screenWidth,
                    height: 394.w,
                    videoInfo: ctx.state.videoModel,
                    onItemClick: (index) {
                      // var ad = state.adsList[index];
                      // JRouter().handleAdsInfo(ad.href, id: ad.id);
                    },
                  ),
                );
              }),
            );
          });
    }, uniqueId: "VipPop");

    newDialogTaskManager.remove("VipPop");

    if (result != null && result is bool && result) {
      ///充值VIP
      Config.videoModel = ctx.state.videoModel;
      Config.payFromType = PayFormType.video;
    } else if (result != null && !result) {
      await showShareVideoDialog(ctx.context, () {},
          isLongVideo: isHorizontalVideo(
              resolutionWidth(ctx.state.videoModel.resolution),
              resolutionHeight(ctx.state.videoModel.resolution)));
    }
  } else {
    var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
      return showDialog(
          context: ctx.context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17)),
              child: StatefulBuilder(builder: (context, states) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 235, 217, 1),
                          Color.fromRGBO(255, 255, 255, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    //height: 264.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 18.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/weibo/video_la_ba.png",
                              width: 28.w,
                              height: 28.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "观看提示",
                              style: TextStyle(
                                  fontSize: 18.nsp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.w,
                        ),
                        Container(
                          height: 1.w,
                          color: Color.fromRGBO(230, 230, 230, 1),
                        ),
                        SizedBox(
                          height: 21.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "邀请好友立刻免费观看1天",
                              style: TextStyle(
                                  fontSize: 17.nsp, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 21.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "邀请好友购买会员最高返利76%",
                              style: TextStyle(
                                  fontSize: 17.nsp, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 21.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Config.videoModel = ctx.state.videoModel;
                                  Config.payFromType = PayFormType.video;
                                  Gets.Get.to(
                                    MemberCentrePage()
                                        .buildPage({"position": "0"}),
                                  ).then((value) {
                                    GlobalStore.updateUserInfo(null);
                                    safePopPage();
                                  });
                                  AnalyticsEvent.clickBuyMembership(
                                      ctx.state.videoModel.title,
                                      ctx.state.videoModel.id,
                                      (ctx.state.videoModel.tags ?? [])
                                          .map((e) => e.name)
                                          .toList(),
                                      VipPopUpsType.vip);
                                },
                                child: Image.asset(
                                  "assets/weibo/video_open_vip.png",
                                  height: 36.w,
                                )),
                            GestureDetector(
                              onTap: () {
                                showShareVideoDialog(ctx.context, () {},
                                    videoModel: ctx.state.videoModel,
                                    isLongVideo: isHorizontalVideo(
                                        resolutionWidth(
                                            ctx.state.videoModel.resolution),
                                        resolutionHeight(
                                            ctx.state.videoModel.resolution)));
                                //safePopPage();
                              },
                              child: Image.asset(
                                "assets/weibo/video_invite.png",
                                height: 36.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 21.w,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          });
    }, uniqueId: "VipDialog");

    newDialogTaskManager.remove("VipDialog");

    if (result != null && result is bool && result) {
      ///充值VIP
      Config.videoModel = ctx.state.videoModel;
      Config.payFromType = PayFormType.video;
    } else if (result != null && !result) {
      await showShareVideoDialog(ctx.context, () {},
          isLongVideo: isHorizontalVideo(
              resolutionWidth(ctx.state.videoModel.resolution),
              resolutionHeight(ctx.state.videoModel.resolution)));
    }
  }
  if (ctx.state.videoModel.isImg()) {
    ctx.dispatch(VideoItemActionCreator.refreshUI(ctx.state.uniqueId));
  }
}

///缓存视频
void _cacheVideo(Action action, Context<VideoItemState> ctx) async {
  if (ctx.state.videoModel == null) {
    return;
  }

  if (ctx.state.videoModel.isCoinVideo()) {
    if (needBuyVideo(ctx.state.videoModel)) {
      _onBuyProduct(action, ctx);
      return;
    }
  }

  if (!GlobalStore.isVIP()) {
    VipRankAlert.show(
      ctx.context,
      type: VipAlertType.cache,
    );
    return;
  }

  bool isCached =
      CachedVideoStore().inCachedList(ctx.state.videoModel?.sourceURL);
  if (isCached) {
    showToast(msg: Lang.ALREADY_CACHED_TIP);
    return;
  }

  ///检查今日是否已缓存10次视频
  bool isCachedLimit = await CachedVideoStore().checkVideoCachedCountInToday();
  if (isCachedLimit) {
    showToast(msg: "今日已缓存10次视频～");
    return;
  }
  CachedVideoStore()
      .setCachedVideo(ctx.state.videoModel, cacheType: CACHED_TYPE_SHORT);
  showToast(msg: "已加入缓存");
}
