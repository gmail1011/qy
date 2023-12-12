import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/chewie/film_video_controls.dart';
import 'package:flutter_app/widget/chewie/material_controls.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/newdialog/vip_dailog.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/task_manager/dialog_manager.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:video_player/video_player.dart';
import 'community_detail_action.dart';
import 'community_detail_state.dart';

Effect<CommunityDetailState> buildEffect() {
  return combineEffects(<Object, Effect<CommunityDetailState>>{
    CommunityDetailAction.action: _onInitData,
    Lifecycle.initState: _onInitData,
    Lifecycle.dispose: _onDispose,
    CommunityDetailAction.collect: _collectVideo,
  });
}

void _onAction(Action action, Context<CommunityDetailState> ctx) {
}
void _onDispose(Action action, Context<CommunityDetailState> ctx){
  if (ctx.state.videoPlayerController != null) {
    ctx.state.videoPlayerController.dispose();
  }

  if (ctx.state.chewieController != null) {
    ctx.state.chewieController.dispose();
  }
}

///收藏视频
void _collectVideo(
    Action action, Context<CommunityDetailState> ctx) async {
  if (ctx.state.videoModel == null) {
    return;
  }
  try {
    bool hasCollected = ctx.state.videoModel?.vidStatus?.hasCollected ?? false;

    if (hasCollected) {
      var response = await netManager.client
          .changeTagStatus(ctx.state.videoModel?.id, false, "img");
      ctx.state.videoModel?.vidStatus?.hasCollected = false;
      l.e("_collectVideo-response:", "$response");
    } else {
      var response = await netManager.client
          .changeTagStatus(ctx.state.videoModel?.id, true, "img");
      l.e("_collectVideo-response:", "$response");
      ctx.state.videoModel?.vidStatus?.hasCollected = true;
    }
    ctx.dispatch(CommunityDetailActionCreator.updateUI());
  } catch (e) {
    l.e("_collectVideo-error:", "$e");
  }
}


void _onInitData(Action action, Context<CommunityDetailState> ctx) async{
  try {
    String videoId = ctx.state.videoId ?? "";
    if (videoId.isEmpty) {
      return;
    }

    List<AdsInfoBean> adsList = await getAdsByType(AdsType.communityDetail);
    ctx.dispatch(CommunityDetailActionCreator.onAds(adsList));


    var data = await netManager.client.getWordImageDetail(videoId);

    if (data != null) {

      VideoModel videoModel = VideoModel.fromJson(data);

      ctx.dispatch(CommunityDetailActionCreator.getVideoModel(videoModel));
      EventTrackingManager().addVideoDatas(videoModel.id, videoModel.title);
      AnalyticsEvent.clickToPlayFinished(PlayFinishedType.post, videoModel.id, (videoModel.tags ?? []).map((e) => e.name).toList(),videoModel.title);
    } else {

    }

    initData(action, ctx);

    if(ctx.state.needToBottom){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

        ctx.state.scrollControllerOne.animateTo(

          ctx.state.scrollControllerOne.position.maxScrollExtent,//滚动到底部

          duration: const Duration(milliseconds: 300),

          curve: Curves.easeOut,
        );

        ctx.state.scrollControllerTwo.animateTo(

          ctx.state.scrollControllerTwo.position.maxScrollExtent,//滚动到底部

          duration: const Duration(milliseconds: 300),

          curve: Curves.easeOut,

        );
      });
    }

    
  } catch (e) {
    print(e.toString());
  }
}


initData(Action action, Context<CommunityDetailState> ctx) async {


  if (Config.videoId.contains(ctx.state.videoModel.id)) {
    ctx.state.videoModel.vidStatus.hasPaid = true;
  }

  if(ctx.state.autoPlay??false){

    ctx.state.videoUrl = CacheServer().getLocalUrl(ctx.state.videoModel.sourceURL);

    ctx.state.videoPlayerController = VideoPlayerController.network(ctx.state.videoUrl);

    await  ctx.state.videoPlayerController.initialize();

    if (isHorizontalVideo(resolutionWidth(ctx.state.videoModel.resolution),
        resolutionHeight(ctx.state.videoModel.resolution))) {
    } else {}

    ctx.state.chewieController = ChewieController(
      videoPlayerController: ctx.state.videoPlayerController,
      autoInitialize: true,
      //autoPlay: true,
      aspectRatio: isHorizontalVideo(
          resolutionWidth(ctx.state.videoModel.resolution),
          resolutionHeight(ctx.state.videoModel.resolution))
          ? 1.78
          : resolutionWidth(ctx.state.videoModel.resolution) /
          resolutionHeight(ctx.state.videoModel.resolution),
      looping: true,
      customControls: MaterialControls(),
    );

    ctx.dispatch(CommunityDetailActionCreator.updateUI());
    ctx.state.videoPlayerController.addListener(() async {
      if (ctx.state.chewieController.isFullScreen) {
        if (ctx.state.videoPlayerController.value.position.inSeconds <
            ctx.state.videoModel.freeTime) {

        } else {
          dynamic needBuyVipBool = needBuyVip(ctx.state.videoModel);

          dynamic needBuyVideoBool = needBuyVideo(ctx.state.videoModel);

          if (needBuyVipBool || needBuyVideoBool) {
            ctx.state.chewieController.exitFullScreen();

            checkOrPlay(action,ctx);
          }
        }
      }

      //检查免费时间,是否需要弹出购买视频
      if (ctx.state.videoPlayerController.value.position.inSeconds >=
          ctx.state.videoModel.freeTime &&
          needBuyVideo(ctx.state.videoModel) &&
          !Config.videoId.contains(ctx.state.videoModel.id)) {
        if (ctx.state.chewieController.isPlaying) {
          // show buy video
          //  买了之后怎么通知
          ctx.state.chewieController.pause();

          ///购买视频
          var result = await showBuyVideo(ctx.context, ctx.state.videoModel);

          ///true表示支付成功
          if (result != null && result is bool && result) {
            ctx.state.alreadyShowDialog = false;
            Config.videoId.add(ctx.state.videoModel.id);
            ctx.state.videoModel.vidStatus.hasPaid = true;
            checkOrPlay(action,ctx);
          }
        }
      }

      if (ctx.state.videoPlayerController.value.position.inSeconds >=
          ctx.state.videoModel.freeTime &&
          needBuyVip(ctx.state.videoModel) &&
          !Config.videoId.contains(ctx.state.videoModel.id)) {
        if (ctx.state.chewieController.isPlaying) {
          //  买了之后怎么通知
          ctx.state.chewieController.pause();

          ctx.state.videoPlayerController.pause();

          ///点击的必须弹出
          onShowVipDialog(action,ctx);
        }
      }
    });

    ctx.state.chewieController.play();

    checkOrPlay(action,ctx);

    if (!await needBuyVip(ctx.state.videoModel) &&
        !needBuyVideo(ctx.state.videoModel)) {
      recordPlayCount(ctx.state.videoModel, ctx.context);
    }
    sendRecord(
        ctx.state.chewieController.videoPlayerController.value.position,
        ctx.state.chewieController.videoPlayerController.value.duration,
        ctx.state.videoModel);
  }

}


// 自动检查有条件可以播放
checkOrPlay(Action action, Context<CommunityDetailState> ctx,{bool isClick = false}) async {
  if (ctx.state.videoPlayerController.value.position.inSeconds <
      ctx.state.videoModel.freeTime) {
    ctx.state.chewieController.play();
    return true;
  }

  var buyVip = await needBuyVip(ctx.state.videoModel);

  if (buyVip) {
    ctx.state.videoPlayerController.pause();
    // 买了之后怎么通知
    l.i("_tag", "_checkOrPlay()...need buy vip");

    if (isClick) {
      ///点击的必须弹出
      onShowVipDialog(action,ctx);
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
        onShowVipDialog(action,ctx);
        ctx.state. chewieController.pause();
      }
    }
  } else if (needBuyVideo(ctx.state.videoModel)) {
    if (Config.videoId.indexOf(ctx.state.videoModel.id) != -1) {
      return false;
    }

    ctx.state.videoPlayerController.pause();

    l.i("_tag", "_checkOrPlay()...need buy video");
    try {

      ctx.state.alreadyShowDialog = true;

      ///购买视频
      var result = await showBuyVideo(ctx.context, ctx.state.videoModel);

      ///true表示支付成功
      if (result != null && result is bool && result) {
        ctx.state.videoModel.vidStatus.hasPaid = true;
        ctx.state.alreadyShowDialog = false;
        if (ctx.state.videoModel.isVideo()) {
          // 支付成功���制播放
          // autoPlayModel.startAvailblePlayer();
          checkOrPlay(action,ctx);
        }

        Config.videoId.add(ctx.state.videoModel.id);
      }

    } catch (e) {
      l.e("_tag", "_checkOrPlay()...error:$e");
    }
  } else {
    l.i("_tag", "_checkOrPlay()...may begin play");
    ctx.state.chewieController.play();
  }
}



onShowVipDialog(Action action, Context<CommunityDetailState> ctx) async {
  ctx.state.videoPlayerController.pause();

  var result = await dialogManager.addDialogToQueue(() {
    return showDialog(
        context: ctx.context,
        builder: (BuildContext context) {
          return VipDialog();
        });
  }, uniqueId: "VipDialog");

  if (result != null && result is bool && result) {
    ///充值VIP
    Config.videoModel = ctx.state.videoModel;
    Config.payFromType = PayFormType.video;
  } else if (result != null && !result) {
    showShareVideoDialog(ctx.context, () {});
  }
}




/*///获取评论列表
Future<bool> _getCommentList() async {
  if (!commentHasNext) {
    _controller.loadNoData();
    return false;
  }
  _pageIndex++;
  // Map<String, dynamic> map = {};
  // map["pageNumber"] = _pageIndex;
  // map["pageSize"] = _pageSize;
  // map["objID"] = widget.videoID;
  // map["curTime"] = dateTime;
  String objID = widget.videoID;
  String curTime = dateTime;
  try {
    CommentListRes commentListRes = await netManager.client
        .getCommentList(objID, curTime, _pageIndex, _pageSize);
    if (this.mounted == false) return false;
    _controller.loadComplete();
    setState(() {
      _isFirstLoading = false;
      _isLoadError = false;
      commentHasNext = commentListRes.hasNext ?? false;
      if (totalNum == null) {
        totalNum = commentListRes.total;
      }
      for (CommentModel commentModel in commentListRes.list) {
        if (commentModel.commCount > 1 ?? false) {
          commentModel.haveMoreData = true;
        }
        commentModel.replyPageIndex = 1;
        commentList.add(commentModel);
      }
    });
  } catch (e) {
    l.d('getCommentList=', e.toString());
    _controller.loadComplete();
    if (!mounted) {
      return false;
    }
    setState(() {
      _isLoadError = true;
      _isFirstLoading = false;
    });
  }
  // getCommentList(map).then((response) {
  //   if (this.mounted == false) return;
  //   _controller.finishLoad(success: true);
  //   setState(() {
  //     _isFirstLoading = false;
  //     _isLoadError = false;
  //     CommentListRes commentListRes = CommentListRes.fromMap(response.data);
  //     commentHasNext = commentListRes.hasNext ?? false;
  //     if (totalNum == null) {
  //       totalNum = commentListRes.total;
  //     }
  //     for (CommentModel commentModel in commentListRes.list) {
  //       if (commentModel.commCount > 1 ?? false) {
  //         commentModel.haveMoreData = true;
  //       }
  //       commentModel.replyPageIndex = 1;
  //       commentList.add(commentModel);
  //     }
  //   });
  // }).catchError((error) {
  //   _controller.finishLoad(success: true);
  //   if (!mounted) {
  //     return;
  //   }
  //   setState(() {
  //     _isLoadError = true;
  //     _isFirstLoading = false;
  //   });
  // });
  return true;
}*/
