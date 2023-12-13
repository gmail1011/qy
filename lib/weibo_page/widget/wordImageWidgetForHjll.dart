import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/page/alert/coin_post_alert.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/anwang_trade/widget/post_detail_coin_dialog.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_quanzi_detail/HjllCommunityQuanziDetailPage.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/post_video_logic.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
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
import 'package:path/path.dart' as path;

class WordImageWidgetForHjll extends StatefulWidget {
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
  final bool showPostTimeText;
  final bool showLeftLine;
  final bool showTopInfo;
  final bool isHaiJiaoLL;
  final bool isHaiJiaoLLDetail;
  final bool isMyPublish;
  final bool isMyCollect;
  final int maxImageCount;
  final Color tagColor;
  final Color bgColor;
  final EdgeInsetsGeometry padding;
  String randomTag;
  LinearGradient linearGradient;

  Function(int) visibleCallBack;
  Function(int) hideCallBack;
  final bool isEdit;
  final Function(VideoModel) deleteCallback; // 点击删除回调
  WordImageWidgetForHjll({
    Key key,
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
    this.showPostTimeText = false,
    this.showLeftLine = false,
    this.showTopInfo = true,
    this.isHaiJiaoLL = true,
    this.isMyPublish = false,
    this.isMyCollect = false,
    this.maxImageCount = 3,
    this.isHaiJiaoLLDetail = false,
    this.tagColor,
    this.padding,
    this.bgColor,
    this.isEdit = false,
    this.deleteCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WordImageWidgetForHjllState();
  }
}

class WordImageWidgetForHjllState extends State<WordImageWidgetForHjll> {
  String videoUrl;

  String videoError = "";

  GlobalKey key = GlobalKey();

  RecommendListModel recommendListModel = RecommendListModel();

  bool isHorizontalVideoUI = false;

  double aspectRatio;

  Map<String, ImageInfo> imageInfoMap = Map();
  double picWidth = 343;
  double picHeight = 238;

  ///是否横向视频
  @override
  void initState() {
    super.initState();
    key = key;

    ///初始化获取视频横竖屏
    if (widget.videoModel.newsType == "SP") {
      isHorizontalVideoUI =
          isHorizontalVideo(resolutionWidth(widget.videoModel.resolution), resolutionHeight(widget.videoModel.resolution));
    } else if (widget.videoModel.newsType == "MOVIE") {
      isHorizontalVideoUI = true;
    }
    //帖子详情，视频全部横版展示
    if (widget.isHaiJiaoLLDetail) {
      isHorizontalVideoUI = true;
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

  bool isGaussValue(index, limitCount) {
    if (index < limitCount) {
      return false;
    }
    if (widget.videoModel.isCoinVideo() == true) {
      if (needBuyVideo(widget.videoModel)) {
        return true;
      }
    } else {
      if (!GlobalStore.isVIP()) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    _imageCache.clear();
    clearAllCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = (screen.screenWidth - 20 * 2 - 13 * 2) / 3;
    var height = width;
    var width1 = (screen.screenWidth - 30 * 2 - 13 * 2) / 3;
    var height1 = (screen.screenWidth - 30 * 2 - 13 * 2) / 3;
    if (widget.videoModel.isRandomAd()) {
      return SizedBox();
    }

    VideoResolution videoResolution;

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
        : widget.videoModel?.newsType != NEWSTYPE_AD_IMG
            ? _buildRecommandVideoUI(videoResolution, width, height, width1, height1)
            : _buildRecommandAdUI();
  }

  ///创建推荐广告
  Widget _buildRecommandAdUI() {
    return Container(
      color: AppColors.weiboJianPrimaryBackground,
      margin: EdgeInsets.only(bottom: 15.w),
      padding: EdgeInsets.only(left: 16.w, top: 11.w, right: 16.w, bottom: 10.w),
      child: GestureDetector(
        onTap: () {
          if (TextUtil.isNotEmpty(widget.videoModel?.linkUrl)) {
            JRouter().handleAdsInfo(widget.videoModel?.linkUrl);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomNetworkImageNew(
            width: 1.sw,
            height: 223.w,
            imageUrl: widget.videoModel?.cover,
            fit: BoxFit.cover,
            useQueue: true,
          ),
        ),
      ),
    );
  }

  ///创建视频列表
  Widget _buildRecommandVideoUI(VideoResolution videoResolution, double width, double height, double width1, double height1) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.w),
      child: Stack(
        children: [
          Container(
            color: widget.bgColor ?? Color.fromRGBO(36, 36, 36, 1),
            padding: widget.padding ?? EdgeInsets.only(top: 12.w),
            child:  GestureDetector(
                onTap: widget.isDetail == true
                    ? null
                    : () {
                  if (widget.videoModel.status == 2) {
                    showReasonDialog();
                  } else {
                    bus.emit(EventBusUtils.closeActivityFloating);
                    Gets.Get.to(
                        CommunityDetailPage().buildPage({
                          "videoId": widget.videoModel.id,
                          "randomTag": widget.randomTag,
                          "randomLinearGradient": widget.linearGradient
                        }),
                        opaque: false)
                        .then((value) {
                      bus.emit(EventBusUtils.showActivityFloating);
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.showPostTimeText
                        ? Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "发布时间：${formatTimeTwo(widget.videoModel.reviewAt)}",
                        style: TextStyle(color: Color.fromRGBO(192, 193, 209, 1), fontSize: 12),
                      ),
                    )
                        : SizedBox(),
                    (widget.showLeftLine ?? false)
                        ? Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: _mainContent(videoResolution, width, height, width1, height1),
                        ),
                        Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              width: 2,
                              color: AppColors.primaryTextColor,
                            ))
                      ],
                    )
                        : _mainContent(videoResolution, width, height, width1, height1)
                  ],
                )),
          ),
          if(widget.isEdit)
            Positioned.fill(child: _buildEidtWidget()),
        ],
      ),
    );
  }

  Widget _mainContent(VideoResolution videoResolution, double width, double height, double width1, double height1) {
    //因为之前逻辑已经处理，视频类帖子时，默认去掉第一个封面图片。（时间情况，图片列表可能不包含封面）
    //为了快捷处理，当视频帖子，图片列表没有封面时，把封面加上
    if ((widget.videoModel.newsType == "SP" || widget.videoModel.newsType == "MOVIE")) {
      if (!widget.videoModel.seriesCover.contains(widget.videoModel.cover)) {
        widget.videoModel.seriesCover.insert(0, widget.videoModel.cover);
      }
    }
    return Container(
      padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hideTopUserInfo == false)
            Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        bus.emit(EventBusUtils.closeActivityFloating);

                        Map<String, dynamic> arguments = {
                          'uid': widget.videoModel.publisher.uid,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };

                        Gets.Get.to(() => BloggerPage(arguments), opaque: false).then((value) {});
                      },
                      child: HeaderWidget(
                        headPath: widget.videoModel.publisher?.portrait ?? "",
                        level: (widget.videoModel.publisher?.superUser ?? false) ? 1 : 0,
                        headWidth: 52.w,
                        headHeight: 52.w,
                        levelSize: 17.w,
                        positionedSize: 0,
                        isCertified: widget.videoModel?.publisher?.merchantUser == 1,
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

                        bus.emit(EventBusUtils.closeActivityFloating);

                        Gets.Get.to(() => BloggerPage(arguments), opaque: false).then((value) {
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
                                color: Colors.white,
                                fontSize: 16.nsp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          // TextUtils.isEmt(ic_uptag)
                          (widget.videoModel.publisher.upTag == null || widget.videoModel.publisher.upTag == "")
                              ? SizedBox()
                              : Image.asset("assets/weibo/ic_uptag.png", width: 12, height: 12),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6.w,
                    ),
                    GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ((widget.videoModel.publisher?.isVip ?? false) && (TextUtil.isNotEmpty(widget.videoModel.publisher.vipName)))
                                ? Container(
                                    padding: EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                                    margin: EdgeInsets.only(right: 6),
                                    child: Text(
                                      "${widget.videoModel.publisher.vipName ?? ""}",
                                      style: TextStyle(color: Color.fromRGBO(102, 56, 0, 1), fontSize: 8),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                        gradient:
                                            LinearGradient(colors: [Color.fromRGBO(238, 217, 180, 1), Color.fromRGBO(174, 138, 95, 1)])),
                                  )
                                : Container(),
                            Text(
                              formatTimeTwo(widget.videoModel.reviewAt),
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12.nsp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                if (widget.isMyPublish != true)
                  GestureDetector(
                    onTap: () async {
                      // 自己不能关注自己
                      if (GlobalStore.isMe(widget.videoModel.publisher.uid)) {
                        showToast(msg: Lang.GLOBAL_TIP_TXT1);
                        return;
                      }
                      bool isFollow = !(widget.videoModel.publisher.hasFollowed ?? false);

                      widget.videoModel.publisher.hasFollowed = isFollow;

                      int followUID = widget.videoModel.publisher.uid;
                      try {
                        await netManager.client.getFollow(followUID, isFollow);
                        setState(() {});
                      } catch (e) {
                        //l.d('getFollow', e.toString());
                        showToast(msg: Lang.FOLLOW_ERROR, gravity: ToastGravity.CENTER);
                      }
                    },
                    child: Visibility(
                      visible: true,
                      child: (widget.videoModel.publisher?.hasFollowed ?? false)
                          ? // Rectangle 2784
                          Container(
                              width: 64,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(32)),
                                border: Border.all(color: Color(0xff999999)),
                              ),
                              child: Center(
                                child: Text(
                                  "已关注",
                                  style: TextStyle(color: Color(0xff999999), fontSize: 12),
                                ),
                              ),
                            )
                          : Container(
                              width: 63,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryTextColor),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "+",
                                    style: TextStyle(color: AppColors.primaryTextColor, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    "关注",
                                    style: TextStyle(color: AppColors.primaryTextColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          if (widget.isMyPublish == true)
            Container(
              padding: EdgeInsets.only(top: 4, bottom: 2),
              child: Text(
                "发布时间: ${formatTimeTwo(widget.videoModel.createdAt)}",
                style: TextStyle(
                  color: Color(0xffc0c1d0),
                  fontSize: 12,
                ),
              ),
            ),
          SizedBox(height: 16.w),
          GestureDetector(
            onTap: () {
              if (widget.videoModel.status == 2) {
                showReasonDialog();
              } else {
                bus.emit(EventBusUtils.closeActivityFloating);
                Gets.Get.to(
                        CommunityDetailPage().buildPage({
                          "videoId": widget.videoModel.id,
                          "randomTag": widget.randomTag,
                          "randomLinearGradient": widget.linearGradient
                        }),
                        opaque: false)
                    .then((value) {
                  bus.emit(EventBusUtils.showActivityFloating);
                });
              }
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: WordRichText(
                textStyle: (widget.isHaiJiaoLLDetail ?? false)
                    ? TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 16,
                      )
                    : TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 16.nsp,
                      ),
                videoModel: widget.videoModel,
                isBloggerPage: widget.isBloggerPage,
                isPost: true,
                randomTag: widget.randomTag,
                linearGradient: widget.linearGradient,
                randomCallBack: (text, linearGradient) {
                  widget.randomTag = text;
                  widget.linearGradient = linearGradient;
                },
              ),
            ),
          ),
          SizedBox(height: 15),
          if (widget.showTopInfo == true)
            Row(
              children: [
                Text(
                  "${widget.videoModel.playCountDescThree}",
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
                Expanded(child: SizedBox()),
                Text(
                  "发布时间：${formatTimeTwo(widget.videoModel.reviewAt)}",
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                )
              ],
            ),
          (widget.showTopInfo) ? SizedBox(height: 15) : SizedBox(),
          ((widget.videoModel.content?.isNotEmpty == true) && (widget.isHaiJiaoLLDetail ?? false))
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 1, color: Color.fromRGBO(255, 255, 255, 0.2)),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "${widget.videoModel.content}",
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : SizedBox(),
          (widget.isHaiJiaoLLDetail)
              ? _detailContent()
              : Container(
                  alignment: Alignment.centerLeft,
                  height: (widget.showLeftLine ?? false) ? height1 : height,
                  constraints: BoxConstraints(minHeight: (widget.showLeftLine ?? false) ? height1 : height),
                  child: (widget.videoModel.newsType == "SP" || widget.videoModel.newsType == "MOVIE")
                      ? GestureDetector(
                          child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (widget.videoModel.seriesCover == null || widget.videoModel.seriesCover?.length == 0)
                                ? Container(
                                    height: height,
                                    width: width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      child: Stack(
                                        alignment: AlignmentDirectional.centerStart,
                                        fit: StackFit.expand,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Map<String, dynamic> maps = Map();
                                              maps["videoId"] = widget.videoModel.id;

                                              bus.emit(EventBusUtils.closeActivityFloating);

                                              Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false).then((value) {
                                                bus.emit(EventBusUtils.showActivityFloating);
                                              });
                                            },
                                            child: CustomNetworkImageNew(
                                              fit: BoxFit.cover,
                                              height: height,
                                              width: width,
                                              imageUrl: widget.videoModel.cover,
                                              useQueue: true,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              "assets/images/hjll_community_play_icon.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                : Expanded(
                                    child: GridView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 13,
                                      mainAxisSpacing: 1,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: widget.videoModel.seriesCover.length > 3 ? 3 : widget.videoModel.seriesCover.length,
                                    itemBuilder: (BuildContext context, int indexs) {
                                      int realDataIndex = indexs + 1;
                                      if (realDataIndex == 3 || realDataIndex == widget.videoModel.seriesCover.length) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                          child: Stack(
                                            alignment: AlignmentDirectional.centerStart,
                                            fit: StackFit.expand,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Map<String, dynamic> maps = Map();
                                                  maps["videoId"] = widget.videoModel.id;

                                                  bus.emit(EventBusUtils.closeActivityFloating);

                                                  Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false).then((value) {
                                                    bus.emit(EventBusUtils.showActivityFloating);
                                                  });
                                                },
                                                child: CustomNetworkImageNew(
                                                  imageUrl: getImagePath(widget.videoModel.cover, true, false),
                                                  fit: BoxFit.cover,
                                                  useQueue: true,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  "assets/images/hjll_community_play_icon.png",
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          alignment: AlignmentDirectional.center,
                                          children: [
                                            CustomNetworkImageNew(
                                              width: width,
                                              height: height,
                                              imageUrl: getImagePath(widget.videoModel.seriesCover[realDataIndex], true, false),
                                              fit: BoxFit.cover,
                                              useQueue: true,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ))
                          ],
                        ))
                      : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 13,
                            mainAxisSpacing: 1,
                            childAspectRatio: 1,
                          ),
                          itemCount: (widget.videoModel.seriesCover?.length ?? 0) > widget.maxImageCount
                              ? widget.maxImageCount
                              : widget.videoModel.seriesCover?.length ?? 0,
                          itemBuilder: (BuildContext context, int indexs) {
                            return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4)),
                              child: GestureDetector(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CustomNetworkImageNew(
                                      fit: BoxFit.cover,
                                      height: (widget.showLeftLine ?? false) ? height1 : height,
                                      width: (widget.showLeftLine ?? false) ? width1 : width,
                                      imageUrl: widget.videoModel.seriesCover[indexs],
                                      isGauss: isGaussValue(indexs, widget.maxImageCount),
                                      useQueue: true,
                                    ),
                                    if (indexs == (widget.maxImageCount - 1) && widget.videoModel.seriesCover.length > widget.maxImageCount)
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        padding: EdgeInsets.fromLTRB(0, 0, 6, 6),
                                        margin: EdgeInsets.only(bottom: 4),
                                        child: Container(
                                          width: 30,
                                          //(widget.showLeftLine ?? false) ? width1 : width,
                                          height: 17,
                                          //(widget.showLeftLine ?? false) ? height1 : height,
                                          alignment: Alignment.center,
                                          color: Colors.black.withOpacity(0.6),
                                          child: Text(
                                            "+" + (widget.videoModel.seriesCover.length - widget.maxImageCount).toString(),
                                            style: TextStyle(fontSize: 12, color: Color(0xfff1f1f1)),
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
          SizedBox(height: 10),
          _bottomWidget(),
          if (widget.isMyPublish == true) ...[
            ///帖子状态
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.videoModel.statusDesc,
                    style: TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  if (widget.videoModel.status == 2)
                    TextSpan(
                      text: "  ${widget.videoModel.reason}",
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Text(
              "${formatTimeTwo(widget.videoModel.reviewAt)}",
              style: TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
          ]
        ],
      ),
    );
  }

  Widget _detailContent() {
    double videoCoverWidth = (isHorizontalVideoUI ? (screen.screenWidth - 11 * 2) : 266.w);
    double videoCoverHeight = (isHorizontalVideoUI ? ((screen.screenWidth - 11 * 2) * (232 / 407)) : 354.w);
    return (widget.videoModel.newsType == "SP" || widget.videoModel.newsType == "MOVIE")
        ? Column(
            children: [
              (widget.videoModel.seriesCover == null ||
                      widget.videoModel.seriesCover.length == 0 ||
                      widget.videoModel.seriesCover.length == 1)
                  ? SizedBox()
                  : Container(
                      // constraints: BoxConstraints(minHeight: 200.0),
                      child: ListView.builder(
                        itemCount: widget.videoModel.seriesCover.length - 1,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int childIndex) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: path.join(Address.baseImagePath ?? '', widget.videoModel.seriesCover[childIndex + 1]),
                                      fit: BoxFit.cover,
                                      cacheManager: ImageCacheManager(),
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        color: Color(0xff151515),
                                        child: Image.asset(
                                          "assets/weibo/loading_normal.png",
                                          width: 106,
                                          height: 92,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 3),
                width: videoCoverWidth,
                height: videoCoverHeight,
                child: GestureDetector(
                  onTap: () {
                    if ((widget.videoModel.videoCoin() > 0) && (!widget.videoModel.vidStatus.hasPaid)) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return PostDetailCoinDialog(
                              videoCoin: widget.videoModel.videoCoin(),
                              leftCallback: () async {
                                bool buySuccess =
                                    await buyProduct(context, widget.videoModel?.id, widget.videoModel?.title, widget.videoModel?.coins);
                                if (buySuccess) {
                                  Map<String, dynamic> maps = Map();
                                  maps["videoId"] = widget.videoModel.id;
                                  bus.emit(EventBusUtils.closeActivityFloating);
                                  Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false).then((value) {
                                    safePopPage();
                                    widget.videoModel.vidStatus.hasPaid = true;
                                    setState(() {});
                                  });
                                } else {
                                  showToast(msg: "购买视频失败！");
                                }
                              },
                            );
                          });
                      return;
                    }
                    Map<String, dynamic> maps = Map();
                    maps["videoId"] = widget.videoModel.id;
                    bus.emit(EventBusUtils.closeActivityFloating);
                    Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false).then((value) {
                      bus.emit(EventBusUtils.showActivityFloating);
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        CustomNetworkImage(
                          fit: BoxFit.cover,
                          width: videoCoverWidth,
                          height: videoCoverHeight,
                          imageUrl: widget.videoModel.cover,
                          type: isHorizontalVideoUI ? ImgType.cover : ImgType.vertical,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/hjll_community_play_icon.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        if ((widget.videoModel.videoCoin() > 0))
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.primaryTextColor,
                              ),
                              child: Text(
                                widget.videoModel.vidStatus.hasPaid == true ? "已解锁" : "${widget.videoModel.videoCoin()}金币解锁",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.videoModel.videoCoin() > 0)
                Container(
                  padding: EdgeInsets.only(top: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${widget.videoModel.videoCoin()}金币解锁",
                    style: TextStyle(color: AppColors.primaryTextColor, fontSize: 16),
                  ),
                ),
            ],
          )
        : Column(
            children: [
              (widget.videoModel.seriesCover == null || widget.videoModel.seriesCover.length == 0)
                  ? SizedBox()
                  : Container(
                      child: ListView.builder(
                        itemCount: widget.videoModel.seriesCover.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int childIndex) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        color: Color(0xff151515),
                                        child: Image.asset(
                                          "assets/weibo/loading_normal.png",
                                          width: 106,
                                          height: 92,
                                        ),
                                      ),
                                      imageUrl: path.join(Address.baseImagePath ?? '', widget.videoModel.seriesCover[childIndex]),
                                      fit: BoxFit.cover,
                                      cacheManager: ImageCacheManager(),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
            ],
          );
  }

  Widget _bottomWidget() {
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
                      Image.asset(
                        "assets/images/hj_ucenter_icon_view.png",
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "${getShowCountStr(widget.videoModel?.playCount ?? 0)}",
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14.w),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.videoModel.status != 1) {
                        if (widget.videoModel.status == 2) {
                          showReasonDialog();
                        } else {
                          //0 未审核 1通过 2审核失败 3视为免费 默认为0
                          showToast(msg: Lang.GLOBAL_TIP_TXT2, gravity: ToastGravity.CENTER);
                        }
                        return;
                      }
                      Gets.Get.to(
                              () => CommunityDetailPage().buildPage({
                                    "videoId": widget.videoModel.id,
                                    "needToBottom": false,
                                    "randomTag": widget.randomTag,
                                    "randomLinearGradient": widget.linearGradient
                                  }),
                              opaque: false)
                          .then((value) => {});
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/weibo/icon_hjll_comment.png",
                            width: 22.w,
                            height: 22.w,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            widget.videoModel.commentCount == 0 ? "评论" : getShowFansCountStr(widget.videoModel?.commentCount ?? 0),
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14.nsp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 22,
                  ),
                  LikeButton(
                    size: 18,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    likeCountPadding: EdgeInsets.only(left: 6.w),
                    isLiked: widget.videoModel?.vidStatus?.hasLiked ?? false,
                    circleColor: CircleColor(start: Color.fromRGBO(245, 75, 100, 1), end: Color.fromRGBO(245, 75, 100, 1)),
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
                    likeCount: widget.videoModel?.likeCount ?? 0,
                    likeCountAnimationType: LikeCountAnimationType.none,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color =  Colors.white.withOpacity(0.6);
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "点赞",
                          style: TextStyle(color: color, fontSize: 14.nsp),
                        );
                      } else
                        result = Text(
                          getShowFansCountStr(int.parse(text)),
                          style: TextStyle(color: color, fontSize: 14.nsp),
                        );
                      return result;
                    },
                    onTap: (isLiked) async {
                      String type = 'image'; //img
                      // if (widget.videoModel.newsType == "SP") {
                      //   type = 'video';
                      // } else if (widget.videoModel.newsType ==
                      //     "COVER") {
                      //   type = 'img';
                      // }
                      String objID = widget.videoModel.id;
                      bool isLike = !(widget.videoModel.vidStatus.hasLiked ?? false);
                      try {
                        if (!isLike) {
                          await netManager.client.cancelLike(objID, type);
                        } else {
                          await netManager.client.sendLike(objID, type);
                        }

                        if (!isLike) {
                          widget.videoModel.likeCount -= 1;
                        } else {
                          widget.videoModel.likeCount += 1;
                        }

                        widget.videoModel.vidStatus.hasLiked = isLike;
                        setState(() {});
                      } catch (e) {
                        l.d('changeTagStatus', e.toString());
                        //showToast(msg: e.toString());
                      }
                      return !isLiked;
                    },
                  ),
                  Expanded(child: SizedBox()),
                 if(widget.videoModel.tags != null && widget.videoModel.tags.length > 0)
                       GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return HjllCommunityQuanziDetailPage(
                                videoTagId: widget.videoModel.tags[0].id,
                                videoTagName: widget.videoModel.tags[0].name,
                              );
                            }));
                          },
                          child: Container(
                            color: Colors.transparent,
                            constraints: BoxConstraints(minWidth: 60.0),
                            alignment: Alignment.center,
                            child: Text(
                              "#${widget.videoModel.tags[0].name ?? ""}",
                              style: TextStyle(color: widget.tagColor ?? AppColors.primaryTextColor, fontSize: 12),
                            ),
                          ),),
                ],
              ),
            ),
          );
  }

  void showReasonDialog() {
    showDialog(
      context: FlutterBase.appContext,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: IntrinsicHeight(
            child: Container(
              width: 357,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: const Color(0xff161e2c)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "未通过原因",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "${widget.videoModel.reason}",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () => safePopPage(),
                    child: Container(
                      width: 166,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), gradient: AppColors.linearBackGround),
                      child: Center(
                        child: // 确定
                            Text(
                          "确定",
                          style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEidtWidget() {
    return InkWell(
      onTap: (){
        widget.deleteCallback?.call(widget.videoModel);
      },
      child: Container(
        decoration: BoxDecoration(
          color:  Color(0x99707070),
        ),
        alignment: Alignment.center,
        child:  Image.asset(
          "assets/images/delete_icon.png",
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
