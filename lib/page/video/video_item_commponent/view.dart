import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart'
    hide ImgType;
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/common/provider/fiction_update_model.dart';
import 'package:flutter_app/common/provider/lou_feng_update_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/page/video/video_item_commponent/com.dart';
import 'package:flutter_app/page/video/video_item_commponent/countdown_widget.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_list_model/main_player_ui_show_model.dart';
import 'package:flutter_app/page/video/video_list_model/second_player_ui_show_model.dart';
import 'package:flutter_app/page/video/widget/left_item.dart';
import 'package:flutter_app/page/video/widget/right_item.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_app/widget/tab_indicator.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/player/double_like/tiktok_video_gesture.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:provider/provider.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    VideoItemState state, Dispatch dispatch, ViewService viewService) {
  Widget getRightItem() {
    /// 是否能评论
    return RightItem(
      state.index,
      state.videoModel,
      onAvatar: () {
        dispatch(VideoItemActionCreator.onUser());
      },
      onComment: () {
        dispatch(VideoItemActionCreator.onClickComment());
      },
      onLove: () async {
        ///修改为收藏
        String type = 'video'; //img
        if (state.videoModel.newsType == "SP") {
          type = 'video';
        } else if (state.videoModel.newsType == "COVER") {
          type = 'img';
        }
        String objID = state.videoModel.id;
        bool isCollect = !state.videoModel.vidStatus.hasCollected;
        try {
          await netManager.client.changeTagStatus(objID, isCollect, type);
          state.videoModel?.vidStatus?.hasCollected = isCollect;
          dispatch(
              VideoItemActionCreator.shareSuccess(state.videoModel.shareCount));
          dispatch(VideoItemActionCreator.refreshUI(state.uniqueId));
        } catch (e) {
          showToast(msg: e.toString());
        }
      },
      onShare: () {
        ///修改为-单独分享
        showShareVideoDialog(viewService.context, () async {
          await Future.delayed(Duration(milliseconds: 500));
        },
            videoModel: state.videoModel,
            isLongVideo: isHorizontalVideo(
                    resolutionWidth(state.videoModel.resolution),
                    resolutionHeight(state.videoModel.resolution))
                ? true
                : false);
      },
      onFollow: () {
        if (state.videoModel.publisher.uid == GlobalStore.getMe().uid) {
          showToast(msg: "自己不能关注自己");
          return;
        }

        dispatch(VideoItemActionCreator.onFollow({
          'uid': state.videoModel.publisher.uid,
          'isFollow': true,
          'uniqueId': state.uniqueId
        }));
      },
      showDownload: state.videoModel.newsType == "SP",
      onDownload: () {
        dispatch(VideoItemActionCreator.cacheVideo());
      },
    );
  }

  bool isGaussValue(index, limitCount, VideoModel videoModel) {
    if (index < limitCount) {
      return false;
    }
    if (videoModel.isCoinVideo() == true) {
      if (needBuyVideo(videoModel)) {
        return true;
      }
    } else {
      if (!GlobalStore.isVIP()) {
        return true;
      }
    }
    return false;
  }

  List<Widget> getPicWidgetList() {
    List<Widget> widgetList = [];
    List<String> coverList = state.videoModel.seriesCover;
    for (int i = 0; i < coverList.length; i++) {
      widgetList.add(CustomNetworkImage(
        fit: BoxFit.fitWidth,
        width: screen.screenWidth,
        height: screen.screenHeight,
        placeholder: Container(
          color: AppColors.videoBackgroundColor,
        ),
        isGauss: isGaussValue(i, 5, state.videoModel),
        fullImg: true,
        imageUrl: coverList[i],
      ));
    }

    return widgetList;
  }

  Widget bannerWidget() {
    return state.tabController == null
        ? Stack()
        : Stack(
            children: <Widget>[
              NotificationListener(
                onNotification: (ScrollNotification notification) {
                  switch (notification.runtimeType) {
                    case ScrollUpdateNotification:
                      double resOffset = notification.metrics.pixels -
                          state.tabController.index * screen.screenWidth;
                      if (resOffset >= 0) {
                        //向右边滑动
                        double progress = resOffset / screen.screenWidth;
                        if (progress > 0.5) {
                          state.tabController.index =
                              state.tabController.index + 1;
                        }
                      } else {
                        //向左边滑动
                        double progress = resOffset.abs() / screen.screenWidth;
                        if (progress > 0.5) {
                          state.tabController.index =
                              state.tabController.index - 1;
                        }
                      }
                      break;
                  }
                  return true;
                },
                child: ExtendedTabBarView(
                  linkWithAncestor: true,
                  physics: ScrollPhysics(),
                  controller: state.tabController,
                  children: getPicWidgetList(),
                ),
              ),
              Positioned(
                bottom: Dimens.pt10,
                left: Dimens.pt180 -
                    ((Dimens.pt10 * state.videoModel.seriesCover.length + 10) /
                        2),
                child: TabIndicator(
                  itemCount: state.videoModel.seriesCover.length,
                  selectIndex: 0,
                  tabController: state.tabController,
                ),
              ),
            ],
          );
  }

  //双击点赞处理

  Widget _getChildVideoItem() {
    // var resolution = configVideoSize(null, null, state.videoModel.resolution);
    if (state.videoModel.isVideo()) {
      // if (!state.enablePlay.value) {
      //   return Container();
      // } else
      if (state.videoModel.status == 5) {
        // 视频过期了
        return Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Colors.transparent,
          child: Center(
            child: Text(
              Lang.VIDEO_REMOVED_TIP,
              style: TextStyle(fontSize: Dimens.pt14, color: Colors.white70),
            ),
          ),
        );
      } else {
        return SinglePlayer(
          state.videoModel.sourceURL,
          state.uniqueId,
          singleController: state.enablePlay,
          srcModel: state.videoModel,
          loop: true,
          // 播放器回调更新
          updateCallBack: (c) =>
              dispatch(VideoItemActionCreator.onVideoUpdate(c)),
          // onPrepared: (c) =>
          //     dispatch(VideoItemActionCreator.onVideoInited(c)),
          // 播放器生命周期初始化
          onInited: (c) => dispatch(VideoItemActionCreator.onVideoInited(c)),
          onRelease: (c) {
            ///首页的话不发送播放记录
            if (GlobalStore.isVIP() && c.currentPos.inSeconds >= 15) {
              EventTrackingManager()
                  .addVideoDatas(state.videoModel.id, state.videoModel.title);
            }
            sendRecord(c.currentPos, c.value.duration, state.videoModel);
            // widget.controller?.removeListener(_playListener);
            CacheServer().cancelM3u8("/${state.videoModel.sourceURL}");
            state.isDone = false;
          },
          onCreateController: (c) {
            autoPlayModel.setCurPlayCtrl(c);
          },
          realUrl: "${Address.baseApiPath}/vid/h5/m3u8/${state.videoModel.sourceURL}?token=${Address.token}&c=${Address.cdnAddress}",
          playerBuilder: (c) => VPlayer(
              controller: c,
              resolutionWidth: state.videoModel.resolutionWidth(),
              resolutionHeight: state.videoModel.resolutionHeight(),
              dutationInSec: state.videoModel?.playTime ?? 0,
              onTap: (c) => dispatch(VideoItemActionCreator.onVideoClick(c)),
              onDoubleTap: (c) =>
                  dispatch(VideoItemActionCreator.onVideoDoubleClick(c))),
        );
      }
    } else if (state.videoModel.isImg()) {
      return TikTokVideoGesture(
          onDoubleClick: () =>
              dispatch(VideoItemActionCreator.onVideoDoubleClick(null)),
          child: bannerWidget());
    } else {
      return Container();
    }
  }

  String _getCacheText(bool isVideo, CacheStatus cacheStatus) {
    if (cacheStatus == CacheStatus.CACHED) {
      return isVideo ? Lang.CACHED : Lang.SAVE;
    } else if (cacheStatus == CacheStatus.CACHEING) {
      return isVideo ? Lang.CACHING1 : Lang.DOWNLOADING1;
    } else {
      return isVideo ? Lang.CACHE : Lang.SAVE;
    }
  }

  /// 下载
  Widget getDownloadWidget() {
    return GestureDetector(
      onTap: () {
        if (state.videoModel.isImg()) {
          dispatch(VideoItemActionCreator.onDownloadImg());
        } else {
          dispatch(VideoItemActionCreator.onDownloadVideo());
        }
      },
      child: Center(
        child: Container(
          // width: width,
          child: Column(
            children: <Widget>[
              ImageLoader.withP(
                ImageType.IMAGE_SVG,
                address: state.videoModel.isImg()
                    ? AssetsSvg.ICON_DOWNLOAD
                    : AssetsSvg.IC_VIDEODOWNLOAD,
                width: Dimens.pt20,
                height: Dimens.pt20,
              ).load(),
              SizedBox(height: Dimens.pt5),
              ShadowText(
                _getCacheText(state.videoModel.isVideo(), state.cacheStatus),
                fontSize: AppFontSize.fontSize12,
                color: state.cacheStatus != CacheStatus.CACHEING
                    ? AppColors.textColorWhite
                    : AppColors.primaryRaised,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 底部评论控件
  Widget getBottomComment() {
    return GestureDetector(
      onTap: () => dispatch(VideoItemActionCreator.onClickComment()),
      child: Container(
        color: Colors.black,
        width: screen.screenWidth,
        height: screen.bottomNavBarH,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Lang.BOTTOM_COMMENT,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  var resolution = configVideoSize(screen.screenWidth, screen.screenHeight,
      state.videoModel.resolutionWidth(), state.videoModel.resolutionHeight());

  /// 倒计时ui控件
  Widget _getTimeOutUi(context, Countdown countdown, String str) {
    return GestureDetector(
      onTap: () {
        Config.payFromType = PayFormType.user;
      },
      child: Container(
        padding: EdgeInsets.only(left: Dimens.pt16),
        width: Dimens.pt360,
        height: Dimens.pt30,
        color: Color.fromRGBO(0, 0, 0, .3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ImageLoader.withP(
              ImageType.IMAGE_SVG,
              address: AssetsSvg.IC_SPEAKER,
              width: Dimens.pt16,
              height: Dimens.pt16,
            ).load(),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: Dimens.pt6),
                alignment: Alignment.centerLeft,
                child: Text(
                  str,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color.fromRGBO(245, 206, 36, 1),
                    fontSize: AppFontSize.fontSize12,
                  ),
                ),
              ),
            ),
            CountDownWidget(
              seconds: countdown.countdownSec ?? 0,
              countdownEnd: () {
                // dispatch(VideoItemActionCreator.onCountdownEnd(type));
              },
              countdownChange: (_seconds) {
                countdown.countdownSec = _seconds;
                Provider.of<CountdwonUpdate>(viewService.context, listen: false)
                    .setCountdown(countdown);
              },
            ),
            Container(
              padding: EdgeInsets.only(right: Dimens.pt16),
              child: ImageLoader.withP(
                ImageType.IMAGE_SVG,
                address: AssetsSvg.IC_LEFT,
                width: Dimens.pt14,
                height: Dimens.pt14,
              ).load(),
            ),
          ],
        ),
      ),
    );
  }

  if (state.videoModel.isRandomAd()) {
    AdsInfoBean adModel = state.videoModel.randomAdsInfo;
    return Container(
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              JRouter().handleAdsInfo(adModel.href, id: adModel.id);
            },
            child: CustomNetworkImage(
              fit: BoxFit.contain,
              imageUrl: adModel.cover,
            ),
          ),
          InkWell(
            onTap: () {
              JRouter().handleAdsInfo(adModel.href, id: adModel.id);
            },
            child: Center(
              child: Image.asset(
                "assets/images/play_icon.png",
                width: 53.w,
                height: 66.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    children: [
      Expanded(
        child: Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          child: Stack(
            children: <Widget>[
              state.videoModel.isImg()
                  ? Container(color: AppColors.videoBackgroundColor)
                  : getFullPlayerCoverWidget(state.videoModel?.cover,
                      resolution.videoWidth, resolution.videoHeight),
              _getChildVideoItem(),

              ///左下角
              Consumer2<MainPlayerUIShowModel, SecondPlayerShowModel>(
                builder: (ctx, v1, v2, child) {
                  var show = state.type == VideoListType.SECOND
                      ? v2.isShow
                      : v1.isShow;
                  return Positioned(
                    bottom: Dimens.pt40,
                    left: Dimens.pt10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        show
                            ? LeftItem(state.videoModel, state.index, false,
                                (index) {
                                if (state.videoModel.isAd()) return;
                                eagleClick(state.selfId(),
                                    sourceId:
                                        state.eagleId(viewService.context),
                                    label:
                                        "${state.type?.index}_tag_${state.videoModel?.tags[index]?.name}");
                                dispatch(VideoItemActionCreator.onTapTag({
                                  'tagId': state.videoModel.tags[index].id,
                                  'uniqueId': state.uniqueId,
                                  'name': state.videoModel.tags[index].name,
                                  'cover':
                                      state.videoModel.tags[index].coverImg,
                                  'playCount':
                                      state.videoModel.tags[index].playCount,
                                }));
                              }, () {
                                if (state.videoModel.isAd()) return;
                                eagleClick(state.selfId(),
                                    sourceId:
                                        state.eagleId(viewService.context),
                                    label:
                                        "${state.type?.index}_city_${state.videoModel?.location?.city}");
                                dispatch(VideoItemActionCreator.onClickCity());
                              }, () {
                                if (state.videoModel.isAd()) return;
                                dispatch(VideoItemActionCreator.onBuyProduct());
                              }, () {
                                ///开通会员UI
                                dispatch(
                                    VideoItemActionCreator.stopPlayVideo());
                                Config.videoModel = state.videoModel;
                                Config.payFromType = PayFormType.video;
                                Gets.Get.to(
                                  MemberCentrePage().buildPage({
                                    "position": "0",
                                  }),
                                ).then((value) {
                                  GlobalStore.updateUserInfo(null);
                                  safePopPage();
                                });
                                AnalyticsEvent.clickBuyMembership(
                                    state.videoModel.title,
                                    state.videoModel.id,
                                    (state.videoModel.tags ?? [])
                                        .map((e) => e.name)
                                        .toList(),
                                    VipPopUpsType.vip);
                              })
                            : Container(),
                        state.videoModel.isAd()
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: Dimens.pt6, bottom: Dimens.pt12),
                                child:
                                    getCommonBtn(Lang.DOWNLOAD_NOW, onTap: () {
                                  eagleClick(state.selfId(),
                                      sourceId:
                                          state.eagleId(viewService.context),
                                      label:
                                          "${state.type?.index}_ad_${state.videoModel?.title ?? Lang.VIDEO_AD}");
                                  if (TextUtil.isNotEmpty(
                                      state?.videoModel?.linkUrl)) {
                                    JRouter().handleAdsInfo(
                                        state.videoModel.linkUrl);
                                  } else {
                                    showToast(msg: Lang.AD_LINK_EMPTY_TIP);
                                  }
                                }),
                              )
                            : Container()
                      ],
                    ),
                  );
                },
              ),
              //===========右侧模块=============
              Consumer2<MainPlayerUIShowModel, SecondPlayerShowModel>(
                builder: (ctx, v1, v2, child) {
                  var show = state.type == VideoListType.SECOND
                      ? v2.isShow
                      : v1.isShow;
                  return Positioned(
                    bottom: Dimens.pt66,
                    right: 0,
                    child: Column(
                      children: <Widget>[show ? getRightItem() : Container()],
                    ),
                  );
                },
              ),
              //===========音乐盘子模块============
              Positioned(
                bottom: 50.w,
                right: 14.w,
                child: Consumer2<MainPlayerUIShowModel, SecondPlayerShowModel>(
                  builder: (BuildContext context, MainPlayerUIShowModel main,
                      SecondPlayerShowModel second, Widget child) {
                    var addr;

                    if (state.type == VideoListType.SECOND) {
                      addr = !second.isShow
                          ? "assets/weibo/eye_down.svg"
                          : "assets/weibo/eye_up.svg";
                    } else {
                      addr = !main.isShow
                          ? "assets/weibo/eye_down.svg"
                          : "assets/weibo/eye_up.svg";
                    }
                    if(state.isTrandVideo??false){
                      main.setShow(false);
                      second.setShow(false);
                    }
                    return state.isTrandVideo??false?SizedBox():GestureDetector(
                      onTap: () {
                        if (state.type == VideoListType.SECOND) {
                          second.setShow(!second.isShow);
                        } else {
                          main.setShow(!main.isShow);
                        }
                        Config.hideEye = true;
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 4.w),
                        child: ImageLoader.withP(
                          ImageType.IMAGE_SVG,
                          address: addr,
                          width: !main.isShow || !second.isShow ? 30.w : 40.w,
                          height: !main.isShow || !second.isShow ? 30.w : 40.w,
                          color: Colors.white,
                          fit: BoxFit.cover,
                        ).load(),
                      ),
                    );
                  },
                ),
              ),

              // 新人倒计时
              // state.videoModel.isAd()
              //     ? Container()
              Consumer5<MainPlayerUIShowModel, SecondPlayerShowModel,
                  CountdwonUpdate, LouFengUpdate, FictionUpdate>(
                builder: (context, v1, v2, value, loufeng, fictionUpdate,
                    Widget child) {
                  var show = state.type == VideoListType.SECOND
                      ? v2.isShow
                      : v1.isShow;
                  Countdown countdown = value.countdown;
                  bool hasCountDown = countdown?.countdownSec != 0;
                  var list = [];
                  if (hasCountDown && state.enablePlay.value) {
                    list.add(_getTimeOutUi(context, countdown, value.msg));
                  }
                  var louFengList = loufeng.louFengModel.list ?? [];
                  if (louFengList.isNotEmpty) {
                    list.add(getItem(louFengList[0]));
                  }

                  var novelModelList = fictionUpdate.novelModel.list ?? [];
                  if (novelModelList.isNotEmpty) {
                    list.add(getItem(novelModelList[0]));
                  }

                  return show ? Container() : Container();
                },
              ),
            ],
          ),
        ),
      ),
      /*Visibility(
        visible: state.type == VideoListType.SECOND,
        child: getBottomComment(),
      ),*/
      Visibility(
        visible: state.type == VideoListType.SECOND,
        child: SizedBox(height: screen.paddingBottom),
      )
    ],
  );
}
