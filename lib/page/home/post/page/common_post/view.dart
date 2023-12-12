import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/fuli_guangchang/fu_li_guang_chang_page.dart';
import 'package:flutter_app/page/home/AVCommentary/a_v_commentary_page.dart';
import 'package:flutter_app/page/home/post/page/EntryVideo/entry_video_page.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/page/wallet/my_agent/promote_home_page/page.dart';
import 'package:flutter_app/page/wallet/wallet_main/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/page/home/post/action.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import '../../MySliverDelegate.dart';
import '../../ads_banner_widget.dart';
import 'action.dart';
import 'detail/common_post_detail_page.dart';
import 'state.dart';

import 'package:get/route_manager.dart' as Gets;

Widget buildView(
    CommonPostState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  bool isHaveData = (state.dayItems?.length ?? 0) > 0;

  Widget bannerWidget = ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    child: AdsBannerWidget(
      state.adsList,
      width: Dimens.pt360,
      //height: Dimens.pt250,
      height: Dimens.pt154,
      onItemClick: (index) {
        var ad = state.adsList[index];
        JRouter().handleAdsInfo(ad.href, id: ad.id);
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context),
            label: "banner(${ad?.id ?? ""})");*/
      },
    ),
  );

  ///获取item UI
  Widget itemView(
      TagsDetailDataSections item, Dispatch dispatch, ViewService viewService,
      {double appMainTop = 16, bool showNormalTitle = true}) {
    //var list = item.videoInfo;

    ///改版了
    /*if (item.vidInfo.length > 3) {
    list = item.vidInfo.sublist(0, 3);
  }*/
    /*String tagDesc = item.sectionName != null && item.sectionName.isNotEmpty
        ? " - ${item.sectionName}"
        : "";*/
    return Container(
      padding: EdgeInsets.only(
          left: Dimens.pt12,
          //top: appMainTop,
          right: Dimens.pt10,
          bottom: AppPaddings.appMargin),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: [
                /*GestureDetector(
                onTap: () {
                  dispatch(VideoTopicActionCreator.onTagClick(item));
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: Dimens.pt6, left: Dimens.pt10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: Dimens.pt220,
                        child: Text(
                          showNormalTitle
                              ? (item.tagName + tagDesc)
                              : "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: AppFontSize.fontSize20,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFF5164E),
                              Color(0xFFFF6538),
                              Color(0xFFF54404)
                            ]),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: Dimens.pt6,
                                  offset: Offset(0, 6),
                                  color: Color.fromRGBO(248, 44, 44, 0.4))
                            ],
                            borderRadius: BorderRadius.circular(6.0)),
                        padding: EdgeInsets.only(left: Dimens.pt8),
                        margin: EdgeInsets.only(right: Dimens.pt10),
                        child: Row(
                          children: [
                            Text(
                              Lang.MORE,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize10),
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: screen.screenWidth,
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Dimens.pt5, left: Dimens.pt5, right: Dimens.pt5),
                  child: Row(
                    children: list
                        .map((e) => getBodyItem(e, () {
                              Map<String, dynamic> maps = Map();
                              maps['pageNumber'] = 1;
                              maps['pageSize'] = 3;
                              maps['currentPosition'] = item.vidInfo.indexOf(e);
                              maps['videoList'] = item.vidInfo;
                              maps['tagID'] = item.tagId;
                              maps['playType'] = VideoPlayConfig.VIDEO_TAG;
                              JRouter().go(SUB_PLAY_LIST, arguments: maps);
                            }))
                        .toList(),
                  ),
                ),
              ),*/

                GestureDetector(
                  onTap: () {
                    //dispatch(CommonPostActionCreator.onTagClick(item));
                    /*Navigator.of(viewService.context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            common_post_detailPage().buildPage({
                              "id": item.sectionID,
                              "title": item.sectionName,
                            })));*/

                    Gets.Get.to(() =>
                        common_post_detailPage().buildPage({
                          "id": item.sectionID,
                          "title": item.sectionName,
                        }),
                        opaque: false);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(
                      top: Dimens.pt6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: Dimens.pt220,
                          child: Text(
                            (item.sectionName),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.fontSize16,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          /*decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFF5164E),
                              Color(0xFFFF6538),
                              Color(0xFFF54404)
                            ]),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: Dimens.pt6,
                                  offset: Offset(0, 6),
                                  color: Color.fromRGBO(248, 44, 44, 0.4))
                            ],
                            borderRadius: BorderRadius.circular(6.0)),*/
                          padding: EdgeInsets.only(left: Dimens.pt8),
                          //margin: EdgeInsets.only(right: Dimens.pt4),
                          child: Row(
                            children: [
                              Text(
                                Lang.MORE,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFontSize.fontSize10),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dimens.pt10,
          ),
          GestureDetector(
            onTap: () {
              List<VideoModel> lists = item.videoInfo
                  .map((e) => VideoModel.fromJson(e.toJson()))
                  .toList();

              Map<String, dynamic> maps = Map();
              maps['pageNumber'] = 1;
              maps['pageSize'] = 3;
              maps['currentPosition'] = 0;
              maps['videoList'] = lists;
              maps['tagID'] = item.videoInfo[0].tags[0].id;
              maps['playType'] = VideoPlayConfig.VIDEO_TAG;

              if (isHorizontalVideo(
                  resolutionWidth(item.videoInfo[0].resolution),
                  resolutionHeight(item.videoInfo[0].resolution))) {

                VideoModel viewModel = VideoModel.fromJson(item.videoInfo[0].toJson());
                Gets.Get.to(() =>VideoPage(viewModel),opaque: false);
              } else {
                Gets.Get.to(SubPlayListPage().buildPage(maps), opaque: false);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  CustomNetworkImage(
                    imageUrl: item.videoInfo[0].cover,
                    type: ImgType.cover,
                    height: Dimens.pt180,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: Dimens.pt40,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Dimens.pt10,
                          right: Dimens.pt10,
                          bottom: Dimens.pt10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/play_icon.png",
                                  width: Dimens.pt11, height: Dimens.pt11),
                              SizedBox(
                                width: Dimens.pt4,
                              ),
                              Text(
                                item.videoInfo[0].playCount > 10000
                                    ? (item.videoInfo[0].playCount / 10000)
                                            .toStringAsFixed(1) +
                                        "w"
                                    : item.videoInfo[0].playCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.pt12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            TimeHelper.getTimeText(
                                item.videoInfo[0].playTime.toDouble()),
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -1,
                      right: -1,
                      child: Visibility(
                        visible: item.videoInfo[0].originCoins != null &&
                                item.videoInfo[0].originCoins != 0
                            ? true
                            : false,
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            //height: Dimens.pt20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4)),
                              //color: Color.fromRGBO(255, 0, 169, 1),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(245, 22, 78, 1),
                                  Color.fromRGBO(255, 101, 56, 1),
                                  Color.fromRGBO(245, 68, 4, 1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: Dimens.pt8,
                              right: Dimens.pt8,
                              top: Dimens.pt3,
                              bottom: Dimens.pt3,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageLoader.withP(ImageType.IMAGE_SVG,
                                        address: AssetsSvg.IC_GOLD,
                                        width: Dimens.pt12,
                                        height: Dimens.pt12)
                                    .load(),
                                SizedBox(width: Dimens.pt6),
                                Text(item.videoInfo[0].originCoins.toString(),
                                    style: TextStyle(
                                        color: AppColors.textColorWhite)),
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
                            item.videoInfo[0].originCoins == 0 ? true : false,
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            //height: Dimens.pt20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(245, 22, 78, 1),
                                  Color.fromRGBO(255, 101, 56, 1),
                                  Color.fromRGBO(245, 68, 4, 1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: Dimens.pt10,
                              right: Dimens.pt10,
                              top: Dimens.pt2,
                              bottom: Dimens.pt2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "VIP",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dimens.pt8,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                item.videoInfo[0].title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(
            height: Dimens.pt8,
          ),
          Container(
            height: Dimens.pt260,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: viewService.context,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 1.30),
                itemCount: item.videoInfo.length - 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      List<VideoModel> lists = item.videoInfo
                          .map((e) => VideoModel.fromJson(e.toJson()))
                          .toList();
                      Map<String, dynamic> maps = Map();
                      maps['pageNumber'] = 1;
                      maps['pageSize'] = 3;
                      maps['currentPosition'] = index + 1;
                      maps['videoList'] = lists;
                      //maps['tagID'] = item.videoInfo[0].tags;
                      maps['playType'] = VideoPlayConfig.VIDEO_TAG;

                      if (isHorizontalVideo(
                          resolutionWidth(item.videoInfo[index + 1].resolution),
                          resolutionHeight(item.videoInfo[index + 1].resolution))) {


                        VideoModel viewModel = VideoModel.fromJson(item.videoInfo[index + 1].toJson());
                        Gets.Get.to(VideoPage(viewModel),opaque: false);

                      } else {
                        Gets.Get.to(SubPlayListPage().buildPage(maps),
                            opaque: false);
                      }
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              CustomNetworkImage(
                                imageUrl: item.videoInfo[index + 1].cover,
                                type: ImgType.cover,
                                height: Dimens.pt100,
                                fit: BoxFit.cover,
                              ),

                              /*CachedNetworkImage(
                                imageUrl: item.videoInfo[index + 1].cover,
                                fit: BoxFit.cover,
                                cacheManager: ImageCacheManager(),
                                placeholder: (context, url) {
                                  return placeHolder(ImgType.cover,
                                      null, Dimens.pt100);
                                },
                              ),*/

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
                                      left: Dimens.pt10,
                                      right: Dimens.pt10,
                                      bottom: Dimens.pt4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            item.videoInfo[1 + index]
                                                        .playCount >
                                                    10000
                                                ? (item.videoInfo[1 + index]
                                                                .playCount /
                                                            10000)
                                                        .toStringAsFixed(1) +
                                                    "w"
                                                : item.videoInfo[1 + index]
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
                                        TimeHelper.getTimeText(item
                                            .videoInfo[1 + index].playTime
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
                                    visible:
                                        item.videoInfo[1 + index].originCoins !=
                                                    null &&
                                                item.videoInfo[1 + index]
                                                        .originCoins !=
                                                    0
                                            ? true
                                            : false,
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            //height: Dimens.pt20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(4)),
                                              //color: Color.fromRGBO(255, 0, 169, 1),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      245, 22, 78, 1),
                                                  Color.fromRGBO(
                                                      255, 101, 56, 1),
                                                  Color.fromRGBO(245, 68, 4, 1),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                              left: Dimens.pt4,
                                              right: Dimens.pt7,
                                              top: Dimens.pt2,
                                              bottom: Dimens.pt2,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ImageLoader.withP(
                                                        ImageType.IMAGE_SVG,
                                                        address:
                                                            AssetsSvg.IC_GOLD,
                                                        width: Dimens.pt12,
                                                        height: Dimens.pt12)
                                                    .load(),
                                                SizedBox(width: Dimens.pt4),
                                                Text(
                                                    item.videoInfo[1 + index]
                                                        .originCoins
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .textColorWhite,
                                                      fontSize: Dimens.pt12,
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
                                        item.videoInfo[1 + index].originCoins ==
                                                0
                                            ? true
                                            : false,
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            //height: Dimens.pt20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(4)),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      245, 22, 78, 1),
                                                  Color.fromRGBO(
                                                      255, 101, 56, 1),
                                                  Color.fromRGBO(245, 68, 4, 1),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                              left: Dimens.pt10,
                                              right: Dimens.pt10,
                                              top: Dimens.pt2,
                                              bottom: Dimens.pt2,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "VIP",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Dimens.pt12,
                                                  ),
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
                          height: Dimens.pt4,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.videoInfo[1 + index].title,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  return NotificationListener(
    onNotification: (ScrollNotification notification) {
      switch (notification.runtimeType) {
        case ScrollStartNotification:
          break;
        case ScrollUpdateNotification:
          if (!isHaveData) {
            return false;
          }
          double maxOutOffset = screen.displayHeight;
          if (notification.metrics.pixels < maxOutOffset &&
              state.showToTopBtn) {
            viewService.broadcast(PostActionCreator.onIsShowTopBtn(false));
          } else if (notification.metrics.pixels >= maxOutOffset &&
              state.showToTopBtn == false) {
            viewService.broadcast(PostActionCreator.onIsShowTopBtn(true));
          } else {
            viewService.broadcast(
                PostActionCreator.onIsShowTopBtn(state.showToTopBtn));
          }
          break;
        case ScrollEndNotification:
          break;
        case OverscrollNotification:
          break;
      }
      return true;
    },
    child: BaseRequestView(
      retryOnTap: () {
        dispatch(CommonPostActionCreator.onInit());
      },
      controller: state.baseRequestController,
      child: Container(
        color: AppColors.primaryColor,
        child: pullYsRefresh(
          refreshController: state.refreshController,
          enablePullDown: false,
          onLoading: () {
            //dispatch(CommonPostActionCreator.onLoadMore(state.pageNumber += 1));
            dispatch(CommonPostActionCreator.onGetDailyDataLoadMore(
                state.dailyDataPageNum += 1));
          },
          onRefresh: () {
            //dispatch(CommonPostActionCreator.onInit());
          },
          /*child: ListView.builder(
                itemCount: adapter.itemCount,
                itemBuilder: adapter.itemBuilder,
              ),*/

          child: CustomScrollView(
            slivers: [
              SliverOffstage(
                offstage: state.adsList == null || state.adsList.length == 0
                    ? true
                    : false,
                sliver: SliverPadding(
                  padding: EdgeInsets.only(
                      left: Dimens.pt16, right: Dimens.pt16, top: Dimens.pt10),
                  sliver: SliverToBoxAdapter(
                    child: bannerWidget,
                  ),
                ),
              ),
              /*SliverToBoxAdapter(
                      child: Container(
                        height: 1600,
                        child: ListView.builder(
                          itemCount: adapter.itemCount,
                          itemBuilder: adapter.itemBuilder,
                        ),
                      ),
                    ),*/

              SliverToBoxAdapter(
                child: MediaQuery.removePadding(
                  context: viewService.context,
                  removeTop: true,
                  child: Container(
                    height: Dimens.pt140,
                    margin: EdgeInsets.only(
                      left: Dimens.pt16,
                      right: Dimens.pt16,
                      top: Dimens.pt16,
                    ),
                    child: MediaQuery.removePadding(
                      context: viewService.context,
                      removeTop: true,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.iconLists.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 2,
                            childAspectRatio: 1.16),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        //JRouter().jumpPage(FU_LI_GUANG_CHANG_PAGE);
                                        Gets.Get.to(
                                            FuLiGuangChangPage()
                                                .buildPage(null),
                                            opaque: false);
                                        break;
                                      case 1:
                                        //JRouter().jumpPage(PAGE_WALLET);
                                        /*Gets.Get.to(
                                            MemberCentrePage().buildPage(null),
                                            opaque: false);*/
                                        Config.payFromType = PayFormType.user;
                                        break;
                                      case 2:
                                        bus.emit(EventBusUtils.gamePage);

                                        break;
                                      case 3:
                                        bus.emit(EventBusUtils.louFengPage);
                                        break;
                                      case 4:
                                        //JRouter().jumpPage(PAGE_AV_COMMENTARY);

                                        Gets.Get.to(
                                            AVCommentaryPage().buildPage(null),
                                            opaque: false);
                                        break;
                                      case 5:
                                        /*Navigator.of(viewService.context)
                                              .push(MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          EntryVideoPage()
                                                              .buildPage(
                                                                  null)));*/

                                        Gets.Get.to(
                                            EntryVideoPage().buildPage(null),
                                            opaque: false);
                                        break;
                                      case 6:
                                        /*Navigator.of(viewService.context)
                                              .push(MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          NakeChatListPage()));*/

                                        //Gets.Get.to(NakeChatListPage(), opaque: false);
                                        break;
                                      case 7:

                                        //JRouter().go(PAGE_PROMOTE_HOME);

                                        Gets.Get.to(
                                            PromoteHomePage().buildPage(null),
                                            opaque: false);

                                        break;
                                    }
                                  },
                                  /*child: CustomNetworkImage(
                                        imageUrl:
                                        "http://www.xiugei.com/edimg/20190228/15513362448794767.png",
                                        fit: BoxFit.cover,
                                        width: Dimens.pt40,
                                        height: Dimens.pt40,
                                      ),*/
                                  child: Image.asset(
                                    state.iconLists[index].assestName,
                                    fit: BoxFit.cover,
                                    width: Dimens.pt40,
                                    height: Dimens.pt40,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimens.pt4,
                                ),
                                Text(
                                  state.iconLists[index].name,
                                  style: TextStyle(
                                      fontSize: Dimens.pt12,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          );
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
              state.specialModels == null || state.specialModels.length == 0
                  ? Container()
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return itemView(
                            state.specialModels[index], dispatch, viewService);
                      }, childCount: state.specialModels.length),
                    ),
              SliverPadding(
                padding: EdgeInsets.only(left: Dimens.pt4, bottom: Dimens.pt6),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: MySliverDelegate(
                    maxHeight: Dimens.pt40,
                    minHeight: Dimens.pt40,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: Colors.transparent,
                        padding:
                            EdgeInsets.only(top: Dimens.pt6, left: Dimens.pt6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              //width: Dimens.pt220,
                              child: Text(
                                "精品推荐 - 每日更新",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFontSize.fontSize16,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              state.selectedTagsData == null
                  ? SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        child: LoadingWidget(),
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.only(
                          left: Dimens.pt10, right: Dimens.pt10),
                      sliver: SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 4,
                        itemCount: state.selectedTagsData.xList.length,
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(2),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              List<VideoModel> lists = [];

                              state.selectedTagsData.xList.forEach((element) {
                                VideoModel video =
                                    VideoModel.fromJson(element.toJson());
                                lists.add(video);
                              });

                              Map<String, dynamic> maps = Map();
                              maps['pageNumber'] = 1;
                              maps['pageSize'] = 3;
                              maps['currentPosition'] = index;
                              maps['videoList'] = lists;
                              maps['tagID'] = lists[0].tags[0].id;
                              maps['playType'] = VideoPlayConfig.VIDEO_TAG;
                              // JRouter().go(SUB_PLAY_LIST, arguments: maps);


                              if (isHorizontalVideo(
                                  resolutionWidth(state.selectedTagsData
                                      .xList[index].resolution),
                                  resolutionHeight(state.selectedTagsData
                                      .xList[index].resolution))) {
                                VideoModel viewModel = VideoModel.fromJson(state.selectedTagsData
                                    .xList[index].toJson());
                                Gets.Get.to(VideoPage(viewModel),opaque: false);
                              } else {
                                Gets.Get.to(SubPlayListPage().buildPage(maps),
                                    opaque: false);
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
                                        CachedNetworkImage(
                                          imageUrl: state.selectedTagsData
                                              .xList[index].cover,
                                          fit: BoxFit.cover,
                                          memCacheHeight: 600,
                                          cacheManager: ImageCacheManager(),
                                          fadeInCurve: Curves.linear,
                                          fadeOutCurve: Curves.linear,
                                          fadeInDuration:
                                              Duration(milliseconds: 100),
                                          fadeOutDuration:
                                              Duration(milliseconds: 100),
                                          /*placeholder: (context, url) {
                                            return placeHolder(ImgType.cover,
                                                null, Dimens.pt280);
                                          },*/
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
                                                MainAxisAlignment.spaceBetween,
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
                                                    state
                                                                .selectedTagsData
                                                                .xList[index]
                                                                .playCount >
                                                            10000
                                                        ? (state
                                                                        .selectedTagsData
                                                                        .xList[
                                                                            index]
                                                                        .playCount /
                                                                    10000)
                                                                .toStringAsFixed(
                                                                    1) +
                                                            "w"
                                                        : state
                                                            .selectedTagsData
                                                            .xList[index]
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
                                                TimeHelper.getTimeText(state
                                                    .selectedTagsData
                                                    .xList[index]
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
                                            visible: state
                                                            .selectedTagsData
                                                            .xList[index]
                                                            .originCoins !=
                                                        null &&
                                                    state
                                                            .selectedTagsData
                                                            .xList[index]
                                                            .originCoins !=
                                                        0
                                                ? true
                                                : false,
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    //height: Dimens.pt20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(4)),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromRGBO(
                                                              245, 22, 78, 1),
                                                          Color.fromRGBO(
                                                              255, 101, 56, 1),
                                                          Color.fromRGBO(
                                                              245, 68, 4, 1),
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.only(
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
                                                                width:
                                                                    Dimens.pt12,
                                                                height:
                                                                    Dimens.pt12)
                                                            .load(),
                                                        SizedBox(
                                                            width: Dimens.pt4),
                                                        Text(
                                                            state
                                                                .selectedTagsData
                                                                .xList[index]
                                                                .originCoins
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .textColorWhite,
                                                              fontSize:
                                                                  Dimens.pt12,
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
                                            visible: state
                                                        .selectedTagsData
                                                        .xList[index]
                                                        .originCoins ==
                                                    0
                                                ? true
                                                : false,
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    //height: Dimens.pt20,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(4)),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromRGBO(
                                                              245, 22, 78, 1),
                                                          Color.fromRGBO(
                                                              255, 101, 56, 1),
                                                          Color.fromRGBO(
                                                              245, 68, 4, 1),
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.only(
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
                                                            color: Colors.white,
                                                            fontSize:
                                                                Dimens.pt12,
                                                          ),
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
                                      state.selectedTagsData.xList[index].title,
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
                                            imageUrl: state
                                                .selectedTagsData
                                                .xList[index]
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
                                            state.selectedTagsData.xList[index]
                                                .publisher.name,
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
                                          state.selectedTagsData.xList[index]
                                                      .likeCount >
                                                  10000
                                              ? (state
                                                              .selectedTagsData
                                                              .xList[index]
                                                              .likeCount /
                                                          10000)
                                                      .toStringAsFixed(1) +
                                                  "w"
                                              : state.selectedTagsData
                                                  .xList[index].likeCount
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
                        }),
                      ),
                    ),
            ],
          ),
        ),
      ),
    ),
    //   child: Stack(
    //     children: <Widget>[
    //       isHaveData
    //           ? EasyRefresh.custom(
    //               controller: state.refreshController,
    //               header: state.header,
    //               footer: state.footer,
    //               slivers: [
    //                 SliverList(
    //                   delegate: SliverChildBuilderDelegate(
    //                     adapter.itemBuilder,
    //                     childCount: adapter.itemCount,
    //                   ),
    //                 ),
    //               ],
    //               onRefresh: () async {
    //                 await dispatch(CommonPostActionCreator.onInit());
    //               },
    //               onLoad: () async {
    //                 await dispatch(CommonPostActionCreator.onLoadMore());
    //               },
    //             )
    //           : Container(),

    //       //加载动画
    //       Offstage(
    //         offstage: state.requestComplete ? true : false,
    //         child: Center(child: LoadingWidget()),
    //       ),

    //       //空页面
    //       Offstage(
    //         offstage: state.dataIsNormal ? true : false,
    //         child: InkResponse(
    //           child: Container(
    //               width: Dimens.pt360, child: CErrorWidget(state.errorMsg)),
    //           onTap: () {
    //             dispatch(CommonPostActionCreator.reLoadData());
    //             //loadData
    //             dispatch(CommonPostActionCreator.onInit());
    //           },
    //         ),
    //       )
    //     ],
    //   ),
  );
}
