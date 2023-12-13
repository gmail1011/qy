import 'dart:async';
import 'dart:math';

import 'package:fbroadcast/fbroadcast.dart' hide StatefulBuilder;
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/cached_history_video_store.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/can_play_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/model/watch_count_model.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareHomePage.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_task.dart';
import 'package:flutter_app/page/home/post/vipPop_banner_widget.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/chewie/film_video_controls.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/newdialog/vip_dailog.dart';
import 'package:flutter_app/widget/dialog/newdialog/vip_dailog_hjll.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/task_manager/dialog_task_manager.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:video_player/video_player.dart';

import 'action.dart';
import 'film_video_comment/action.dart';
import 'film_video_introduction/action.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<FilmTvVideoDetailState> buildEffect() {
  return combineEffects(<Object, Effect<FilmTvVideoDetailState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    FilmTvVideoDetailAction.refreshVideoDetail: _refreshVideoDetail,
    FilmTvVideoDetailAction.updateVideoStatus: _updateVideoStatus,
    FilmTvVideoDetailAction.closeAd: _closeAd,

    FilmVideoIntroductionAction.notifyNewVideo: _receiveNotifyNewVideo,
    FilmVideoIntroductionAction.notifyBuyVideo: _notifyBuyVideo,

    FilmVideoIntroductionAction.notifyReStartPlayVideo: _replayVideoAgain,
    FilmVideoCommentAction.notifyReStartPlayVideo: _replayVideoAgain,

    ///通知停止播放视频
    FilmVideoIntroductionAction.stopVideoPlay: _stopVideoPlay,
    FilmVideoCommentAction.stopVideoPlay: _stopVideoPlay,

    FilmTvVideoDetailAction.hjllBuyVIP: _hjllBuyVip,
    FilmTvVideoDetailAction.hjllBuyCoinVideo: _hjllBuyCoinVideo,
  });
}



///请求视频信息
void _initState(Action action, Context<FilmTvVideoDetailState> ctx) async {

  ctx.state.tabController =
      TabController(length: 2, vsync: ScrollableState());

  //如果当前是缓存视频
  if (ctx.state.viewModel != null) {
    await _adsCountdown(action, ctx);
    _initVideoPlayer(ctx);
    ctx.state.tabController.addListener(() {
      debugPrint("ewe23ewfefe");
    });

    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    ctx.state.baseRequestController?.requestSuccess();
    AnalyticsEvent.playMoviesEvent(
        title: ctx.state.viewModel.title ?? '',
        tags: (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
        id: ctx.state.viewModel.id,
        sectionId: ctx.state.sectionId);
  } else {
    _refreshVideoDetail(action, ctx);
  }
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());

  if (ctx.state.tabController != null) {
    ctx.state.tabController.addListener(() {
      debugPrint("dfheufhuehfeu");
    });
  }
  for (int i = 0; i < Address.cdnAddressLists.length; i++) {
    DomainInfo domainInfo = Address.cdnAddressLists[i];
    PopModel popModel =
    PopModel(name: domainInfo.desc, fontSize: Dimens.pt13, id: i);
    ctx.state.listPopModel.add(popModel);
  }
  ctx.state.domainInfo = Address.currentDomainInfo;
  CacheServer().setSelectLine(ctx.state.domainInfo.url);

  FBroadcast.instance().register(VariableConfig.refreshVideo, (value, callback) {

    if(ctx.state.chewieController != null){
      ctx.state.chewieController.pause();
    }

    ctx.state.videoInited = false;

    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());

    VideoModel viewModel = value;

    ctx.state.viewModel = null;

    ctx.state.videoId = viewModel.id;

    _refreshVideoDetail(action, ctx, isSwitchVideo: true, newModel: value);

  });
}

///刷新视频列表
void _refreshVideoDetail(Action action, Context<FilmTvVideoDetailState> ctx,
    {bool isSwitchVideo = false, VideoModel newModel}) async {
  try {
    String videoId = ctx.state.videoId ?? "";
    if (videoId.isEmpty && newModel == null) {
      return;
    }
    ctx.state.baseRequestController?.requesting();
    if(newModel == null) {
      var data = await netManager.client.getVideoDetail(videoId, ctx.state.sectionId);
      newModel =  VideoModel.fromJson(data.toJson());
    }
    if (newModel != null) {
      ctx.state.viewModel = newModel;
      await _adsCountdown(action, ctx);

      if(isSwitchVideo){
        _reStartVideoPlayer(ctx, 2);
      }else{
        _initVideoPlayer(ctx,);
      }

      if(isSwitchVideo){

        FBroadcast.instance().broadcast(VariableConfig.refreshVideoInfo,value: ctx.state.viewModel);

      }

      ctx.state.tabController =
          TabController(length: 2, vsync: ScrollableState());
      ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
      ctx.state.baseRequestController?.requestSuccess();
      AnalyticsEvent.playMoviesEvent(
          title: ctx.state.viewModel.title ?? '',
          tags: (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
          id: videoId,
          sectionId: ctx.state.sectionId);
    } else {
      ctx.state.baseRequestController?.requestFail();
    }

    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
  } catch (e) {
    l.e("getVideoDetail-error:", "$e");
    ctx.state.baseRequestController?.requestFail();
  }
}

///非VIP用户 播放次数控制
_playCount(Context<FilmTvVideoDetailState> ctx) async {
  try {
    VideoModel videoInfo = ctx.state.viewModel;
    WatchCount watchObj = await netManager.client.getPlayStatus(videoInfo.id);
    playCountModel.setPlayCnt(watchObj?.watchCount ?? 0);

    ///刷新视频状态
    _checkVideoStatus(ctx, watchObj);
  } catch (e) {
    l.d('getPlayStatus', e.toString());
  }
}

///检查当前视频状态
_checkVideoStatusHjll(
    Context<FilmTvVideoDetailState> ctx, WatchCount watchObj) {
  VideoModel videoInfo = ctx.state.viewModel;
  bool isVip = GlobalStore.isVIP();
  //当前缓存视频
  if ((ctx.state.isCacheVideo ?? false) || videoInfo.watch.isFreeWatch) {
    ctx.state.videoStatus = -1;
    ctx.state.vStatusName = "";
  } else if (!isVip &&
      (watchObj?.watchCount ?? 0) > 0 &&
      videoInfo.originCoins == 0) {
    //免费观看 剩余次数
    ctx.state.videoStatus = 0;
    ctx.state.vStatusName = "免费视频剩余${watchObj?.watchCount}次";
  } else if (isVip && videoInfo.originCoins == 0) {
    //已享VIP免费特权
    ctx.state.videoStatus = 1;
    ctx.state.vStatusName = "已享VIP免费特权";
  } else if (videoInfo.vidStatus.hasPaid) {
    //已购买完整版
    ctx.state.videoStatus = 2;
    ctx.state.vStatusName = "已购买完整版";
  } else if (!isVip &&
      videoInfo.originCoins == 0 &&
      checkPlayedToday(videoInfo?.id)) {
    //每日免费视频
    ctx.state.videoStatus = 3;
    ctx.state.vStatusName = "每日免费视频";
  } else if (!isVip &&
      !(watchObj?.isCan ?? false) &&
      videoInfo.originCoins == 0) {
    //购买VIP
    ctx.state.videoStatus = 4;
    ctx.state.vStatusName = "观看完整版";
  } else if (videoInfo.originCoins > 0 && !videoInfo.vidStatus.hasPaid) {
    //金币视频，没有购买
    ctx.state.videoStatus = 5;
    ctx.state.vStatusName = "${videoInfo.videoCoin()}金币跳过预览";
  }
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
}

///检查当前视频状态
_checkVideoStatus(Context<FilmTvVideoDetailState> ctx, WatchCount watchObj) {
  VideoModel videoInfo = ctx.state.viewModel;
  bool isVip = GlobalStore.isVIP();
  //当前缓存视频
  if ((ctx.state.isCacheVideo ?? false) || videoInfo.watch.isFreeWatch) {
    ctx.state.videoStatus = -1;
    ctx.state.vStatusName = "";
  } else if (!isVip &&
      (watchObj?.watchCount ?? 0) > 0 &&
      videoInfo.originCoins == 0) {
    //免费观看 剩余次数
    ctx.state.videoStatus = 0;
    ctx.state.vStatusName = "免费视频剩余${watchObj?.watchCount}次";
  } else if (isVip && videoInfo.originCoins == 0) {
    //已享VIP免费特权
    ctx.state.videoStatus = 1;
    ctx.state.vStatusName = "已享VIP免费特权";
  } else if (videoInfo.vidStatus.hasPaid) {
    //已购买完整版
    ctx.state.videoStatus = 2;
    ctx.state.vStatusName = "已购买完整版";
  } else if (!isVip &&
      videoInfo.originCoins == 0 &&
      checkPlayedToday(videoInfo?.id)) {
    //每日免费视频
    ctx.state.videoStatus = 3;
    ctx.state.vStatusName = "每日免费视频";
  } else if (!isVip &&
      !(watchObj?.isCan ?? false) &&
      videoInfo.originCoins == 0) {
    //购买VIP
    ctx.state.videoStatus = 4;
    ctx.state.vStatusName = "跳过预览";
  } else if (videoInfo.originCoins > 0 && !videoInfo.vidStatus.hasPaid) {
    //金币视频，没有购买
    ctx.state.videoStatus = 5;
    ctx.state.vStatusName = "${videoInfo.videoCoin()}金币跳过预览";
  }
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
}

///检查今日是否播放过
bool checkPlayedToday(String videoId) {
  ///已经播放过的则可以播放
  bool isInclude = false;
  if (VariableConfig.playedVideoList != null) {
    VariableConfig.playedVideoList.forEach((model) {
      if (model.videoID == videoId) {
        isInclude = true;
      }
    });
  }
  return isInclude;
}

String vid = "";

///统计视频完播率
videoFinish(Context<FilmTvVideoDetailState> ctx) async {

  if( ctx.state.videoPlayerController != null){

    Duration inSeconds = ctx.state.videoPlayerController?.value?.position;
    Duration duration = ctx.state.videoPlayerController?.value?.duration;
    if (inSeconds.inSeconds >= duration.inSeconds * 0.1 &&
        vid != ctx.state.viewModel.id) {
      // Duration durationTime = Duration(milliseconds:1000);
      // ctx.state.timerFinished?.cancel();
      // ctx.state.timerFinished = Timer(durationTime,(){
      vid = ctx.state.viewModel.id;
      EventTrackingManager()
          .addVideoDatas(ctx.state.viewModel.id, ctx.state.viewModel.title);
      AnalyticsEvent.clickToPlayFinished(
          PlayFinishedType.movie,
          ctx.state.viewModel.id,
          (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
          ctx.state.viewModel.title);
      // });
    }

  }

}

///保存视频历史缓存
void _saveVideoHistoryCache(Context<FilmTvVideoDetailState> ctx) async {
  CachedHistoryVideoStore()
      .setCachedVideo(ctx.state.viewModel, cacheType: HISTORY_CACHED_FILM);
}

///初始化视频播放器
void _initVideoPlayer(
    Context<FilmTvVideoDetailState> ctx, {
      int inSeconds,
    }) async {
  try {
    // _saveVideoHistoryCache(ctx);

    ///播放次数判断
    await _playCount(ctx);

    String videoUrl = CacheServer().getLocalUrl(ctx.state.viewModel?.sourceURL);
    ctx.state.videoPlayerController = VideoPlayerController.network(videoUrl);
    int curT =  DateTime.now().millisecondsSinceEpoch;

    await ctx.state.videoPlayerController?.initialize();

    ctx.state.chewieController = ChewieController(
      videoPlayerController: ctx.state.videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      aspectRatio: isHorizontalVideo(
          resolutionWidth(ctx.state.viewModel?.resolution),
          resolutionHeight(ctx.state.viewModel?.resolution))
          ? 1.78
          : resolutionWidth(ctx.state.viewModel?.resolution) /
          resolutionHeight(ctx.state.viewModel?.resolution),
      looping: true,
      customControls: FilmVideoControls(),
      errorBuilder: (context, error) {
        return GestureDetector(
          onTap: () async {
            Duration inSeconds =
            await ctx.state.videoPlayerController?.position;
            l.e("controller-inSeconds:", "${inSeconds?.inSeconds}");

            ///重新开始播放
            _reStartVideoPlayer(ctx, inSeconds?.inSeconds ?? 0);
          },
          child: Container(
            width: screen.screenWidth,
            height: screen.screenWidth / 1.78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_disabled,
                  color: Colors.white,
                  size: 42,
                ),
                Text(
                  "点击重试",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    ///是否重载视频
    bool isReloadVideo = (inSeconds ?? 0) > 0;

    ctx.state.videoListener = () async {
      try {
        videoFinish(ctx);

        if(ctx.state.videoPlayerController.value.position.inSeconds == 1){
          if(!ctx.state.chewieController.isPlaying){
            ctx.state.videoPlayerController.play();
            ctx.state.chewieController.play();
          }
        }

      } catch (e) {}
      if (ctx.state.viewModel.watch.isFreeWatch) {
        return;
      }
      if (ctx.state.chewieController?.isFullScreen ?? false) {
        if (ctx.state.videoPlayerController.value.position.inSeconds <
            ctx.state.viewModel?.freeTime) {
        } else {
          ///判断不是缓存视频，判断进入
          if (!(ctx.state.isCacheVideo ?? false)) {
            dynamic needBuyVipBool = needBuyVip(ctx.state.viewModel);
            dynamic needBuyVideoBool = needBuyVideo(ctx.state.viewModel);
            if (needBuyVipBool || needBuyVideoBool) {
              ctx.state.chewieController?.exitFullScreen();
              await _checkOrPlay(ctx);
            }
          }
        }
      } else {
        if ((ctx.state.videoPlayerController?.value?.position?.inSeconds ?? 0) <
            ctx.state.viewModel?.freeTime) {
          //判断已购买或者VIP视频，跳转到指定位置-开始播放
          if (isReloadVideo &&
              (inSeconds ?? 0) > 1 &&
              ((ctx.state.viewModel?.vidStatus?.hasPaid ?? false) ||
                  (GlobalStore.isVIP() &&
                      ctx.state.viewModel?.originCoins == 0))) {
            isReloadVideo = false;
            l.e("判断已购买或者VIP视频，跳转到指定位置", "开始播放");
            //跳转到指定位置
            //ctx.state.videoPlayerController?.seekTo(Duration(seconds: inSeconds - 1));

            ctx.state.videoPlayerController?.seekTo(Duration(seconds: 0));

          }
        }
      }

      ///判断不是缓存视频
      if (!(ctx.state.isCacheVideo ?? false) ||
          !ctx.state.viewModel.watch.isFreeWatch) {
        ///检查免费时间,是否需要弹出购买视频
        if ((ctx.state.videoPlayerController?.value?.position?.inSeconds ??
            0) >=
            ctx.state.viewModel?.freeTime &&
            needBuyVideo(ctx.state.viewModel) &&
            !Config.videoId.contains(ctx.state.viewModel?.id)) {
          if (ctx.state.isStopPlayStatus ?? false) {
            l.d("停止播放视频状态", "不弹出金币购买提示框");
            return;
          }

          ///弹出金币购买提示框
          l.d("--------->", "弹出金币购买提示框");
          // _showGoldcoinBuyDialog(ctx);
          //妻友社区逻辑
          _hjllUpdateVideoBuyVideo(ctx);
        }
        if ((ctx.state.videoPlayerController?.value?.position?.inSeconds ??
            0) >=
            ctx.state.viewModel?.freeTime &&
            needBuyVip(ctx.state.viewModel) &&
            !Config.videoId.contains(ctx.state.viewModel?.id)) {
          if (ctx.state.isStopPlayStatus ?? false) {
            l.d("停止播放视频状态", "不弹出金币购买提示框");
            return;
          }

          ///弹出VIP购买弹出框
          l.d("--------->", "弹出VIP购买弹出框");
          // _showVipBuyDialog(ctx, false);
          //妻友社区逻辑
          _hjllUpdateVideoBuyVip(ctx);
        }
      }
    };

    ///视频播放器监听器
    ctx.state.videoPlayerController?.addListener(ctx.state.videoListener);

    if (!ctx.state.viewModel.watch.isFreeWatch) {
      ///初始化完成，开始播放，免费的不主动播放
      _playVideoController(ctx);
    }

    ///判断不是缓存视频
    if (!(ctx.state.isCacheVideo ?? false)) {
      if (!needBuyVip(ctx.state.viewModel) &&
          !needBuyVideo(ctx.state.viewModel)) {
        recordPlayCount(ctx.state.viewModel, ctx.context);
      }

      await _checkOrPlay(ctx);

      sendRecord(
          ctx.state.chewieController?.videoPlayerController?.value?.position,
          ctx.state.chewieController?.videoPlayerController?.value?.duration,
          ctx.state.viewModel);
    }

    ///视频初始化完成
    ctx.state.videoInited = true;
    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
  } catch (e) {
    ctx.state.loadingWidget.cancel();
    l.e("初始化播放器异常", "$e");
    showToast(msg: "初始化播放器异常");
  }
}

///弹出VIP购买弹出框
_showVipBuyDialog(Context<FilmTvVideoDetailState> ctx, bool isClickBuyButton) {
  if (ctx.state.chewieController?.isPlaying ?? false) {
    // show buy video
    //  买了之后怎么通知
    ctx.state.chewieController?.pause();
    ctx.state.videoPlayerController?.pause();
    // 买了之后怎么通知
    l.i("_tag", "_checkOrPlay()...need buy vip");

    ///停止自动播放后在弹出购买VIP
    if (!isClickBuyButton) {
      _onShowVipDialog(ctx);
    }
  }

  ///点击的必须弹出购买VIP
  if (isClickBuyButton) {
    _onShowVipDialog(ctx);
  }
}

_showVipBuyDialogHjll(
    Context<FilmTvVideoDetailState> ctx, bool isClickBuyButton) {
  if (ctx.state.chewieController?.isPlaying ?? false) {
    // show buy video
    //  买了之后怎么通知
    ctx.state.chewieController?.pause();
    ctx.state.videoPlayerController?.pause();
    // 买了之后怎么通知
    l.i("_tag", "_checkOrPlay()...need buy vip");

    ///停止自动播放后在弹出购买VIP
    if (!isClickBuyButton) {
      _onShowVipDialogHjll(ctx);
    }
  }

  ///点击的必须弹出购买VIP
  if (isClickBuyButton) {
    _onShowVipDialogHjll(ctx);
  }
}

_hjllUpdateVideoBuyVip(Context<FilmTvVideoDetailState> ctx) {
  if (ctx.state.chewieController?.isPlaying ?? false) {
    // show buy video
    //  买了之后怎么通知
    ctx.state.chewieController?.pause();
    ctx.state.videoPlayerController?.pause();
    // 买了之后怎么通知
    l.i("_tag", "_checkOrPlay()...need buy vip");
  }
  ctx.state.intoBuyVipPoiont = true;
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
}

_hjllUpdateVideoBuyVideo(Context<FilmTvVideoDetailState> ctx) {
  if (ctx.state.chewieController?.isPlaying ?? false) {
    //  买了之后怎么通知
    ctx.state.chewieController?.pause();
    ctx.state.videoPlayerController?.pause();
  }
  ctx.state.alreadyShowDialog = true;
  ctx.state.intoBuyVideoPoiont = true;
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
}

_hjllBuyVip(Action action, Context<FilmTvVideoDetailState> ctx) {
  //进入会员中心
  ///充值VIP
  Config.videoModel = ctx.state.viewModel;
  Config.payFromType = PayFormType.video;
  Navigator.of(ctx.context).push(MaterialPageRoute(
    builder: (context) {
      return RechargeVipPage("");
    },
  )).then((value) async {
    await GlobalStore.updateUserInfo(null);

    ///判断如果是VIP，则执行可以观看视频
    if (GlobalStore.isVIP() ?? false) {
      ctx.state.viewModel?.originCoins = 0;
      l.e("——————>", "充值VIP返回$value");

      ///检查次数，以及更新视频状态
      _playCount(ctx);
      ctx.state.intoBuyVipPoiont = false;
      ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    }
  });
  Gets.Get.to(() => RechargeVipPage("")).then((value) async {
    await GlobalStore.updateUserInfo(null);

    ///判断如果是VIP，则执行可以观看视频
    if (GlobalStore.isVIP() ?? false) {
      ctx.state.viewModel?.originCoins = 0;
      l.e("——————>", "充值VIP返回$value");

      ///检查次数，以及更新视频状态
      _playCount(ctx);
      ctx.state.intoBuyVipPoiont = false;
      ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    }
  });
  Config.videoModel = ctx.state.viewModel;
  Config.payFromType = PayFormType.video;
  AnalyticsEvent.clickBuyMembership(
      ctx.state.viewModel.title,
      ctx.state.viewModel.id,
      (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
      VipPopUpsType.vip);
}

///妻友社区购买金币视频
_hjllBuyCoinVideo(Action action, Context<FilmTvVideoDetailState> ctx) async {
  bool buySuccess = await _buyProduct(ctx.context, ctx.state.viewModel);
  if (buySuccess) {
    ctx.state.alreadyShowDialog = false;
    Config.videoId.add(ctx.state.viewModel?.id);
    ctx.state.viewModel?.vidStatus?.hasPaid = true;
    ctx.state.intoBuyVideoPoiont = false;
    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    showToast(msg: "购买视频成功～");

    ///检查次数，以及更新视频状态
    await _playCount(ctx);
  }
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
  AnalyticsEvent.clickBuyMembership(
      ctx.state.viewModel.title,
      ctx.state.viewModel.id,
      (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
      VipPopUpsType.gold);
}

_showGoldcoinBuyDialogHjll(Context<FilmTvVideoDetailState> ctx) async {
  if (ctx.state.chewieController?.isPlaying ?? false) {
    //  买了之后怎么通知
    ctx.state.chewieController?.pause();
  }
  ctx.state.alreadyShowDialog = true;

  ///购买视频
  var result = await showBuyVideoHjll(ctx.context, ctx.state.viewModel);
  l.e("购买视频返回结果：", "$result");

  ///true表示支付成功
  if (result != null && result is bool && result) {
    newDialogTaskManager.remove("showBuyVideo");
    bool buySuccess = await _buyProduct(ctx.context, ctx.state.viewModel);
    if (buySuccess) {
      ctx.state.alreadyShowDialog = false;
      Config.videoId.add(ctx.state.viewModel?.id);
      ctx.state.viewModel?.vidStatus?.hasPaid = true;
      ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());

      showToast(msg: "购买视频成功～");

      ///检查次数，以及更新视频状态
      await _playCount(ctx);
    }
  } else if (result != null && result == "toTaskPage") {
    //进入任务中心
    Navigator.of(ctx.context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SpecailWelfareViewTaskPage();
    }));
  } else if (result != null && result == 'buyNow') {
    ctx.dispatch(FilmTvVideoDetailActionCreator.hjllBuyCoinVideo());
  }
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
  AnalyticsEvent.clickBuyMembership(
      ctx.state.viewModel.title,
      ctx.state.viewModel.id,
      (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
      VipPopUpsType.gold);
}

///购买作品
Future<bool> _buyProduct(BuildContext context, VideoModel videoModel) async {
  try {
    String productID = videoModel?.id;
    String name = videoModel?.title;
    int amount = videoModel?.coins;
    WBLoadingDialog.show(context);

    var result =
    await netManager.client.postBuyVideo(productID, name, amount, 1);
    l.e("购买视频返回数据", "$result");
    WBLoadingDialog.dismiss(context);
    GlobalStore.updateUserInfo(null);
    return Future.value(true);
  } catch (e) {
    WBLoadingDialog.dismiss(context);
    var error = e.error;
    if (error is ApiException) {
      if (error.code == 8000) {
        ///进入会员中心充值金币
        Config.videoModel = videoModel;
        Config.payFromType = PayFormType.video;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return RechargeGoldPage();
        }));
      }
    } else {
      showToast(msg: e.toString());
    }
    l.d('productBuy', e.toString());
    return Future.value(false);
  }
}

/// 自动检查有条件可以播放
Future<bool> _checkOrPlay(Context<FilmTvVideoDetailState> ctx,
    {bool isClick = false}) async {
  if (ctx.state.videoPlayerController.value.position.inSeconds <
      ctx.state.viewModel?.freeTime) {
    if (!ctx.state.viewModel.watch.isFreeWatch) {
      _playVideoController(ctx);
    }

    return true;
  }

  var buyVip = needBuyVip(ctx.state.viewModel);
  if (buyVip) {
    ctx.state.videoPlayerController?.pause();

    /// 买了之后怎么通知
    l.i("_tag", "_checkOrPlay()...need buy vip");

    if (isClick) {
      ///点击的必须弹出
      // _onShowVipDialog(ctx);
      _showVipBuyDialogHjll(ctx, false);
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
        // _onShowVipDialog(ctx);
        _showVipBuyDialogHjll(ctx, false);
        ctx.state.chewieController?.pause();
      }
    }
  } else if (needBuyVideo(ctx.state.viewModel)) {
    if (Config.videoId.indexOf(ctx.state.viewModel?.id) != -1) {
      return false;
    }

    ctx.state.videoPlayerController?.pause();
    l.i("_tag", "_checkOrPlay()...need buy video");
    try {
      ctx.state.alreadyShowDialog = true;

      ///购买视频
      var result = await showBuyVideoHjll(ctx.context, ctx.state.viewModel);

      l.e("购买视频返回结果2：", "$result");

      ///true表示支付成功
      if (result != null && result is bool && result) {
        newDialogTaskManager.remove("showBuyVideo");
        bool buySuccess = await _buyProduct(ctx.context, ctx.state.viewModel);
        if (buySuccess) {
          ctx.state.viewModel?.vidStatus?.hasPaid = true;
          ctx.state.alreadyShowDialog = false;
          Config.videoId.add(ctx.state.viewModel?.id);
          ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
          showToast(msg: "购买视频成功～");

          ///检查次数，以及更新视频状态
          await _playCount(ctx);

          ///如果视频暂停，则开始播放
          if (!(ctx.state.chewieController?.isPlaying ?? false)) {
            _playVideoController(ctx);
          }
        } else {
          showToast(msg: "购买视频失败～");
        }
      }

      ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    } catch (e) {
      l.e("_tag", "_checkOrPlay()...error:$e");
    }
  } else {
    l.i("_tag", "_checkOrPlay()...may begin play");
    _playVideoController(ctx);
  }
  return true;
}

///展示VIP 购买对话框
void _onShowVipDialog(Context<FilmTvVideoDetailState> ctx) async {
  ctx.state.videoPlayerController?.pause();
  l.e("——————>", "展示VIP 购买对话框");

  var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
    return Config.pops.length > 0
        ? _showVipPop(ctx)
        : showDialog(
        context: ctx.context,
        builder: (BuildContext context) {
          return VipDialog();
        });
  }, uniqueId: "VipDialog");

  l.e("——————>", "展示VIP 购买对话框返回结果：$result");

  if (result != null && result == "toMemberCenter") {
    //进入会员中心
    ///充值VIP
    Config.videoModel = ctx.state.viewModel;
    Config.payFromType = PayFormType.video;

    Navigator.of(ctx.context).push(MaterialPageRoute(
      builder: (context) {
        return RechargeVipPage("");
      },
    )).then((value) async {
      await GlobalStore.updateUserInfo(null);

      ///判断如果是VIP，则执行可以观看视频
      if (GlobalStore.isVIP() ?? false) {
        ctx.state.viewModel?.originCoins = 0;
        l.e("——————>", "充值VIP返回$value");

        ///检查次数，以及更新视频状态
        _playCount(ctx);
        ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
      }
    });
    Config.videoModel = ctx.state.viewModel;
    Config.payFromType = PayFormType.video;
    AnalyticsEvent.clickBuyMembership(
        ctx.state.viewModel.title,
        ctx.state.viewModel.id,
        (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
        VipPopUpsType.vip);
  } else if (result != null && result == "toPersonalCard") {
    //进入推广UI
    JRouter().go(PAGE_PERSONAL_CARD);
    AnalyticsEvent.clickBuyMembershipShare(
        ctx.state.viewModel.title,
        ctx.state.viewModel.id,
        (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
        VipPopUpsType.vip);
  } else if (result != null && (result is bool && !result)) {
    showShareVideoDialog(ctx.context, () {});
  } else if ("cancel" == result) {
    l.e("——————>", "取消了VIP 购买对话框");
  }
}

///展示VIP 购买对话框
void _onShowVipDialogHjll(Context<FilmTvVideoDetailState> ctx) async {
  ctx.state.videoPlayerController?.pause();
  l.e("——————>", "展示VIP 购买对话框");

  var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
    return showDialog(
        context: ctx.context,
        builder: (BuildContext context) {
          return VipDialogHjllView();
        });
  }, uniqueId: "VipDialog");

  l.e("——————>", "展示VIP 购买对话框返回结果：$result");

  if (result != null && result == "toMemberCenter") {
    //进入会员中心
    ///充值VIP
    Config.videoModel = ctx.state.viewModel;
    Config.payFromType = PayFormType.video;
    Navigator.of(ctx.context).push(MaterialPageRoute(
      builder: (context) {
        return RechargeVipPage("");
      },
    )).then((value) async {
      await GlobalStore.updateUserInfo(null);

      ///判断如果是VIP，则执行可以观看视频
      if (GlobalStore.isVIP() ?? false) {
        ctx.state.viewModel?.originCoins = 0;
        l.e("——————>", "充值VIP返回$value");

        ///检查次数，以及更新视频状态
        _playCount(ctx);
        ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
      }
    });
    Config.videoModel = ctx.state.viewModel;
    Config.payFromType = PayFormType.video;
    AnalyticsEvent.clickBuyMembership(
        ctx.state.viewModel.title,
        ctx.state.viewModel.id,
        (ctx.state.viewModel.tags ?? []).map((e) => e.name).toList(),
        VipPopUpsType.vip);
  } else if (result != null && result == "toTaskPage") {
    //进入任务中心
    Navigator.of(ctx.context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SpecailWelfareViewTaskPage();
    }));
  }
}

_showVipPop(ctx) {
  return showDialog(
      context: ctx.context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          child: StatefulBuilder(builder: (context, states) {
            return Container(
              child: VipPopBannerWidget(
                Config.pops,
                width: ScreenUtil().screenWidth,
                height: 394,
                videoInfo: ctx.state.viewModel,
                onItemClick: (index) {
                  // var ad = state.adsList[index];
                  // JRouter().handleAdsInfo(ad.href, id: ad.id);
                },
              ),
            );
          }),
        );
      });
}

///接收通知新视频
void _receiveNotifyNewVideo(
    Action action, Context<FilmTvVideoDetailState> ctx) {
  try {
    l.e("接收通知新视频-isStopPlayStatus", "${ctx.state.isStopPlayStatus}");
    if (ctx.state.isStopPlayStatus) {
      l.e("接收通知新视频-长视频界面不可以见", "不接收切换视频广播");
      return;
    }

    VideoModel videoItem = action.payload as VideoModel;
    l.e("接收到通知新视频", "${videoItem.id}");
    ctx.state.videoInited = false;
    ctx.state.viewModel = videoItem;
    ctx.state.videoId = videoItem?.id;

    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());

    final oldVideoPlayerController = ctx.state.videoPlayerController;
    final oldChewiePlayerController = ctx.state.chewieController;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (oldVideoPlayerController != null) {
        await oldVideoPlayerController?.dispose();
      }
      if (oldChewiePlayerController != null) {
        oldChewiePlayerController?.dispose();
      }

      ctx.state.videoPlayerController = null;
      ctx.state.chewieController = null;
      ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
      // Initing new controller
      await _adsCountdown(action, ctx);
      CacheServer().setSelectLine(Address.cdnAddress);
      _initVideoPlayer(ctx);
    });
  } catch (e) {
    l.e("接收通知新视频", "$e");
  }
}

///更新视频显示状态
void _updateVideoStatus(
    Action action, Context<FilmTvVideoDetailState> ctx) async {
  try {
    int videoStatus = action.payload as int;
    l.e("点击视频播放状态-videoStatus", "$videoStatus");
    if (videoStatus == 4) {
      ///弹出VIP购买弹出框
      _showVipBuyDialogHjll(ctx, true);
    } else if (videoStatus == 5) {
      // ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
      ///弹出金币购买提示框-金币视频，没有购买
      _showGoldcoinBuyDialogHjll(ctx);
    }
  } catch (e) {
    l.e("_updateVideoStatus", "$e");
  }
}

///通知停止播放
void _stopVideoPlay(Action action, Context<FilmTvVideoDetailState> ctx) async {
  try {
    l.e("_stopVideoPlay", "接收通知停止播放");
    String videoIdByStop = action.payload as String;
    if (videoIdByStop == ctx.state.videoId) {
      ///设置停止播放状态
      ctx.dispatch(FilmTvVideoDetailActionCreator.setStopVideoState());

      ///停止播放视频
      if ((ctx.state.chewieController?.isPlaying ?? false)) {
        ctx.state.chewieController?.pause();
        ctx.state.videoPlayerController?.pause();
      }

      ///释放资源，保存当前的进度，返回后执行播放
      Duration inSeconds = await ctx.state.videoPlayerController?.position;
      l.e("通知停止播放-inSeconds:", "${inSeconds?.inSeconds}");

      ///保存当前的进度
      ctx.dispatch(FilmTvVideoDetailActionCreator.upddateCurrentPlayDuration(
          inSeconds?.inSeconds ?? 0));

      ///释放资源
      _releaseVideoConfig(ctx);
    }
  } catch (e) {
    l.e("_stopVideoPlay", "$e");
  }
}

///通知购买视频
void _notifyBuyVideo(Action action, Context<FilmTvVideoDetailState> ctx) async {
  try {
    String videoId = action.payload as String;
    l.e("购买视频videoId：", "$videoId");

    ///true表示支付成功
    if (ctx.state.videoId == videoId) {
      newDialogTaskManager.remove("showBuyVideo");
      bool buySuccess = await _buyProduct(ctx.context, ctx.state.viewModel);
      if (buySuccess) {
        ctx.state.alreadyShowDialog = false;
        ctx.state.intoBuyVideoPoiont = false;
        Config.videoId.add(ctx.state.viewModel?.id);
        ctx.state.viewModel?.vidStatus?.hasPaid = true;

        ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
        showToast(msg: "购买视频成功～");

        ///检查次数，以及更新视频状态
        await _playCount(ctx);
      }
    }
  } catch (e) {
    l.e("购买视频错误：", "$e");
  }
  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
}

///重新开始播放
void _reStartVideoPlayer(Context<FilmTvVideoDetailState> ctx, int inSeconds) {
  ctx.state.videoInited = false;
  ctx.state.isStopPlayStatus = false;

  ///视频播放器监听器
  if (ctx.state.videoListener != null) {
    ctx.state.videoPlayerController?.removeListener(ctx.state.videoListener);
    ctx.state.videoListener = null;
  }

  ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());

  final oldVideoPlayerController = ctx.state.videoPlayerController;
  final oldChewiePlayerController = ctx.state.chewieController;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (oldVideoPlayerController != null) {
      await oldVideoPlayerController?.dispose();
    }
    if (oldChewiePlayerController != null) {
      oldChewiePlayerController?.dispose();
    }

    ctx.state.videoPlayerController = null;
    ctx.state.chewieController = null;
    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
    // Initing new controller
    _initVideoPlayer(ctx, inSeconds: inSeconds);
  });
}

///释放视频播放videoPlayerController
void _releaseVideoConfig(Context<FilmTvVideoDetailState> ctx) {
  ///视频播放器监听器
  if (ctx.state.videoListener != null) {
    ctx.state.videoPlayerController?.removeListener(ctx.state.videoListener);
    ctx.state.videoListener = null;
  }
  final oldVideoPlayerController = ctx.state.videoPlayerController;
  final oldChewiePlayerController = ctx.state.chewieController;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (oldVideoPlayerController != null) {
      await oldVideoPlayerController?.dispose();
    }
    if (oldChewiePlayerController != null) {
      oldChewiePlayerController?.dispose();
    }
    ctx.state.videoPlayerController = null;
    ctx.state.chewieController = null;
    ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
  });
}

///返回后执行播放-重置执行播放
void _replayVideoAgain(
    Action action, Context<FilmTvVideoDetailState> ctx) async {
  String videoId = action.payload as String;
  if (videoId == ctx.state.videoId) {
    ///重新开始播放
    _reStartVideoPlayer(ctx, ctx.state.currentPlayDuration ?? 0);
  }
}

void _dispose(Action action, Context<FilmTvVideoDetailState> ctx) {

  FBroadcast.instance().dispose();

  ///视频播放器监听器
  if (ctx.state.videoListener != null) {
    ctx.state.videoPlayerController?.removeListener(ctx.state.videoListener);
    ctx.state.videoListener = null;
  }
  ctx.state.tabController?.dispose();
  ctx.state.videoPlayerController?.dispose();
  ctx.state.chewieController?.dispose();
  ctx.state.timer?.cancel();

  if (ctx.state.videoPlayerController.value != null) {
    ///发送观看记录
    sendRecord(ctx.state.videoPlayerController.value.position,
        ctx.state.videoPlayerController.value.duration, ctx.state.viewModel);
  }
}

Future _adsCountdown(Action action, Context<FilmTvVideoDetailState> ctx) async {
  bool isShowAds = true;

  VideoModel viewModel = ctx.state.viewModel;
  if (viewModel.vidStatus.hasPaid == true) {
    Config.hasVideoAd = false;
    isShowAds = false; // 购买的视频不显示广告
  } else if (GlobalStore.isVIP() == true && viewModel.isCoinVideo() == false) {
    isShowAds = false; //会员看会员视频不显示广告
    Config.hasVideoAd = false;
  } else {
    isShowAds = true;
  }

  ///获取广告
  List<AdsInfoBean> list = await getAdsByType(AdsType.freeVideo);
  List<AdsInfoBean> newList =
  list?.where((it) => (it.duration ?? 0) > 0)?.toList();
  ctx.state.adsList = newList;
  if (newList.isNotEmpty == true) {
    ctx.state.adsIndex = Random().nextInt(newList.length) % newList.length;
  }
  if (isShowAds && newList.isNotEmpty == true) {
    Config.hasVideoAd = true;
    //ctx.state.countdownTime = ctx.state.adsList[0].duration;
    ctx.state.countdownTime = newList.first.duration;
    // print('${ctx.state.adsList[0].duration}-----------------------------');
    // print('${ctx.state.countdownTime}++++++++++++++++++++++++++++++++++++++');
    // int timer = ctx.state.countdownTime;
    const oneSec = const Duration(seconds: 1);
    ctx.state.videoPlayerController?.pause();
    var callback = (timer) {
      ctx.state.countdownTime = ctx.state.countdownTime - 1;
      ctx.dispatch(FilmTvVideoDetailActionCreator.onCountDownTime(
          ctx.state.countdownTime));
      if (ctx.state.countdownTime == 0) {
        timer.cancel();
      }
    };
    ctx.state.timer = Timer.periodic(oneSec, callback);
  }
}

_closeAd(Action action, Context<FilmTvVideoDetailState> ctx) async {
  if (ctx.state.isCanClose) {
    ctx.state.countdownTime = 0;
    ctx.state.timer?.cancel();
    ctx.state.timer = null;
    Config.hasVideoAd = false;
    ctx.dispatch(FilmTvVideoDetailActionCreator.onCountDownTime(
        ctx.state.countdownTime));
    _playVideoController(ctx);
  } else {
    Config.videoModel = ctx.state.viewModel;
    Config.payFromType = PayFormType.video;
    ctx.state.isToVipPage = true;
    Gets.Get.to(() => RechargeVipPage("")).then((value) async {
      ctx.state.isToVipPage = false;
      await GlobalStore.updateUserInfo(null);
      if (GlobalStore.isVIP() ?? false) {
        ctx.state.viewModel?.originCoins = 0;
        l.e("——————>", "充值VIP返回$value");

        ///检查次数，以及更新视频状态
        _playCount(ctx);
        ctx.dispatch(FilmTvVideoDetailActionCreator.updateUI());
      }
    });
  }
}

_playVideoController(Context<FilmTvVideoDetailState> ctx) {
  // if (ctx.state.countdownTime > 1) {
  //   return;
  // }
  if (ctx.state.isToVipPage) {
    return;
  }
  ctx.state.videoPlayerController?.play();
}
