import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/alert/coin_post_alert.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/city/city_video/page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/community_recommend/topic_detail/topic_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/post_video_logic.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/chewie/material_controls.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WordImageWidget extends StatefulWidget {
  final VideoModel videoModel;
  final int index;
  final bool isHideBottom;
  final VoidCallback retryOnTap;
  final bool isHideFollow;
  final bool isShowSetTop;
  bool showVideoCover;

  final bool isBloggerPage;
  final bool isDetail;
  final bool autoPlayStyle;
  final bool hideTopUserInfo;

  String randomTag;
  LinearGradient linearGradient;

  Function(int) visibleCallBack;
  Function(int) hideCallBack;
  WordImageWidget(
      {Key key,
      this.videoModel,
      this.index,
      this.isHideBottom,
      this.isHideFollow = false,
      this.isShowSetTop = false,
      this.retryOnTap,
      this.isBloggerPage = false,
      this.isDetail = false,
      this.showVideoCover = true,
      this.randomTag,
      this.linearGradient,
      this.autoPlayStyle = false,
      this.visibleCallBack,
      this.hideCallBack,
        this.hideTopUserInfo = false,
     })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WordImageWidgetState();
  }
}

class WordImageWidgetState extends State<WordImageWidget> {
  String videoUrl;

  VideoPlayerController controller;

  String videoError = "";
  bool isPlaying = false;

  GlobalKey key = GlobalKey();

  RecommendListModel recommendListModel = RecommendListModel();

  bool isHorizontalVideoUI = false;

  double  aspectRatio;
  ///是否横向视频
  @override
  void initState() {
    super.initState();
    key = key;

    ///初始化获取视频横竖屏
    if (widget.videoModel.newsType == "SP") {
      isHorizontalVideoUI = isHorizontalVideo(
          resolutionWidth(widget.videoModel.resolution),
          resolutionHeight(widget.videoModel.resolution));
    } else if (widget.videoModel.newsType == "MOVIE") {
      isHorizontalVideoUI = true;
    }
    if(widget.autoPlayStyle??false){
      PostVideoLogic.addListener(playListen);
      initVideoController();
    }
  }

  void playListen(int index, bool play) {
    if (play == true && widget.index == index) {
      initVideoController();
    } else {
      controller?.pause();
      if (isPlaying) {
        safeFlashUI();
      }
      isPlaying = false;
    }
  }

  Future<bool> safeFlashUI() async {
    if (!mounted) return false;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {});
    return true;
  }

  bool isGaussValue(index, limitCount){
    if(index < limitCount){
      return false;
    }
    if(widget.videoModel.isCoinVideo() == true){
      if(needBuyVideo(widget.videoModel)){
        return true;
      }
    }else {
      if(!GlobalStore.isVIP()){
        return true;
      }
    }
    return false;
  }

  startPlay() {
    if(controller!=null){
      controller.play();
    }
    // PostVideoLogic.play(widget.index);
  }

  pausePlay() {
    if(controller!=null){
      controller.pause();
    }
    // PostVideoLogic.pauseAll();
  }


  initVideoController() async {
    videoUrl = CacheServer().getLocalUrl(widget.videoModel.sourceURL);
    try {
      if (controller == null) {
        controller = VideoPlayerController.network(videoUrl);
        safeFlashUI();
        controller?.addListener(_listenCallback);
        await controller?.initialize();
        aspectRatio = controller.value.aspectRatio;
        if(aspectRatio>1){
          isHorizontalVideoUI = true;
        }else{
          isHorizontalVideoUI = false;
        }
        controller?.setVolume(0);
        if (widget.index == PostVideoLogic.playingIndex) {
          if (mounted) {
            controller?.play();
            if (isPlaying == false) {
              safeFlashUI();
            }
            isPlaying = true;
          }
        }
      } else {
        if (controller?.value.initialized == true) {
          controller?.play();
          if (isPlaying == false) {
            safeFlashUI();
          }
          isPlaying = true;
        }
      }

    } catch (e) {
      videoError = e.toString();
      safeFlashUI();
      debugLog("post video error: $e");
    }


  }
  initData() async {
    videoUrl = CacheServer().getLocalUrl(widget.videoModel.sourceURL);

    controller = VideoPlayerController.network(videoUrl);

    await controller.initialize();
    aspectRatio = controller.value.aspectRatio;
    if(aspectRatio>1){
      isHorizontalVideoUI = true;
    }else{
      isHorizontalVideoUI = false;
    }
    if(Config.autoPlayVoiceClose){
      controller?.setVolume(0);
    }else{
      controller?.setVolume(1);
    }
    controller.addListener(() async {
      if (controller.value.position.inSeconds >= 10) {
        controller.seekTo(Duration(milliseconds: 0));
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildVideoItem() {
    if (controller != null && widget.autoPlayStyle == true && videoError.isEmpty) {
      return VideoPlayer(controller);
    } else {
      return CustomNetworkImage(
        imageUrl: widget.videoModel?.cover,
        placeholder: Container(
          color: const Color(0xff000000),
        ),
        fit: BoxFit.cover,
      );
    }
  }

  void _listenCallback() {
    int offset = controller?.value.position.inSeconds ?? 0;
    if (offset > 10) {
      controller?.seekTo(const Duration(seconds: 0));
    }
  }

  @override
  void dispose() {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    _imageCache.clear();
    controller?.removeListener(_listenCallback);
    controller?.dispose();
    PostVideoLogic.removeListener(playListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.videoModel.isRandomAd()){
      return SizedBox();
    }

    VideoResolution videoResolution;
    if(widget.autoPlayStyle??false){
      double vHeight = 250;
      double vWidth = 360;
      if (widget.videoModel?.resolution?.isNotEmpty ?? false) {
        List<String> list = widget.videoModel?.resolution?.split("*") ?? [];
        if (list.length == 2) {
          vWidth = double.parse(list[0]);
          vHeight = double.parse(list[1]);
        }
      }
      //横屏
      if (vWidth > vHeight) {
        videoResolution = configVideoSize(
          328,
          328 * 9 / 16,
          widget.videoModel?.resolutionWidth(),
          widget.videoModel?.resolutionHeight(),
          true,
        );
        if (videoResolution.videoWidth > screen.screenWidth) {
          //32 为左右边距
          videoResolution.videoWidth = screen.screenWidth - 32;
        }
      } else {
        if(aspectRatio==null){
          aspectRatio = 0.5;
        }
        videoResolution = configVideoSize(360*aspectRatio, 360, widget.videoModel?.resolutionWidth(), widget.videoModel?.resolutionHeight(), true);
        if (videoResolution.videoHeight > 360) {
          videoResolution.videoHeight = 360;
        }
      }
    }
    return widget.videoModel == null
        ? Center(
            child: CErrorWidget(
              Lang.EMPTY_DATA,
              retryOnTap: widget.retryOnTap == null
                  ? null
                  : () {
                      if (widget.retryOnTap != null) {
                        //widget.controller.requesting();
                        widget.retryOnTap?.call();
                      }
                    },
            ),
          )
        : widget.videoModel?.newsType != NEWSTYPE_AD_IMG ? _buildRecommandVideoUI(videoResolution): _buildRecommandAdUI();
  }

  ///创建推荐广告
  Widget _buildRecommandAdUI() {
    return Container(
      color: AppColors.weiboJianPrimaryBackground,
      margin: EdgeInsets.only(bottom: 15.w),
      padding:
          EdgeInsets.only(left: 16.w, top: 11.w, right: 16.w, bottom: 10.w),
      child: GestureDetector(
        onTap: () {
          if (TextUtil.isNotEmpty(widget.videoModel?.linkUrl)) {
            JRouter().handleAdsInfo(widget.videoModel?.linkUrl);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomNetworkImage(
            width: 1.sw,
            height: 223.w,
            type: ImgType.avatar,
            imageUrl: widget.videoModel?.cover,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  ///创建视频列表
  Widget _buildRecommandVideoUI(VideoResolution videoResolution) {
    return GestureDetector(
      onTap: widget.isDetail == true ? null : () {
        bus.emit(EventBusUtils.closeActivityFloating);
        pausePlay();
        Gets.Get.to(
                CommunityDetailPage()
                    .buildPage({"videoId": widget.videoModel.id,"randomTag": widget.randomTag, "randomLinearGradient":widget.linearGradient}),
                opaque: false)
            .then((value) {
          startPlay();

          bus.emit(EventBusUtils.showActivityFloating);
        });
      },
      child: Container(
        color: Color.fromRGBO(14, 20, 30, 1),
        margin: EdgeInsets.only(bottom: 15.w),
        padding:
            EdgeInsets.only(left: 16.w, top: 11.w, right: 16.w, bottom: 10.w),
        child: Column(
          children: [
            Offstage(
              offstage: widget.videoModel.isForWard == true ? false : true,
              child: GestureDetector(
                onTap: () {
                  bus.emit(EventBusUtils.closeActivityFloating);
                  Map<String, dynamic> map = {
                    'uid': widget.videoModel.forWardUser,
                    'uniqueId': DateTime.now().toIso8601String(),
                  };
                  pausePlay();

                  Gets.Get.to(
                    () => BloggerPage(map),
                    opaque: false,
                  ).then((value) {
                    startPlay();

                    bus.emit(EventBusUtils.showActivityFloating);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.w),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/weibo/forward_icon.png",
                        width: 20.w,
                        height: 20.w,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Container(
                        child: Text(
                          widget.videoModel.forWardUserName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15.nsp),
                        ),
                      ),
                      Text(
                        "  转发了",
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                            fontSize: 15.nsp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            (widget.hideTopUserInfo??false)?SizedBox():Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        bus.emit(EventBusUtils.closeActivityFloating);

                        Map<String, dynamic> arguments = {
                          'uid': widget.videoModel.publisher.uid,
                          'publisher': widget.videoModel.publisher,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };

                        pausePlay();

                        Gets.Get.to(() => BloggerPage(arguments), opaque: false)
                            .then((value) {
                          bus.emit(EventBusUtils.refreshRecommendFollowStatus);
                          startPlay();

                          bus.emit(EventBusUtils.showActivityFloating);
                        });
                      },
                      child: HeaderWidget(
                        headPath: widget.videoModel.publisher?.portrait ?? "",
                        level: (widget.videoModel.publisher?.superUser ?? false)? 1 : 0,
                        headWidth: 52.w,
                        headHeight: 52.w,
                        levelSize: 17.w,
                        positionedSize: 0,
                        isCertified:
                            widget.videoModel?.publisher?.merchantUser == 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        bus.emit(EventBusUtils.closeActivityFloating);
                        Map<String, dynamic> arguments = {
                          'uid': widget.videoModel.publisher.uid,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };

                        pausePlay();

                        bus.emit(EventBusUtils.closeActivityFloating);

                        Gets.Get.to(() => BloggerPage(arguments), opaque: false)
                            .then((value) {

                          startPlay();
                          bus.emit(EventBusUtils.showActivityFloating);
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              widget.videoModel.publisher?.name ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color:
                                  // widget.videoModel.publisher?.isVip == true &&
                                  //         widget.videoModel.publisher?.vipLevel >
                                  //             0
                                  //     ? Color.fromRGBO(246, 197, 89, 1)
                                  //     :
                                  Colors.white,
                                  fontSize: 14.nsp),
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          // TextUtils.isEmt(ic_uptag)
                          (widget.videoModel.publisher.upTag==null || widget.videoModel.publisher.upTag=="")?SizedBox():Image.asset("assets/weibo/ic_uptag.png",width: 20,height: 20),
                          SizedBox(
                            width: 10.w,
                          ),
                          // Row(
                          //   children: (widget.videoModel.publisher?.awardsExpire ?? [])
                          //       .map((e) {
                          //     return e.isExpire
                          //         ? Row(
                          //             children: [
                          //               CustomNetworkImage(
                          //                 imageUrl: e.imageUrl ?? "",
                          //                 width: 18.w,
                          //                 height: 18.w,
                          //                 fit: BoxFit.cover,
                          //                 placeholder: Container(
                          //                   color: Colors.transparent,
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 width: 10.w,
                          //               ),
                          //             ],
                          //           )
                          //         : Container();
                          //   }).toList(),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Text(
                            //   widget.videoModel.publisher?.upTag ?? "",
                            //   style: TextStyle(
                            //       color: Color.fromRGBO(124, 135, 159, 1),
                            //       fontSize: 14.nsp),
                            // ),
                            // SizedBox(
                            //   width: 16.w,
                            // ),
                            ( widget.videoModel.publisher?.isVip??false)
                                ? Container(
                                padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
                                child: (widget.videoModel.publisher?.vipLevel==1)?Text("月卡用户",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1),fontSize: 10),)
                                        :(widget.videoModel.publisher?.vipLevel==2)?Text("季卡用户",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1),fontSize: 10),)
                                        :(widget.videoModel.publisher?.vipLevel==3)?Text("年卡用户",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1),fontSize: 10),)
                                         :Text("永久会员",style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1)),),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(238, 217, 180, 1),
                                      Color.fromRGBO(174, 138, 95, 1)
                                    ]
                                  )
                                ),
                                )
                                : Container(),
                            SizedBox(width: 6,),
                            Text(
                              formatTimeTwo(widget.videoModel.createdAt),
                              style: TextStyle(
                                  color: Color.fromRGBO(124, 135, 159, 1),
                                  fontSize: 14.nsp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Offstage(
                  offstage: widget.isHideFollow ?? false ? true : false,
                  child: GestureDetector(
                    onTap: () async {
                      // 自己不能关注自己
                      if (GlobalStore.isMe(widget.videoModel.publisher.uid)) {
                        showToast(msg: Lang.GLOBAL_TIP_TXT1);
                        return;
                      }
                      bool isFollow = !widget.videoModel.publisher.hasFollowed;

                      widget.videoModel.publisher.hasFollowed = isFollow;

                      int followUID = widget.videoModel.publisher.uid;
                      try {
                        await netManager.client.getFollow(followUID, isFollow);

                        setState(() {});
                      } catch (e) {
                        //l.d('getFollow', e.toString());
                        showToast(
                            msg: Lang.FOLLOW_ERROR,
                            gravity: ToastGravity.CENTER);
                      }
                    },
                    child: Visibility(
                      visible: widget.videoModel.publisher?.hasFollowed == true ||
                              widget.videoModel.publisher?.uid ==
                                  GlobalStore.getMe().uid
                          ? false
                          : true,
                      child: Container(
                          width: 63,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(0, 214, 190, 1),
                                  width: Dimens.pt1),
                              left: BorderSide(
                                  color: Color.fromRGBO(0, 214, 190, 1),
                                  width: Dimens.pt1),
                              right: BorderSide(
                                  color: Color.fromRGBO(0, 214, 190, 1),
                                  width: Dimens.pt1),
                              bottom: BorderSide(
                                  color: Color.fromRGBO(0, 214, 190, 1),
                                  width: Dimens.pt1),
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("+",style: TextStyle(color: Color.fromRGBO(0, 214, 190, 1),fontWeight: FontWeight.bold,fontSize: 13),),
                              Text("关注",style: TextStyle(color: Color.fromRGBO(0, 214, 190, 1),fontSize: 12),),
                            ],
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.w,
            ),
            GestureDetector(
              onTap: () {
                bus.emit(EventBusUtils.closeActivityFloating);

                pausePlay();
                Gets.Get.to(
                        CommunityDetailPage()
                            .buildPage({"videoId": widget.videoModel.id,"randomTag": widget.randomTag, "randomLinearGradient":widget.linearGradient}),
                        opaque: false)
                    .then((value) {
                  startPlay();

                  bus.emit(EventBusUtils.showActivityFloating);
                });
              },
              child: Container(
                alignment: Alignment.centerLeft,
                child: WordRichText(
                  videoModel: widget.videoModel,
                  isBloggerPage: widget.isBloggerPage,
                  isPost:true,
                  randomTag:widget.randomTag,
                  linearGradient:widget.linearGradient,
                  randomCallBack: (text,linearGradient){
                      widget.randomTag = text;
                      widget.linearGradient = linearGradient;

                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Stack(
               children: [
                 Container(
                   alignment: Alignment.centerLeft,
                   height: widget.videoModel.newsType == "SP" ||
                       widget.videoModel.newsType == "MOVIE"
                       ? (isHorizontalVideoUI ? 223.w : 354.w)
                       : (widget.videoModel.seriesCover?.length ?? 0) <= 2
                       ? 196.w
                       : widget.videoModel.seriesCover.length == 3
                       ? 130.w
                       : widget.videoModel.seriesCover.length == 4
                       ? 400.w
                       : 264.w,
                   child: widget.videoModel.newsType == "SP" ||
                       widget.videoModel.newsType == "MOVIE"
                       ?
                   (widget.autoPlayStyle??false)?VisibilityDetector(
                         key: Key(widget.videoModel.id.toString()),
                         onVisibilityChanged: (visibilityInfo) {
                           if (widget.videoModel.newsType == "SP" || widget.videoModel.newsType == "MOVIE") {
                             if (controller != null) {
                               if (visibilityInfo.visibleFraction == 1) {
                                 // PostVideoLogic.play(widget.index);
                                 widget.showVideoCover = false;
                                 setState(() {
                                 });
                                  widget.visibleCallBack?.call(widget.index);
                                  // startPlay();
                               } else {
                                 // pausePlay();
                                 // PostVideoLogic.pauseAll();
                                 widget.hideCallBack?.call(widget.index);
                               }
                             }
                           }
                         },
                         child: GestureDetector(
                           onTap: () {
                             if (widget.videoModel.newsType == "SP") {
                               List<VideoModel> lists = [];

                               lists = recommendListModel.videoLists;

                               lists.insert(0, widget.videoModel);

                               Map<String, dynamic> maps = Map();
                               maps['pageNumber'] = 1;
                               maps['pageSize'] = 3;
                               maps['currentPosition'] = 0;
                               maps['videoList'] = lists;
                               maps['tagID'] =
                               widget.videoModel.tags.length == 0
                                   ? null
                                   : widget.videoModel.tags[0].id;
                               maps['playType'] =
                                   VideoPlayConfig.VIDEO_POST;

                               bus.emit(
                                   EventBusUtils.closeActivityFloating);

                               Gets.Get.to(
                                   SubPlayListPage().buildPage(maps),
                                   opaque: false)
                                   .then((value) {
                                     startPlay();
                                 bus.emit(
                                     EventBusUtils.showActivityFloating);
                               });
                               return;
                             }
                             Map<String, dynamic> maps = Map();
                             maps["videoId"] = widget.videoModel.id;

                             bus.emit(
                                 EventBusUtils.closeActivityFloating);

                             maps["videoModel"] = widget.videoModel;

                             Gets.Get.to(
                                     () => FilmTvVideoDetailPage()
                                     .buildPage(maps),
                                 opaque: false)
                                 .then((value) {
                               startPlay();
                               bus.emit(EventBusUtils.showActivityFloating);
                             });
                           },
                           child:

                           // (controller!=null && aspectRatio!=null)?SizedBox(
                           //   width: videoResolution.videoWidth,
                           //   height: videoResolution.videoHeight,
                           //   child: CustomNetworkImage(
                           //     width: videoResolution.videoWidth,
                           //     height: videoResolution.videoHeight,
                           //     type: ImgType.avatar,
                           //     imageUrl: widget.videoModel?.cover,
                           //     fit: BoxFit.cover,
                           //   ),):
                           SizedBox(
                               width: videoResolution.videoWidth,
                               height: videoResolution.videoHeight,
                               child:  Stack(
                                 children: [
                                   _buildVideoItem(),
                                   Positioned(
                                     child: GestureDetector(
                                       child: (Config.autoPlayVoiceClose??true)?Image.asset("assets/images/video_voice_close.png",width: 25,height: 20):Image.asset("assets/images/video_voice_open.png",width: 25,height: 20,),
                                       onTap: (){
                                         if(Config.autoPlayVoiceClose??false){
                                           Config.autoPlayVoiceClose = false;
                                           controller.setVolume(1.0);
                                         }else{
                                           Config.autoPlayVoiceClose = true;
                                           controller.setVolume(0);
                                         }
                                         setState(() {

                                         });
                                       },
                                     ),right: 11,bottom: 8,),
                                   ( isPlaying??false)?Positioned(
                                     child: Container(
                                       decoration: BoxDecoration(
                                         gradient: LinearGradient(
                                           colors: [
                                             Color.fromRGBO(19, 29, 49, 1),
                                             Color.fromRGBO(19, 29, 49, 0),
                                           ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                         )
                                       ),
                                     ),right: 0,bottom: 0,left: 0,):SizedBox(

                                   ),
                                 ],
                               )
                           ),
                         )
                       ):
                       GestureDetector(
                       onTap: () {
                         List<VideoModel> lists = [];

                         lists = recommendListModel.videoLists;

                         lists.insert(0, widget.videoModel);

                         Map<String, dynamic> maps = Map();
                         maps['pageNumber'] = 1;
                         maps['pageSize'] = 3;
                         maps['currentPosition'] = 0;
                         maps['videoList'] = lists;
                         maps['tagID'] = widget.videoModel.tags.length == 0
                             ? null
                             : widget.videoModel.tags[0].id;
                         maps['playType'] = VideoPlayConfig.VIDEO_POST;

                         bus.emit(EventBusUtils.closeActivityFloating);

                         Gets.Get.to(SubPlayListPage().buildPage(maps),
                             opaque: false)
                             .then((value) {
                           bus.emit(EventBusUtils.showActivityFloating);
                         });
                       },

                       ///视频UI
                       child: Container(
                           width: isHorizontalVideoUI ? 1.sw : 266.w,
                           height: isHorizontalVideoUI ? 223.w : 354.w,
                           child: ClipRRect(
                             borderRadius: BorderRadius.all(Radius.circular(4)),
                             child: Stack(
                               alignment: AlignmentDirectional.centerStart,
                               children: [
                                 GestureDetector(
                                   onTap: () {
                                     if (widget.videoModel.newsType == "SP") {
                                       List<VideoModel> lists = [];

                                       lists = recommendListModel.videoLists;

                                       lists.insert(0, widget.videoModel);

                                       Map<String, dynamic> maps = Map();
                                       maps['pageNumber'] = 1;
                                       maps['pageSize'] = 3;
                                       maps['currentPosition'] = 0;
                                       maps['videoList'] = lists;
                                       maps['tagID'] =
                                       widget.videoModel.tags.length == 0
                                           ? null
                                           : widget.videoModel.tags[0].id;
                                       maps['playType'] =
                                           VideoPlayConfig.VIDEO_POST;

                                       bus.emit(
                                           EventBusUtils.closeActivityFloating);

                                       Gets.Get.to(
                                           SubPlayListPage().buildPage(maps),
                                           opaque: false)
                                           .then((value) {
                                         bus.emit(
                                             EventBusUtils.showActivityFloating);
                                       });
                                       return;
                                     }
                                     Map<String, dynamic> maps = Map();
                                     maps["videoId"] = widget.videoModel.id;

                                     bus.emit(
                                         EventBusUtils.closeActivityFloating);

                                     maps["videoModel"] = widget.videoModel;

                                     Gets.Get.to(
                                             () => FilmTvVideoDetailPage()
                                             .buildPage(maps),
                                         opaque: false)
                                         .then((value) {
                                       bus.emit(
                                           EventBusUtils.showActivityFloating);
                                     });
                                   },
                                   child: CustomNetworkImage(
                                     fit: BoxFit.cover,
                                     height: isHorizontalVideoUI ? 223.w : 354.w,
                                     imageUrl: widget.videoModel.cover,
                                     type: isHorizontalVideoUI
                                         ? ImgType.cover
                                         : ImgType.vertical,

                                     // isHorizontalVideoUI //loading_vertical
                                     // "assets/weibo/loading_vertical.png",
                                   ),
                                 ),
                                 GestureDetector(
                                   onTap: () {
                                     if (widget.videoModel.newsType == "SP") {
                                       List<VideoModel> lists = [];

                                       lists.add(widget.videoModel);

                                       Map<String, dynamic> maps = Map();
                                       maps['pageNumber'] = 1;
                                       maps['pageSize'] = 3;
                                       maps['currentPosition'] = 0;
                                       maps['videoList'] = lists;
                                       maps['tagID'] =
                                       widget.videoModel.tags?.isNotEmpty == true
                                           ? widget.videoModel.tags[0].id
                                           : null;
                                       maps['playType'] =
                                           VideoPlayConfig.VIDEO_POST;

                                       bus.emit(
                                           EventBusUtils.closeActivityFloating);

                                       Gets.Get.to(
                                           SubPlayListPage().buildPage(maps),
                                           opaque: false)
                                           .then((value) {
                                         bus.emit(
                                             EventBusUtils.showActivityFloating);
                                       });
                                       return;
                                     }

                                     Map<String, dynamic> maps = Map();
                                     maps["videoId"] = widget.videoModel.id;

                                     bus.emit(
                                         EventBusUtils.closeActivityFloating);

                                     maps["videoModel"] = widget.videoModel;

                                     Gets.Get.to(
                                             () => FilmTvVideoDetailPage()
                                             .buildPage(maps),
                                         opaque: false)
                                         .then((value) {
                                       bus.emit(
                                           EventBusUtils.showActivityFloating);
                                     });
                                   },
                                   child: Align(
                                     alignment: Alignment.center,
                                     child: Image.asset(
                                       "assets/images/play_icon.png",
                                       width: 53.w,
                                       height: 66.w,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           )),
                       )
                       : GridView.builder(
                     physics: NeverScrollableScrollPhysics(),
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount:
                         (widget.videoModel.seriesCover?.length ?? 0) <= 2 ||
                             widget.videoModel.seriesCover?.length == 4
                             ? 2
                             : 3,
                         crossAxisSpacing: 6,
                         mainAxisSpacing: 6,
                         childAspectRatio:
                         (widget.videoModel.seriesCover?.length ?? 0) <= 2 ||
                             widget.videoModel.seriesCover?.length == 4
                             ? 193 / 193
                             : 128 / 128),
                     itemCount: (widget.videoModel.seriesCover?.length ?? 0) > 6
                         ? 6
                         : widget.videoModel.seriesCover?.length ?? 0,
                     itemBuilder: (BuildContext context, int indexs) {
                       return ClipRRect(
                         borderRadius: BorderRadius.only(
                             topRight: Radius.circular(4),
                             topLeft: Radius.circular(4),
                             bottomLeft: Radius.circular(4),
                             bottomRight: Radius.circular(4)),
                         child: GestureDetector(
                           onTap: () async{
                             if(indexs == 5){
                               if(widget.videoModel.isCoinVideo()){
                                 if(needBuyVideo(widget.videoModel)){
                                   var result = await showDialog(
                                       context: context,
                                       builder: (context) {
                                         return CoinPostAlert(
                                             videoModel: widget.videoModel);
                                       });
                                   ///true表示支付成功
                                   if (result != null && result is bool &&
                                       result) {
                                     widget.videoModel?.vidStatus?.hasPaid = true;
                                     Config.videoId.add(widget.videoModel.id);
                                     showToast(msg: "购买成功!");
                                     await GlobalStore.updateUserInfo(null);
                                     setState(() {});
                                   }
                                   return;
                                 }
                               }else {
                                 if(!GlobalStore.isVIP()){
                                   VipRankAlert.show(context,
                                       type: VipAlertType.vipPostImg);
                                   return;
                                 }
                               }
                             }
                             showPictureSwipe(context,
                                 widget.videoModel.seriesCover, indexs,
                                 imageTyp: ImageTyp.NET,
                                 videoModel: widget.videoModel);
                           },
                           child: Stack(
                             alignment: AlignmentDirectional.center,
                             children: [
                               CustomNetworkImage(
                                 fit: BoxFit.cover,
                                 height:
                                 widget.videoModel.seriesCover.length <=
                                     2 ||
                                     widget.videoModel.seriesCover
                                         .length ==
                                         4
                                     ? 193.w
                                     : 128.w,
                                 width: widget.videoModel.seriesCover.length <=
                                     2 ||
                                     widget.videoModel.seriesCover
                                         .length ==
                                         4
                                     ? 193.w
                                     : 128.w,
                                 imageUrl:
                                 widget.videoModel.seriesCover[indexs],
                                 isGauss: isGaussValue(indexs , 5),
                               ),
                               if(indexs == 5 &&
                                   widget.videoModel.seriesCover.length > 6)
                                 Container(
                                   alignment: Alignment.center,
                                   child: Container(
                                     width: 128.w,
                                     height: 128.w,
                                     alignment: Alignment.center,
                                     color: Colors.black.withOpacity(0.3),
                                     child: Text(
                                       "+" +
                                           (widget.videoModel.seriesCover
                                               .length -
                                               6)
                                               .toString(),
                                       style: TextStyle(
                                           fontSize: 20.nsp,
                                           color: Colors.white),
                                     ),
                                   ),
                                 ),
                             ],
                           ),
                         ),
                       );
                     },
                   ),
                 ),
               ],
            ),
            SizedBox(
              height: 10.w,
            ),
            _bottomWidget(),
          ],
        ),
      ),
    );
  }

  Widget _bottomWidget(){
   return widget.isHideBottom ?? false
        ? Container()
        : GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.transparent,
        width: 1.sw,
        height: 34.w,
        child: Row(
          children: [
             Row(
                children: [
                  Image.asset("assets/images/hj_ucenter_icon_view.png",width: 20,height: 20,),
                  SizedBox(width: 6,),
                  Text(
                    "${getShowCountStr(widget.videoModel?.playCount ?? 0)}",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14.w),
                  ),
                ],
              ),
              // child: Container(
              //     child: GestureDetector(
              //       child: Container(
              //         width: 120,
              //         height: 28,
              //         decoration: BoxDecoration(
              //           color: Color.fromRGBO(255, 255, 255, 0.1),
              //           borderRadius: BorderRadius.all(Radius.circular(14)),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Image.asset("assets/weibo/ic_comment_small.png",width: 15,height: 15,),
              //             SizedBox(width: 3,),
              //             Text("我来评论下",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),)
              //           ],
              //         ),
              //       ),
              //     ),
              // ),
            // GestureDetector(
            //   child: Container(
            //     width: 120,
            //     height: 28,
            //     decoration: BoxDecoration(
            //       color: Color.fromRGBO(255, 255, 255, 0.1),
            //       borderRadius: BorderRadius.all(Radius.circular(14)),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Image.asset("assets/weibo/ic_comment_small.png",width: 15,height: 15,),
            //         SizedBox(width: 3,),
            //         Text("我来评论下",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),)
            //       ],
            //     ),
            //   ),
            //   onTap: (){
            //     Gets.Get.to(
            //             () => CommunityDetailPage().buildPage({"videoId": widget.videoModel.id,"needToBottom":true,"randomTag": widget.randomTag, "randomLinearGradient":widget.linearGradient}),
            //         opaque: false).then((value) =>   startPlay());
            //   },
            // ),
            // GestureDetector(
            //   onTap: () async {
            //     showShareVideoDialog(context, () async {
            //       await Future.delayed(
            //           Duration(milliseconds: 500));
            //     },
            //         videoModel: widget.videoModel,
            //         isLongVideo: isHorizontalVideo(
            //             resolutionWidth(
            //                 widget.videoModel.resolution),
            //             resolutionHeight(
            //                 widget.videoModel.resolution)));
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(right: 18),
            //     color: Colors.transparent,
            //     key: key,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Image.asset(
            //           "assets/weibo/images/ic_make_money.png",
            //           width: 20.w,
            //           height: 20.w,
            //         ),
            //         SizedBox(
            //           width: 6.w,
            //         ),
            //         Text(
            //           "赚钱",
            //           style: TextStyle(
            //               color: Colors.white.withOpacity(0.6),
            //               fontSize: 14.nsp),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(width: 22,),
            LikeButton(
              size: 18,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              likeCountPadding: EdgeInsets.only(left: 6.w),
              isLiked:
              widget.videoModel?.vidStatus?.hasCollected ??
                  false,
              circleColor: CircleColor(
                  start: Color.fromRGBO(245, 75, 100, 1),
                  end: Color.fromRGBO(245, 75, 100, 1)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color.fromRGBO(245, 75, 100, 1),
                dotSecondaryColor: Color.fromRGBO(245, 75, 100, 1),
              ),
              likeBuilder: (bool isLiked) {
                return Image.asset(
                  isLiked ? "assets/weibo/video_liked.png" : "assets/weibo/video_like_border.png",
                  width: 20.w,
                  height: 20.w,
                );
              },
              likeCount: widget.videoModel?.forwardCount ?? 0,
              likeCountAnimationType: LikeCountAnimationType.none,
              countBuilder:
                  (int count, bool isLiked, String text) {
                var color = isLiked
                    ? Color.fromRGBO(245, 75, 100, 1)
                    : Colors.white.withOpacity(0.6);
                Widget result;
                if (count == 0) {
                  result = Text(
                    "点赞",
                    style:
                    TextStyle(color: color, fontSize: 14.nsp),
                  );
                } else
                  result = Text(
                    getShowFansCountStr(int.parse(text)),
                    style:
                    TextStyle(color: color, fontSize: 14.nsp),
                  );
                return result;
              },
              onTap: (isLiked) async {
                String type = 'video'; //img
                if (widget.videoModel.newsType == "SP") {
                  type = 'video';
                } else if (widget.videoModel.newsType ==
                    "COVER") {
                  type = 'img';
                }
                String objID = widget.videoModel.id;
                bool isCollect =
                !widget.videoModel.vidStatus.hasCollected;
                try {
                  await netManager.client
                      .changeTagStatus(objID, isCollect, type);
                  if (!widget
                      .videoModel.vidStatus.hasCollected) {}

                  if (!isCollect) {
                    widget.videoModel.forwardCount -= 1;
                  } else {
                    widget.videoModel.forwardCount += 1;
                  }

                  setState(() {});

                  widget.videoModel.vidStatus.hasCollected =
                      isCollect;
                  setState(() {});
                } catch (e) {
                  l.d('changeTagStatus', e.toString());
                  //showToast(msg: e.toString());
                }
                return !isLiked;
              },
            ),
            SizedBox(width: 22,),
            GestureDetector(
              onTap: () {
                if (widget.videoModel.status != 1) {
                  //0 未审核 1通过 2审核失败 3视为免费 默认为0
                  showToast(
                      msg: Lang.GLOBAL_TIP_TXT2,
                      gravity: ToastGravity.CENTER);
                  return;
                }
                // showCommentDialog(
                //   context: context,
                //   id: widget.videoModel.id,
                //   index: 1,
                //   height: screen.screenHeight * 0.65,
                //   province: widget.videoModel.location.province,
                //   city: widget.videoModel.location.city,
                //   visitNum: widget.videoModel.location.visit
                //       .toString(),
                //   callback: (Map<String, dynamic> map) {},
                // );
                Gets.Get.to(
                        () => CommunityDetailPage().buildPage({"videoId": widget.videoModel.id,"needToBottom":true,"randomTag": widget.randomTag, "randomLinearGradient":widget.linearGradient}),
                    opaque: false).then((value) => startPlay());
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/weibo/icon_hjll_comment.png",
                      width: 20.w,
                      height: 20.w,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      widget.videoModel.commentCount == 0
                          ? "评论"
                          : getShowFansCountStr(
                          widget.videoModel?.commentCount ??
                              0),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.nsp),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            (widget.videoModel.tags!=null && widget.videoModel.tags.length>0)?
            Text(
              "#${widget.videoModel.tags[0].name??""}",style: TextStyle(color: Color.fromRGBO(0, 214, 190, 1),fontSize: 12),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }
}
