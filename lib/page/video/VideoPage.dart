import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/page/wallet/wallet_main/page.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/chewie/material_controls.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/newdialog/vip_dailog.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  VideoModel viewModel;

  VideoPage(this.viewModel) : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage> {
  String videoUrl;

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  bool liked = false;

  List<AdsInfoBean> adsList = [];

  List<VideoModel> works = [];

  int pageNum = 1;
  int pageSize = 10;

  bool alreadyShowDialog = false;

  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
    getRecommend();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (videoPlayerController != null) {
      videoPlayerController.dispose();
    }

    if (chewieController != null) {
      chewieController.dispose();
    }


    //bus.off(EventBusUtils.updatePlaying);
    // bus.off(EventBusUtils.fanGroupBuy);
    super.dispose();
  }

  initData() async {
    if (Config.followVideos.containsKey(widget.viewModel.id)) {
      widget.viewModel.publisher.hasFollowed =
      Config.followVideos[widget.viewModel.id];
    }

    if (Config.likeVideos.containsKey(widget.viewModel.id)) {
      liked = Config.likeVideos[widget.viewModel.id];
    } else {
      liked = widget.viewModel.vidStatus.hasLiked;
    }

    if (Config.videoId.contains(widget.viewModel.id)) {
      widget.viewModel.vidStatus.hasPaid = true;
    }

    //adsList = await getAdsByType(AdsType.msgType);

    videoUrl = CacheServer().getLocalUrl(widget.viewModel.sourceURL);

    videoPlayerController = VideoPlayerController.network(videoUrl);

    await videoPlayerController.initialize();

    if (isHorizontalVideo(resolutionWidth(widget.viewModel.resolution),
        resolutionHeight(widget.viewModel.resolution))) {
    } else {}

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      //autoPlay: true,
      aspectRatio: isHorizontalVideo(
          resolutionWidth(widget.viewModel.resolution),
          resolutionHeight(widget.viewModel.resolution))
          ? 16 / 9
          : resolutionWidth(widget.viewModel.resolution) /
          resolutionHeight(widget.viewModel.resolution),
      looping: true,
      customControls: MaterialControls(),
      /*placeholder: Container(
        width: screen.screenWidth,
        height: screen.screenWidth / 1.8,
        color: Colors.black,
        child: Lottie.asset(
          "assets/images/video_player_loading.json",
          width: Dimens.pt6,
          height: Dimens.pt6,
        ),
      ),*/
    );

    videoPlayerController.addListener(() async {
      if (chewieController.isFullScreen) {
        if (videoPlayerController.value.position.inSeconds <
            widget.viewModel.freeTime) {
        } else {
          dynamic needBuyVipBool = await needBuyVip(widget.viewModel);

          dynamic needBuyVideoBool = await needBuyVideo(widget.viewModel);

          if (needBuyVipBool || needBuyVideoBool) {
            chewieController.exitFullScreen();

            checkOrPlay();
          }
        }
      }

      //检查免费时间,是否需要弹出购买视频
      if (videoPlayerController.value.position.inSeconds >=
          widget.viewModel.freeTime &&
          needBuyVideo(widget.viewModel) &&
          !Config.videoId.contains(widget.viewModel.id)) {
        if (chewieController.isPlaying) {
          // show buy video
          //  买了之后怎么通知
          chewieController.pause();

          ///购买视频
          var result = await showBuyVideo(context, widget.viewModel);

          ///true表示支付成功
          if (result != null && result is bool && result) {
            alreadyShowDialog = false;
            Config.videoId.add(widget.viewModel.id);
            widget.viewModel.vidStatus.hasPaid = true;
            setState(() {});
            checkOrPlay();
          }
        }
      }

      if (videoPlayerController.value.position.inSeconds >=
          widget.viewModel.freeTime &&
          needBuyVip(widget.viewModel) &&
          !Config.videoId.contains(widget.viewModel.id)) {
        if (chewieController.isPlaying) {
          // show buy video
          //  买了之后怎么通知
          chewieController.pause();

          videoPlayerController.pause();
          // 买了之后怎么通知
          l.i("_tag", "_checkOrPlay()...need buy vip");

          ///点击的必须弹出
          onShowVipDialog();
        }
      }
    });

    chewieController.play();

    checkOrPlay();

    if (!await needBuyVip(widget.viewModel) &&
        !needBuyVideo(widget.viewModel)) {
      recordPlayCount(widget.viewModel, context);
    }

    sendRecord(
        chewieController.videoPlayerController.value.position,
        chewieController.videoPlayerController.value.duration,
        widget.viewModel);

    //_updateRechgStates(true);

    if (mounted) {
      setState(() {

      });
    }
  }

  getRecommend() async {
    MineVideo worksTemp;
    worksTemp = await netManager.client.getMineWorks(
      pageSize,
      pageNum,
      "",
      "SP",
      widget.viewModel.publisher.uid,
    );
    if (worksTemp.list.length > 0) {
      works.addAll(worksTemp.list);
      refreshController.loadComplete();
      if (mounted) {
        setState(() {});
      }
    } else if (worksTemp.list.length == 0) {
      refreshController.loadNoData();
    }
  }

  int freeDay() {
    var startDate = GlobalStore.getMe().vipExpireDate;
    var endDate = new DateTime.now();
    var days = DateTime.parse(startDate).difference(endDate).inDays;

    return days;
  }

  /// 秒数转换为 格式：1970-01-01
  String sec2DateFmt(int sec) {
    var date = DateTime.fromMillisecondsSinceEpoch(sec * 1000);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget buildVideoDynamicInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.pt0, Dimens.pt16, Dimens.pt0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ///单个视频的打赏功能
          getRewardWidget(),
          getCommentWidget(),
          getLikeWidget(),
          getShareWidget(),
        ],
      ),
    );
  }

  /// 打赏
  Widget getRewardWidget() {
    return GestureDetector(
      onTap: () async {
        await showRewardDialog(context, widget.viewModel.id);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Container(
              width: Dimens.pt16,
              height: Dimens.pt14,
              child: SvgPicture.asset(
                "assets/svg/icon_reward_red.svg",
                color: Colors.white,
              ),
            ),
            SizedBox(width: Dimens.pt8),
            Text("打赏", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// 评论
  Widget getCommentWidget() {
    return GestureDetector(
      onTap: () {
        if (widget.viewModel.status != 1 && widget.viewModel.status != 3) {
          ///审核未通过，不弹出提示框
          showToast(msg: Lang.GLOBAL_TIP_TXT2, gravity: ToastGravity.CENTER);
          return;
        }

        showCommentDialog(
          context: context,
          id: widget.viewModel.id,
          index: 0,
          province: widget.viewModel?.location?.province ?? "",
          city: widget.viewModel?.location?.city ?? "",
          visitNum: "${widget.viewModel?.location?.visit ?? 0}",
          callback: (Map<String, dynamic> map) {
            widget.viewModel.commentCount = widget.viewModel.commentCount + 1;

            setState(() {});
          },
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Container(
              width: Dimens.pt16,
              height: Dimens.pt14,
              child: SvgPicture.asset(
                "assets/svg/icon_comment_red.svg",
                color: Colors.white,
              ),
            ),
            SizedBox(width : Dimens.pt8),
            // Text(numCoverStr(), style: t.t12white),
            Text(numCoverStr(widget.viewModel.commentCount),
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// 点赞
  Widget getLikeWidget() {
    return GestureDetector(
      onTap: () {
        //bool hasLiked = !widget.viewModel.vidStatus.hasLiked;
        // var req = {
        //   "objID": ctx.state.videoModel.id,
        //   "type": "video",
        // };
        String objID = widget.viewModel.id;
        String type = 'video';
        if (!liked) {
          widget.viewModel.vidStatus.hasLiked = true;
          widget.viewModel.likeCount++;
              () async {
            try {
              await netManager.client.sendLike(objID, type);

              liked = true;

              Config.likeVideos[widget.viewModel.id] = true;

              widget.viewModel.vidStatus.hasLiked = true;

              setState(() {});

              setState(() {});
            } catch (e) {
              l.e("_tag", "sendLike()...error:$e");
            }
          }();
        } else {
          widget.viewModel.vidStatus.hasLiked = false;
          widget.viewModel.likeCount--;
              () async {
            try {
              await netManager.client.cancelLike(objID, type);

              liked = false;

              Config.likeVideos[widget.viewModel.id] = false;

              widget.viewModel.vidStatus.hasLiked = false;

              setState(() {});
            } catch (e) {
              l.e("_tag", "cancelLike()...error:$e");
            }
          }();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Container(
              width: Dimens.pt16,
              height: Dimens.pt14,
              child: SvgPicture.asset(
                liked
                    ? "assets/svg/icon_like_red.svg"
                    : "assets/svg/icon_unlike_red.svg",
              ),
            ),
            SizedBox(width: Dimens.pt8),
            // Text(numCoverStr(widget.data.likeNum), style: t.t12white),

            Text(
              widget.viewModel.likeCount == 0
                  ? Lang.LIKE
                  : getShowCountStr(widget.viewModel.likeCount),
              style: TextStyle(
                fontSize: Dimens.pt12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 分享
  Widget getShareWidget() {
    return GestureDetector(
      onTap: () {
        showShareVideoDialog(context, () async {
          await Future.delayed(Duration(milliseconds: 500));
        }, videoModel: widget.viewModel);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            /// 分享
            Container(
              width: Dimens.pt16,
              height: Dimens.pt14,
              child: SvgPicture.asset(
                "assets/svg/icon_share_red.svg",
                color: Colors.white,
              ),
            ),
            SizedBox(width : Dimens.pt8),
            // Text(numCoverStr(widget.data.shareNum), style: t.t12white)
            Text('赚会员', style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  String getWatchTimes(int watchTimes) {
    if (watchTimes > 10000) {
      return (watchTimes / 10000).toStringAsFixed(1) + "w";
    } else {
      return watchTimes.toString();
    }
  }

  onShowVipDialog() async {
    videoPlayerController.pause();

    var result = await dialogManager.addDialogToQueue(() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return VipDialog();
          });
    }, uniqueId: "VipDialog");

    if (result != null && result is bool && result) {
      ///充值VIP
      Config.videoModel = widget.viewModel;
      Config.payFromType = PayFormType.video;
    } else if (result != null && !result) {
      showShareVideoDialog(context, () {});
    }
  }

  // 自动检查有条件可以播放
  checkOrPlay({bool isClick = false}) async {
    if (videoPlayerController.value.position.inSeconds <
        widget.viewModel.freeTime) {
      chewieController.play();
      return true;
    }

    var buyVip = await needBuyVip(widget.viewModel);

    if (buyVip) {
      videoPlayerController.pause();
      // 买了之后怎么通知
      l.i("_tag", "_checkOrPlay()...need buy vip");

      if (isClick) {
        ///点击的必须弹出
        onShowVipDialog();
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
          onShowVipDialog();
          chewieController.pause();
        }
      }
    } else if (needBuyVideo(widget.viewModel)) {
      if (Config.videoId.indexOf(widget.viewModel.id) != -1) {
        return false;
      }

      videoPlayerController.pause();

      l.i("_tag", "_checkOrPlay()...need buy video");
      try {
        // await chewieController.seekTo(Duration(seconds: 0));

        alreadyShowDialog = true;

        ///购买视频
        var result = await showBuyVideo(context, widget.viewModel);

        ///true表示支付成功
        if (result != null && result is bool && result) {
          widget.viewModel.vidStatus.hasPaid = true;
          alreadyShowDialog = false;
          if (widget.viewModel.isVideo()) {
            // 支付成功���制播放
            // autoPlayModel.startAvailblePlayer();
            checkOrPlay();
          }

          Config.videoId.add(widget.viewModel.id);
        }

        setState(() {});
      } catch (e) {
        l.e("_tag", "_checkOrPlay()...error:$e");
      }
    } else {
      l.i("_tag", "_checkOrPlay()...may begin play");
      chewieController.play();
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoPlayerController == null || chewieController == null) {
      // If there was no controller, just create a new one
      initData();
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldVideoPlayerController = videoPlayerController;
      final oldChewiePlayerController = chewieController;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldVideoPlayerController.dispose();
        await oldChewiePlayerController.dispose();

        // Initing new controller
        initData();
      });

      // Making sure that controller is not used by setting it to null

      setState(() {
        videoPlayerController = null;
        chewieController = null;
      });
    }
  }

  Widget videoFloatTitle1() {
    if (!GlobalStore.isVIP()) {
      if (widget.viewModel.coins == 0) {
        return GestureDetector(
          onTap: () async {
            if (MediaQuery.of(context).size.width >
                MediaQuery.of(context).size.height * 1.2) {
              SystemChrome.setEnabledSystemUIOverlays(
                  [SystemUiOverlay.bottom, SystemUiOverlay.top]);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              //autoPlayModel.exitFullScreen();
            }

            await Navigator.of(FlutterBase.appContext)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return WalletPage().buildPage(null);
            }));
            GlobalStore.updateUserInfo(null);
          },
          child: Container(
            alignment: Alignment.center,
            constraints:
            BoxConstraints(maxHeight: Dimens.pt44, maxWidth: Dimens.pt120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.black.withOpacity(0.50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "非vip可试看${widget.viewModel.freeTime}秒",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "充值VIP",
                      style: TextStyle(
                        color: Color.fromRGBO(249, 19, 19, 1),
                        fontSize: Dimens.pt12,
                      ),
                    ),
                    Text(
                      "无限看",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        if (!widget.viewModel.vidStatus.hasPaid) {
          return Container(
            alignment: Alignment.center,
            constraints:
            BoxConstraints(maxHeight: Dimens.pt44, maxWidth: Dimens.pt120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.black.withOpacity(0.50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "视频可试看${widget.viewModel.freeTime}秒",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "购买",
                      style: TextStyle(
                        color: Color.fromRGBO(249, 19, 19, 1),
                        fontSize: Dimens.pt12,
                      ),
                    ),
                    Text(
                      "即可永久观看",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      }
    } else {
      if (widget.viewModel.coins != 0 && !widget.viewModel.vidStatus.hasPaid) {
        return Container(
          alignment: Alignment.center,
          constraints:
          BoxConstraints(maxHeight: Dimens.pt44, maxWidth: Dimens.pt120),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.black.withOpacity(0.50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "视频可试看${widget.viewModel.freeTime}秒",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt12,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "购买",
                    style: TextStyle(
                      color: Color.fromRGBO(249, 19, 19, 1),
                      fontSize: Dimens.pt12,
                    ),
                  ),
                  Text(
                    "即可永久观看",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.pt12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    }

    return Container();
  }

  Widget buildVideoStaticInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.pt16, Dimens.pt8, Dimens.pt16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  width: Dimens.pt320,
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.viewModel.title,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: Dimens.pt16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              // _buildSwitchLineView(state, dispatch, viewService.context),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, Dimens.pt4, 0, 0),
            child: Text(
              widget.viewModel.playCount > 10000
                  ? (widget.viewModel.playCount / 10000)
                  .toStringAsFixed(1)
                  .toString() +
                  "w次观看"
                  : widget.viewModel.playCount.toString() + "次观看",
              //  +
              //     '.' +
              //     showDateDesc(DateTime.parse(state.mediaInfo.releaseAt)),
              maxLines: 1,
              style: TextStyle(
                  fontSize: Dimens.pt12,
                  color: Color.fromRGBO(118, 117, 119, 1),
                  fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: Dimens.pt5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widget.viewModel.tags
                  .sublist(
                  0,
                  widget.viewModel.tags.length > 4
                      ? 4
                      : widget.viewModel.tags.length)
                  .map((e) {
                return GestureDetector(
                    onTap: () {
                      //Navigator.of(viewService.context).pushNamed(page_tagPage, arguments: {'tag': e});
                      Map<String, dynamic> maps = new Map();
                      maps["keyWord"] = e;

                      /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return TagsNewPage().buildPage(maps);
                        },
                      )).then((value) {});*/
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        right: Dimens.pt6,
                        left: Dimens.pt6,
                        top: Dimens.pt2,
                        bottom: Dimens.pt2,
                      ),
                      decoration: BoxDecoration(
                        color:
                        Color.fromRGBO(168, 167, 169, 1).withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      margin: EdgeInsets.only(right: Dimens.pt8),
                      /*child: commonTag(
                        e,
                        color: Color.fromRGBO(118, 117, 119, 1),
                      ),*/

                      child: Text(
                        e.name,
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt12),
                      ),
                    ));
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, Dimens.pt8, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Map<String, dynamic> arguments = {
                          'uid': widget.viewModel.publisher.uid,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };

                        Gets.Get.to(VideoUserCenterPage().buildPage(arguments),
                            );
                      },
                      child: ClipOval(
                        child: CustomNetworkImage(
                          imageUrl: widget.viewModel.publisher.portrait,
                          type: ImgType.avatar,
                          height: Dimens.pt30,
                          width: Dimens.pt30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(Dimens.pt7, 0, 0, 0),
                      child: Container(
                        // width: Dimens.pt220,
                        child: Text(
                          widget.viewModel.publisher.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Dimens.pt14,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Visibility(
                  visible: !widget.viewModel.publisher.hasFollowed,
                  child: GestureDetector(
                    onTap: () async {
                      await netManager.client.getFollow(
                          widget.viewModel.publisher.uid,
                          !widget.viewModel.publisher.hasFollowed);

                      Config.followVideos[widget.viewModel.id] = true;

                      widget.viewModel.publisher.hasFollowed = true;

                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                          Color.fromRGBO(201, 115, 255, 1),
                          Color.fromRGBO(246, 168, 255, 1),
                        ]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: Dimens.pt60,
                      height: Dimens.pt26,
                      alignment: Alignment.center,
                      child: Text(
                        "关注",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.viewModel.publisher.hasFollowed,
                  child: GestureDetector(
                    onTap: () async {
                      await netManager.client.getFollow(
                          widget.viewModel.publisher.uid,
                          widget.viewModel.publisher.hasFollowed);

                      Config.followVideos[widget.viewModel.id] = false;

                      widget.viewModel.publisher.hasFollowed = false;

                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: Dimens.pt70,
                      height: Dimens.pt26,
                      alignment: Alignment.center,
                      child: Text(
                        "已关注",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimens.pt16,
                ),
              ],
            ),
          ),
          //用户头像和昵称等
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Material(
      color: Colors.black,
      child: Column(
        children: [
          chewieController == null || videoPlayerController == null
              ? Container(
              width: screen.screenWidth,
              height: screen.screenWidth / 1.8,
              color: Colors.black,
              child: Lottie.asset(
                "assets/images/video_player_loading.json",
                width: Dimens.pt6,
                height: Dimens.pt6,
              ))
              : ClipRRect(
            child: Stack(children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (chewieController.isPlaying) {
                    chewieController.pause();
                  } else {
                    //chewieController.play();
                    checkOrPlay();
                  }
                },
                child: Container(
                    width: screen.screenWidth,
                    height: screen.screenWidth / 1.8,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: Chewie(
                      controller: chewieController,
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Dimens.pt10, left: Dimens.pt10),
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(
                      top: Dimens.pt10, right: Dimens.pt10),
                  constraints: BoxConstraints(maxWidth: Dimens.pt130),
                  child: videoFloatTitle1(),
                ),
              ),
            ]),
          ),
          Expanded(
            child: pullYsRefresh(
              refreshController: refreshController,
              enablePullDown: false,
              onLoading: () {
                pageNum = pageNum + 1;
                getRecommend();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: buildVideoStaticInfo()),
                  // SliverToBoxAdapter(child: getTalkHotTop(0),),
                  SliverToBoxAdapter(child: Container(height: 100,width:100,color: Colors.red,),),
                  SliverToBoxAdapter(child: buildVideoDynamicInfo()),
                  SliverToBoxAdapter(
                    child: Container(
                      margin:
                      EdgeInsets.fromLTRB(0, Dimens.pt14, 0, Dimens.pt10),
                      //height: 0.8,
                      width: Dimens.pt360,
                      //color: Color(0xffffffff).withOpacity(0.1),
                      child: Image.asset("assets/images/line_video.png"),
                    ),
                  ),
                  SliverOffstage(
                    offstage:
                    adsList == null || adsList.length == 0 ? true : false,
                    sliver: SliverPadding(
                      padding: EdgeInsets.only(
                          left: Dimens.pt16,
                          right: Dimens.pt16,
                          top: Dimens.pt10),
                      sliver: SliverToBoxAdapter(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: AdsBannerWidget(
                            adsList,
                            width: Dimens.pt360,
                            //height: Dimens.pt250,
                            height: Dimens.pt154,
                            onItemClick: (index) {
                              var ad = adsList[index];

                              JRouter().handleAdsInfo(ad.href, id: ad.id);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: Dimens.pt10,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.pt16, vertical: 0),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        child: Text(
                          "为你推荐",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: Dimens.pt10,
                    ),
                  ),
                  works.length == 0
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  )
                      : SliverPadding(
                    padding: EdgeInsets.only(
                        left: Dimens.pt10, right: Dimens.pt10),
                    sliver: SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 4,
                      itemCount: works.length,
                      staggeredTileBuilder: (int index) =>
                      new StaggeredTile.fit(2),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (isHorizontalVideo(
                                resolutionWidth(works[index].resolution),
                                resolutionHeight(
                                    works[index].resolution))) {
                              widget.viewModel = works[index];
                              _startVideoPlayer();
                            } else {
                              Map<String, dynamic> maps = Map();
                              maps['pageNumber'] = 1;
                              maps['pageSize'] = 3;
                              maps['currentPosition'] = index;
                              maps['videoList'] = works;
                              maps['tagID'] = works[index].tags[0].id;
                              maps['playType'] =
                                  VideoPlayConfig.VIDEO_TAG;

                              Gets.Get.to(
                                  SubPlayListPage().buildPage(maps),
                                  );
                            }
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Stack(
                                  alignment:
                                  AlignmentDirectional.bottomCenter,
                                  children: [
                                    KeepAliveWidget(
                                      /*ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: Dimens.pt240,maxWidth: Dimens.pt560,),
                                      child: CachedNetworkImage(
                                        imageUrl: state.selectedTagsData
                                            .xList[index].cover,
                                        fit: BoxFit.cover,
                                        memCacheHeight: 600,
                                        fadeInCurve: Curves.linear,
                                        fadeOutCurve: Curves.linear,
                                        fadeInDuration: Duration(milliseconds: 100),
                                        fadeOutDuration: Duration(milliseconds: 100),
                                        cacheManager: ImageCacheManager(),
                                        */ /*placeholder: (context, url) {
                                          return placeHolder(ImgType.cover,
                                              null, Dimens.pt280);
                                        },*/ /*
                                      ),
                                    ),*/
                                      CachedNetworkImage(
                                        imageUrl: works[index].cover,
                                        fit: BoxFit.cover,
                                        // memCacheHeight: 600,
                                        fadeInCurve: Curves.linear,
                                        fadeOutCurve: Curves.linear,
                                        fadeInDuration:
                                        Duration(milliseconds: 100),
                                        fadeOutDuration:
                                        Duration(milliseconds: 100),
                                        cacheManager: ImageCacheManager(),
                                      ),
                                    ),
                                    Container(
                                      height: Dimens.pt24,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.black54,
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: Dimens.pt4,
                                            right: Dimens.pt4,
                                            bottom: Dimens.pt4),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/images/play_icon.png",
                                                    width: Dimens.pt11,
                                                    height: Dimens.pt11),
                                                SizedBox(
                                                  width: Dimens.pt4,
                                                ),
                                                Text(
                                                  works[index].playCount >
                                                      10000
                                                      ? (works[index].playCount /
                                                      10000)
                                                      .toStringAsFixed(
                                                      1) +
                                                      "w"
                                                      : works[index]
                                                      .playCount
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Dimens.pt12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              TimeHelper.getTimeText(
                                                  works[index]
                                                      .playTime
                                                      .toDouble()),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimens.pt12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: -1,
                                        right: -1,
                                        child: Visibility(
                                          visible: works[index]
                                              .originCoins !=
                                              null &&
                                              works[index]
                                                  .originCoins !=
                                                  0
                                              ? true
                                              : false,
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  //height: Dimens.pt20,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                        bottomLeft: Radius
                                                            .circular(
                                                            4)),
                                                    gradient:
                                                    LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            245,
                                                            22,
                                                            78,
                                                            1),
                                                        Color.fromRGBO(
                                                            255,
                                                            101,
                                                            56,
                                                            1),
                                                        Color.fromRGBO(
                                                            245,
                                                            68,
                                                            4,
                                                            1),
                                                      ],
                                                      begin: Alignment
                                                          .centerLeft,
                                                      end: Alignment
                                                          .centerRight,
                                                    ),
                                                  ),
                                                  padding:
                                                  EdgeInsets.only(
                                                    left: Dimens.pt4,
                                                    right: Dimens.pt7,
                                                    top: Dimens.pt2,
                                                    bottom: Dimens.pt2,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      ImageLoader.withP(
                                                          ImageType
                                                              .IMAGE_SVG,
                                                          address:
                                                          AssetsSvg
                                                              .IC_GOLD,
                                                          width: Dimens
                                                              .pt12,
                                                          height: Dimens
                                                              .pt12)
                                                          .load(),
                                                      SizedBox(
                                                          width:
                                                          Dimens.pt4),
                                                      Text(
                                                          works[index]
                                                              .originCoins
                                                              .toString(),
                                                          style:
                                                          TextStyle(
                                                            color: AppColors
                                                                .textColorWhite,
                                                            fontSize:
                                                            Dimens
                                                                .pt12,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        )),
                                    Positioned(
                                        top: -1,
                                        right: -1,
                                        child: Visibility(
                                          visible:
                                          works[index].originCoins ==
                                              0
                                              ? true
                                              : false,
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  //height: Dimens.pt20,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                        bottomLeft: Radius
                                                            .circular(
                                                            4)),
                                                    gradient:
                                                    LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            245,
                                                            22,
                                                            78,
                                                            1),
                                                        Color.fromRGBO(
                                                            255,
                                                            101,
                                                            56,
                                                            1),
                                                        Color.fromRGBO(
                                                            245,
                                                            68,
                                                            4,
                                                            1),
                                                      ],
                                                      begin: Alignment
                                                          .centerLeft,
                                                      end: Alignment
                                                          .centerRight,
                                                    ),
                                                  ),
                                                  padding:
                                                  EdgeInsets.only(
                                                    left: Dimens.pt10,
                                                    right: Dimens.pt10,
                                                    top: Dimens.pt2,
                                                    bottom: Dimens.pt2,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        "VIP",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimens.pt3,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    works[index].title,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  )),
                              SizedBox(
                                height: Dimens.pt4,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: CustomNetworkImage(
                                          imageUrl: works[index]
                                              .publisher
                                              .portrait,
                                          type: ImgType.cover,
                                          height: Dimens.pt18,
                                          width: Dimens.pt18,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimens.pt4,
                                      ),
                                      Container(
                                        width: Dimens.pt66,
                                        child: Text(
                                          works[index].publisher.name,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimens.pt10,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        works[index].likeCount > 10000
                                            ? (works[index].likeCount /
                                            10000)
                                            .toStringAsFixed(1) +
                                            "w"
                                            : works[index]
                                            .likeCount
                                            .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt10,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimens.pt4,
                                      ),
                                      SvgPicture.asset(
                                          "assets/svg/heart.svg"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget  getTalkHotTop(int topType){
    return Container(
      color: Colors.red,
      width: 397,
      height: 40,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
          topType==0?AssetImage("assets/images/hot_top_talk_bg.png"):
          topType==1?AssetImage("assets/images/hot_top_event_bg.png"):
          topType==2?AssetImage("assets/images/hot_top_month_bg.png"):
          topType==3?AssetImage("assets/images/hot_top_black_horse_bg.png"):
          AssetImage("assets/images/hot_top_week_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Text("全球争辩榜",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
    );
  }
}
