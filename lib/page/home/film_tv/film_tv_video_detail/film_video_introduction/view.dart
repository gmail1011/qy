import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/new_page/mine/mine_share_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareHomePage.dart';
import 'package:flutter_app/page/anwang_trade/widget/single_btn_view.dart';
import 'package:flutter_app/page/city/city_video/page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/film_video_introduction/action.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/page/video/widget/love_button/love_button.dart';
import 'package:flutter_app/page/video/widget/love_button/model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_hot_list/hot_list_page.dart';
import 'package:flutter_app/weibo_page/community_hot_list/hot_list_page_special.dart';
import 'package:flutter_app/weibo_page/community_recommend/topic_detail/topic_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/alert_tool.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/newdialog/coinVideo_dailog_hjll.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/local_server/video_cache_manager.dart';
import 'package:flutter_base/task_manager/dialog_task_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import '../../../page.dart';
import '../action.dart';
import 'state.dart';

Widget buildView(FilmVideoIntroductionState state, Dispatch dispatch, ViewService viewService) {
  return pullYsRefresh(
    enablePullDown: true,
    enablePullUp: !(state.videoList == null || state.videoList.isEmpty),
    refreshController: state.refreshController,
    onRefresh: () async {
      await dispatch(FilmVideoIntroductionActionCreator.refreshData());
    },
    onLoading: () async {
      await dispatch(FilmVideoIntroductionActionCreator.loadMoreData());
    },
    child: CustomScrollView(
      slivers: [
        ///简介
        _createIntroductionUI(state, dispatch, viewService),

        ///广告UI
        _buildAdsUI(state, dispatch, viewService),

        ///精品推荐UI
        _createRecommandUI(viewService.context),

        ///判断列表是否为空
        (state.videoList == null || state.videoList.isEmpty)
            ? SliverToBoxAdapter(
                child: state.dataReq
                    ? Container(
                        margin: EdgeInsets.only(top: 60),
                        child: LoadingWidget(),
                      )
                    : Container(
                        margin: EdgeInsets.only(bottom: 80),
                        child: CErrorWidget(Lang.EMPTY_DATA, retryOnTap: () {
                          dispatch(FilmVideoIntroductionActionCreator.refreshData());
                        }),
                      ),
              )
            : SliverPadding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    if (state.videoList.isEmpty) {
                      return Container();
                    }
                    VideoModel videoItem = state.videoList[index];
                    return GestureDetector(
                      onTap: () {
                        if (videoItem?.id == state.viewModel?.id) {
                          showToast(msg: "视频正在播放～");
                          l.e("_reloadNewVideo:", "视频正在播放");
                          return;
                        }
                        dispatch(FilmVideoIntroductionActionCreator.reloadNewVideo(videoItem));
                      },
                      child: _buildRecommendListItem(videoItem, viewService),
                    );
                  }, childCount: state.videoList?.length ?? 0),
                ),
              ),
      ],
    ),
  );
}

Widget _buildRecommendListItem(VideoModel videoModel, ViewService viewService) {
  return Container(
    width: 408,
    height: 90,
    margin: EdgeInsets.only(top: 10),
    color: Color(0xff161529),
    child: Row(
      children: [
        CustomNetworkImage(
          imageUrl: videoModel.cover,
          type: ImgType.cover,
          fit: BoxFit.cover,
          width: 182,
          height: 90,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(videoModel?.title ?? "",
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xffe7e7e7),
                            fontSize: 14.w,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(width: 8)
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 8, left: 10),
              child: videoModel?.tags == null
                  ? Container()
                  : Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: videoModel?.tags?.map((e) => _createTagItem(e, videoModel?.id, viewService))?.toList(),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, left: 10),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/time_logo.png",
                    width: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    TimeHelper.getTimeText(videoModel.playTime.toDouble()),
                    style: TextStyle(color: Color(0xff9fa19f), fontSize: 12.w),
                  ),
                  SizedBox(width: 16),
                  Image.asset(
                    "assets/images/play_count.png",
                    width: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    videoModel.playCountDesc,
                    style: TextStyle(
                      color: Color(0xff9fa19f),
                      fontSize: 12.w,
                    ),
                  ),
                ],
              ),
            )
          ],
        ))
      ],
    ),
  );
}

///简介
SliverToBoxAdapter _createIntroductionUI(FilmVideoIntroductionState state, Dispatch dispatch, ViewService viewService) {
  return SliverToBoxAdapter(
    child: Container(
      color: AppColors.primaryColor,
      padding: EdgeInsets.only(top: 12.w, left: 16, right: 16, bottom: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///是否有发布者信息
          // if ((state.viewModel.publisher?.uid ?? 0) > 0)
          //   _buildUserInfoUI(dispatch, viewService, state.viewModel),
          Container(
            margin: EdgeInsets.only(top: 7.w),
            alignment: Alignment.centerLeft,
            child: Text(
              state.viewModel?.title ?? "",
              maxLines: 3,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),

            /*child: WordRichText(
              title: state.viewModel?.title ?? "",
              maxTextSize: 45,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),*/
          ),
          const SizedBox(height: 4),

          ///播放次数
          _buildPlayCount(state.viewModel),
          const SizedBox(height: 18),
          _createFunctionUI(state, dispatch, viewService),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

///用户信息UI
Row _buildUserInfoUI(Dispatch dispatch, ViewService viewService, VideoModel viewModel) => Row(
      children: [
        GestureDetector(
          onTap: () async {
            Map<String, dynamic> arguments = {
              'uid': viewModel.publisher.uid,
              'uniqueId': DateTime.now().toIso8601String(),
            };

            viewService.broadcast(FilmVideoIntroductionActionCreator.stopVideoPlay(viewModel.id));
            await Gets.Get.to(() => BloggerPage(arguments), opaque: false);
            viewService.broadcast(FilmVideoIntroductionActionCreator.notifyReStartPlayVideo(viewModel.id));
          },
          child: HeaderWidget(
            headWidth: 52.w,
            headHeight: 52.w,
            headPath: viewModel.publisher.portrait,
            level: (viewModel.publisher.superUser ?? false) ? 1 : 0,
            levelSize: 15.w,
            positionedSize: 0,
            defaultHead: Image.asset(
              "assets/weibo/loading_horizetol.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> arguments = {
                  'uid': viewModel.publisher.uid,
                  'uniqueId': DateTime.now().toIso8601String(),
                };

                viewService.broadcast(FilmVideoIntroductionActionCreator.stopVideoPlay(viewModel.id));
                await Gets.Get.to(() => BloggerPage(arguments), opaque: false);
                viewService.broadcast(FilmVideoIntroductionActionCreator.notifyReStartPlayVideo(viewModel.id));
              },
              child: Row(
                children: [
                  Container(
                    child: Text(
                      viewModel.publisher.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: viewModel.publisher.isVip && viewModel.publisher.vipLevel > 0
                              ? Color.fromRGBO(246, 197, 89, 1)
                              : Colors.white,
                          fontSize: 18.nsp),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  viewModel.publisher.isVip && viewModel.publisher.vipLevel > 0
                      ? Image.asset(
                          "assets/weibo/huangguan.png",
                          width: 19.w,
                          height: 19.w,
                          fit: BoxFit.contain,
                        )
                      : Container(),
                  SizedBox(
                    width: 10.w,
                  ),
                  Row(
                    children: viewModel.publisher.awardsExpire.map((e) {
                      return e.isExpire
                          ? Row(
                              children: [
                                CustomNetworkImage(
                                  imageUrl: e.imageUrl ?? "",
                                  width: 18.w,
                                  height: 18.w,
                                  fit: BoxFit.cover,
                                  placeholder: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            )
                          : Container();
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6.w,
            ),
            GestureDetector(
              onTap: () async {
                // Map<String, String> parameter = {
                //   "city": viewModel.location.city,
                //   "id": viewModel.location.id,
                // };
                //
                // viewService.broadcast(
                //     FilmVideoIntroductionActionCreator.stopVideoPlay(
                //         viewModel.id));
                // await Gets.Get.to(CityVideoPage().buildPage(parameter),
                //     opaque: false);
                // viewService.broadcast(
                //     FilmVideoIntroductionActionCreator.notifyReStartPlayVideo(
                //         viewModel.id));
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Image.asset(
                    //   "assets/weibo/dingwei.png",
                    //   width: 16.w,
                    //   height: 16.w,
                    // ),
                    // SizedBox(
                    //   width: 8.w,
                    // ),
                    Text(
                      viewModel.publisher.upTag ?? "",
                      style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: 14.nsp),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      formatTime(viewModel.createdAt),
                      style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: 14.nsp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Spacer(),
        Offstage(
          offstage: _showFollowedUI(viewModel?.publisher),
          child: GestureDetector(
            onTap: () async {
              // 自己不能关注自己
              if (GlobalStore.isMe(viewModel.publisher.uid)) {
                showToast(msg: Lang.GLOBAL_TIP_TXT1);
                return;
              }
              dispatch(FilmVideoIntroductionActionCreator.doFollow(viewModel?.publisher?.uid));
            },
            child: Visibility(
              visible: viewModel.publisher.hasFollowed || viewModel.publisher.uid == GlobalStore.getMe().uid ? false : true,
              child: Image.asset(
                "assets/weibo/guanzhu.png",
                width: 68.w,
                height: 26.w,
              ),
            ),
          ),
        ),
      ],
    );

///是否展示关注UI-是否自己 是否已经关注 默认展示关注UI
bool _showFollowedUI(PublisherBean publisher) => (GlobalStore.isMe(publisher?.uid) || (publisher?.hasFollowed ?? false)) ? true : false;

///tag item
Widget _createTagItem(TagsBean tagItem, String videoId, ViewService viewService) {
  return GestureDetector(
    child: Container(
      color: Colors.transparent,
      child: Text(
        "${tagItem.name ?? ""}",
        style: TextStyle(
          color: Color.fromRGBO(159, 159, 159, 1),
          fontSize: 12.w,
        ),
      ),
    ),
  );
}

Widget getTalkHotTop(FilmVideoIntroductionState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    child: Container(
      width: 397,
      height: 39,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: state.rankInfoModel.rankType == "debate"
              ? AssetImage("assets/images/hot_top_talk_bg.png")
              : state.rankInfoModel.rankType == "event"
                  ? AssetImage("assets/images/hot_top_event_bg.png")
                  : state.rankInfoModel.rankType == "month"
                      ? AssetImage("assets/images/hot_top_month_bg.png")
                      : AssetImage("assets/images/hot_top_week_bg.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Container(
          margin: EdgeInsets.only(left: 50),
          child: Text(
            "${TextUtil.isEmpty(state.rankInfoModel.title) ? (state.rankInfoModel.rankType == "debate" ? "全站争论榜 第${state.rankInfoModel.ranking}名" : state.rankInfoModel.rankType == "event" ? "大事记 第${state.rankInfoModel.ranking}名" : state.rankInfoModel.rankType == "month" ? "全站月榜 第${state.rankInfoModel.ranking}名" : "全站周榜 第${state.rankInfoModel.ranking}名") : state.rankInfoModel.title}",
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
          )),
    ),
    onTap: () {
      // bus.emit(EventBusUtils.changeHotListTab, 2);
      // Map<String, dynamic> arguments = {
      //   'list': [],
      //   'findList': [],
      //   'areaList': [],
      // };
      // Gets.Get.to(() =>CommunityHotListPage(), opaque: false);
      Gets.Get.to(CommunityHotListPageSpecial(
        position: state.rankInfoModel.rankType == "event"
            ? 0
            : state.rankInfoModel.rankType == "debate"
                ? 1
                : state.rankInfoModel.rankType == "month"
                    ? 3
                    : 2,
      ));
    },
  );
}

///点赞，分享，收藏，缓存，线路切换
Widget _createFunctionUI(FilmVideoIntroductionState state, Dispatch dispatch, ViewService viewService) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _createFunctionItemUI(AssetsImages.ICON_VIDEO_FUNC04, "下载", onTap: () async {
        ///判断当前是否要购买视频
        if (needBuyVideo(state.viewModel)) {
          _showBuyVideoDialogUI(viewService, state.viewModel);
          return;
        }
        int downloadCount = GlobalStore.getWallet().downloadCount ?? 0;
        if (downloadCount == null || downloadCount <= 0) {
          if (!(state.viewModel.freeArea ?? false)) {
            showDialog(
                context: viewService.context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SingleBtnDialogView(
                    title: "提示",
                    content: "下载次数已用完，购买VIP获取次数",
                    btnText: "购买VIP",
                    callback: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return RechargeVipPage("");
                        },
                      )).then((value) => {GlobalStore.refreshWallet(false)});
                    },
                  );
                });
            return;
          }
          showToast(msg: "下载次数不足");
          return;
        }
        dispatch(FilmVideoIntroductionActionCreator.cacheVideo());
      }),

      _buildLikeItem(state.viewModel.vidStatus.hasLiked, state.viewModel.likeCount, dispatch),

      ///收藏
      _buildCollectItem(state.viewModel, dispatch),

      ///赚钱
      _createFunctionItemUI("assets/weibo/video_share.png", "分享", onTap: () {
        // showShareVideoDialog(viewService.context, () async {
        //   await Future.delayed(Duration(milliseconds: 500));
        // }, videoModel: state.viewModel, isLongVideo: true, isFvVideo: true);
        Gets.Get.to(MineSharePage());
      }),
    ],
  );
}

Widget _buildPlayCount(VideoModel viewModel) {
  if (viewModel == null) {
    return SizedBox();
  }
  return Container(
      child: Text(
    "${viewModel.playCountDescFour}",
    style: TextStyle(
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: 12,
    ),
  ));
}

///收藏UI
Widget _buildCollectItem(VideoModel viewModel, Dispatch dispatch) {
  if (viewModel == null) {
    return SizedBox();
  }
  bool isLove = (viewModel?.vidStatus?.hasCollected ?? false);
  var love1 = assetsImg(
    "assets/weibo/collected.png",
    fit: BoxFit.cover,
  );
  var love2 = assetsImg(
    "assets/weibo/collect.png",
    fit: BoxFit.cover,
  );
  var loveItem = Container(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        child: LoveButton(
          loveController: LoveController(isLove),
          dotColor: DotColor(
            dotPrimaryColor: Color.fromARGB(1, 152, 219, 236),
            dotSecondaryColor: Color.fromARGB(1, 247, 188, 48),
            dotLastColor: Color.fromARGB(1, 221, 70, 136),
            dotThirdColor: Color.fromARGB(1, 205, 143, 246),
          ),
          imgWidth: 20.w,
          imgHeight: 20.w,
          cWidth: 20.w,
          cHeight: 20.w,
          imageTrue: love1,
          imageFalse: love2,
          duration: Duration(milliseconds: 800),
          enable: true,
          onIconCompleted: () {},
          onIconClicked: () {
            dispatch(FilmVideoIntroductionActionCreator.operateCollect());
          },
        ),
      ),
      SizedBox(height: 4),
      Container(
        child: Text(
          "收藏",
          style: TextStyle(
            color: Color.fromRGBO(167, 167, 167, 1),
            fontSize: 12.w,
          ),
        ),
      ),
    ],
  ));
  return loveItem;
}

///点赞UI
Widget _buildLikeItem(bool isLove, int loveCount, Dispatch dispatch) {
  var love1 = assetsImg(
    "assets/images/thumb_liked.png",
    fit: BoxFit.cover,
  );
  var love2 = assetsImg(
    "assets/images/thumb_like_border.png",
    fit: BoxFit.cover,
  );
  var loveItem = Container(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        child: LoveButton(
          loveController: LoveController(isLove),
          dotColor: DotColor(
            dotPrimaryColor: Color.fromARGB(1, 152, 219, 236),
            dotSecondaryColor: Color.fromARGB(1, 247, 188, 48),
            dotLastColor: Color.fromARGB(1, 221, 70, 136),
            dotThirdColor: Color.fromARGB(1, 205, 143, 246),
          ),
          imgWidth: 20.w,
          imgHeight: 20.w,
          cWidth: 20.w,
          cHeight: 20.w,
          imageTrue: love1,
          imageFalse: love2,
          duration: Duration(milliseconds: 800),
          enable: true,
          onIconCompleted: () {},
          onIconClicked: () {
            dispatch(FilmVideoIntroductionActionCreator.operateLike());
          },
        ),
      ),
      SizedBox(height: 4),
      Container(
        child: (loveCount > 0)
            ? Text(
                "$loveCount",
                style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1),
                  fontSize: 12.w,
                ),
              )
            : Text(
                "点赞",
                style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1),
                  fontSize: 12.w,
                ),
              ),
      ),
    ],
  ));
  return loveItem;
}

///购买视频对话框
_showBuyVideoDialogUI(ViewService viewService, VideoModel viewModel) async {
  ///购买视频
  var result = await showBuyVideo(viewService.context, viewModel);
  l.e("购买视频", "购买视频$result");
  if (result) {
    viewService.broadcast(FilmVideoIntroductionActionCreator.notifyBuyVideo(viewModel?.id)); //viewModel
  }
}

///功能按钮UI
Widget _createFunctionItemUI(String imagePath, String title, {Function onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage(imagePath),
            width: 22.w,
            height: 22.w,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 12.w,
            ),
          ),
        ],
      ),
    ),
  );
}

///创建广告UI
SliverToBoxAdapter _buildAdsUI(FilmVideoIntroductionState state, Dispatch dispatch, ViewService viewService) {
  return SliverToBoxAdapter(
    child: Offstage(
        offstage: state.adsList?.length == 0 ? true : false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AdsBannerWidget(
            state.adsList,
            width: screen.screenWidth - 10 * 2,
            height: (screen.screenWidth - 10 * 2) * (113 / 408),
            fit: BoxFit.cover,
            onItemClick: (index) async {
              ///通知停止播放视频
              viewService.broadcast(FilmVideoIntroductionActionCreator.stopVideoPlay(state.viewModel?.id));

              var ad = state.adsList[index];
              var result = await JRouter().handleAdsInfo(ad.href, id: ad.id);
              l.e("_buildAdsUI", "$result");
              viewService.broadcast(FilmVideoIntroductionActionCreator.notifyReStartPlayVideo(state.viewModel?.id));
            },
          ),
        )),
  );
}

///精品推荐UI
SliverToBoxAdapter _createRecommandUI(BuildContext context) {
  return SliverToBoxAdapter(
    child: Container(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          ///推荐UI
          Container(
            margin: EdgeInsets.only(top: 8.w, bottom: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // svgAssets(AssetsSvg.ICON_WITHDRAW_RECTANGLE,
                //     width: 8.w, height: 24.w),
                const SizedBox(width: 16),
                Text(
                  "精彩推荐",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
