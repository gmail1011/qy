import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
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
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/page.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
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
import 'package:popup_window/popup_window.dart';
import '../../MySliverDelegate.dart';
import '../../ads_banner_widget.dart';
import 'action.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

Widget buildView(
    CommonPostTagsState state, Dispatch dispatch, ViewService viewService) {
  // bool isHaveData = (state.dayItems?.length ?? 0) > 0;

  int getPlayTimeType() {
    if (state.selectedType == "全部类型") {
      return 0;
    } else if (state.selectedType == "长视频") {
      return 1;
    } else if (state.selectedType == "短视频") {
      return 2;
    }
  }

  int getModel() {
    if (state.selectedSort == "最多播放") {
      return 7;
    } else if (state.selectedSort == "点赞最多") {
      return 6;
    } else if (state.selectedSort == "最新上架") {
      return 1;
    } else if (state.selectedSort == "热门推荐") {
      return 2;
    } else {
      return 2;
    }
  }

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
    return Container(
      padding: EdgeInsets.only(
          left: Dimens.pt12,
          //top: appMainTop,
          right: Dimens.pt12,
          bottom: AppPaddings.appMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          item.originalBloggerInfo.uid == 0
              ? GestureDetector(
                  onTap: () {
                    Map<String, dynamic> maps = Map();
                    maps['tagId'] = item.sectionID;
                    maps['title'] = item.sectionName;
                    Gets.Get.to(LiaoBaTagDetailPage().buildPage(maps),
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
                          width: Dimens.pt224,
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
                          // margin: EdgeInsets.only(right: Dimens.pt10),
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
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          //dispatch(CommonPostActionCreator.onTagClick(item));

                          Map<String, dynamic> arguments = {
                            'uid': item.originalBloggerInfo.uid,
                            'uniqueId': DateTime.now().toIso8601String(),
                            // KEY_VIDEO_LIST_TYPE: VideoListType.NONE
                          };

                          Gets.Get.to(
                              VideoUserCenterPage().buildPage(arguments),
                              opaque: false);

                          autoPlayModel.startAvailblePlayer();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                            top: Dimens.pt6,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                //margin: EdgeInsets.only(left: 15),
                                child: ClipOval(
                                  child: CustomNetworkImage(
                                    height: Dimens.pt46,
                                    width: Dimens.pt46,
                                    fit: BoxFit.cover,
                                    imageUrl: item.originalBloggerInfo.portrait,
                                  ),
                                ),
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.originalBloggerInfo.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppFontSize.fontSize16,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: Dimens.pt10,
                                      ),

                                      /*GestureDetector(
                                        onTap: () async{
                                          await netManager.client.getFollow(item.originalBloggerInfo.uid, item.hasFollowed);
                                        },
                                        child: StatefulBuilder(
                                          builder: (context,setState){
                                            return Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.only(left: Dimens.pt14,right: Dimens.pt14,top: Dimens.pt3,bottom: Dimens.pt3,),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(201, 115, 255, 1),
                                                      Color.fromRGBO(246, 168, 225, 1),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter),
                                              ),
                                              child: Text(
                                                "关注",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: AppFontSize.fontSize12,
                                                    fontWeight: FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                      ),*/

                                      SizedBox(
                                        width: Dimens.pt10,
                                      ),
                                      Offstage(
                                        offstage: item.originalBloggerInfo
                                                .officialCert
                                            ? false
                                            : true,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: Color.fromRGBO(
                                                252, 199, 119, 1),
                                          ),
                                          padding: EdgeInsets.all(1),
                                          child: Text(
                                            "证",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppFontSize.fontSize12,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Dimens.pt200,
                                    child: Text(
                                      (item.originalBloggerInfo.summary),
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: AppFontSize.fontSize12,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: Dimens.pt10,
                              ),
                              Spacer(),
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
                                //margin: EdgeInsets.only(right: Dimens.pt10),
                                child: Row(
                                  children: [
                                    /*Text(
                                    Lang.MORE,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFontSize.fontSize10),
                                  ),*/
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
          Container(
            height: item.videoInfo.length <= 2 ? Dimens.pt130 : Dimens.pt260,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: viewService.context,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 1.30),
                itemCount: item.videoInfo.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      List<VideoModel> lists = [];

                      item.videoInfo.forEach((element) {
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
                      if (isHorizontalVideo(
                          resolutionWidth(lists[index].resolution),
                          resolutionHeight(lists[index].resolution))) {
                        Gets.Get.to(VideoPage(lists[index]),opaque: false);
                      } else {
                        Gets.Get.to(SubPlayListPage().buildPage(maps), opaque: false);
                      }
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [

                              KeepAliveWidget(
                                CustomNetworkImage(
                                  imageUrl: item.videoInfo[index].cover,
                                  type: ImgType.cover,
                                  height: Dimens.pt100,
                                  fit: BoxFit.cover,
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
                                            item.videoInfo[index].playCount >
                                                    10000
                                                ? (item.videoInfo[index]
                                                                .playCount /
                                                            10000)
                                                        .toStringAsFixed(1) +
                                                    "w"
                                                : item
                                                    .videoInfo[index].playCount
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
                                            .videoInfo[index].playTime
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
                                    visible: item.videoInfo[index]
                                                    .originCoins !=
                                                null &&
                                            item.videoInfo[index].originCoins !=
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
                                                    item.videoInfo[index]
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
                                        item.videoInfo[index].originCoins == 0
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
                              item.videoInfo[index].title,
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

          /*Container(
           height: Dimens.pt140,
           child: Row(
             children: [
                Container(
                  //width: Dimens.pt130,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CustomNetworkImage(
                          imageUrl: list[1].cover,
                          type: ImgType.cover,
                          height: Dimens.pt180,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Text(list[1].title,style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),

               SizedBox(
                 width: Dimens.pt8,
               ),


               Container(
                 //width: Dimens.pt130,
                 child: Column(
                   children: [
                     ClipRRect(
                       borderRadius: BorderRadius.circular(10.0),
                       child: CustomNetworkImage(
                         imageUrl: list[1].cover,
                         type: ImgType.cover,
                         height: Dimens.pt180,
                         fit: BoxFit.cover,
                       ),
                     ),

                     Text(list[1].title,style: TextStyle(color: Colors.white),),
                   ],
                 ),
               ),
             ],
           ),
         ),*/
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
    child: Container(
      color: AppColors.primaryColor,
      child: pullYsRefresh(
        refreshController: state.refreshController,
        enablePullDown: false,
        onLoading: () {
          //dispatch(CommonPostActionCreator.onLoadMore(state.pageNumber += 1));

          if (Config.homeDataTags[state.index].subModuleName.contains("原创")) {
            dispatch(CommonPostActionCreator.onLoadMore(state.pageNumber += 1));
          } else {
            state.pageNumber = 1;
            state.selectedBean.pageNumber += 1;
            state.selectedBean.type = 0;
            state.selectedBean.model = 1;
            state.selectedBean.isSelected = true;
            state.selectedBean.paymentType = 0;

            Config.tagsLiaoBaData.tags.forEach((element) {
              if (element.tagName.contains(Config.homeDataTags[state.index].subModuleName)) {
                state.selectedBean.tag = element.id;
              }
            });

            if(Config.homeDataTags[state.index].subModuleName.contains("福利姬")){
              state.selectedBean.tag = "5e184177df069c1e6ea856f4";
            }

            if(Config.homeDataTags[state.index].subModuleName.contains("SWAG")){
              state.selectedBean.tag = "6253dd7bd4ee984086fbecb1";
            }

            if (Config.homeDataTags[state.index].subModuleName.contains("日韩")) {
              state.selectedBean.tag = "5f00cf5f84b09831ae63826a";
            }

            dispatch(
                CommonPostActionCreator.onSelectedBean(state.selectedBean));
          }
        },
        onRefresh: () {
          dispatch(CommonPostActionCreator.onInit());
        },
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
            SliverToBoxAdapter(
              child: SizedBox(
                height: Dimens.pt10,
              ),
            ),
            state.tagsDetails.length == 0
                ? SliverToBoxAdapter(
                    child: Container(
                    margin: EdgeInsets.only(top: Dimens.pt160),
                    alignment: Alignment.center,
                    child: LoadingWidget(),
                  ))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return itemView(
                          state.tagsDetails[index], dispatch, viewService);
                    }, childCount: state.tagsDetails.length),
                  ),
            Config.homeDataTags[state.index].subModuleName.contains("原创")
                ? SliverToBoxAdapter(
                    child: Container(),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(
                        left: Dimens.pt10,
                        right: Dimens.pt10,
                        bottom: Dimens.pt6),
                    sliver: SliverPersistentHeader(
                      pinned: true,
                      delegate: MySliverDelegate(
                        maxHeight: Dimens.pt40,
                        minHeight: Dimens.pt40,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.only(
                                top: Dimens.pt6, left: Dimens.pt6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  //width: Dimens.pt220,
                                  child: Text(
                                    Config.homeDataTags[state.index].subModuleName +
                                        "精品 - 每日更新",
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
            Config.homeDataTags[state.index].subModuleName.contains("原创")
                ? SliverToBoxAdapter(
                    child: Container(),
                  )
                : state.selectedTagsData == null
                    ? SliverToBoxAdapter(child: Container())
                    : state.selectedTagsData.xList == null
                        ? SliverToBoxAdapter(
                            child: CErrorWidget(
                            Lang.EMPTY_DATA,
                            retryOnTap: () {
                              //dispatch(HistoryActionCreator.onAction());
                            },
                          ))
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

                                    state.selectedTagsData.xList
                                        .forEach((element) {
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
                                    maps['playType'] =
                                        VideoPlayConfig.VIDEO_TAG;
                                    // JRouter().go(SUB_PLAY_LIST, arguments: maps);

                                    if (isHorizontalVideo(
                                        resolutionWidth(lists[index].resolution),
                                        resolutionHeight(lists[index].resolution))) {
                                      Gets.Get.to(VideoPage(lists[index]),opaque: false);
                                    } else {
                                      Gets.Get.to(SubPlayListPage().buildPage(maps), opaque: false);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                                fadeInDuration: Duration(milliseconds: 100),
                                                fadeOutDuration: Duration(milliseconds: 100),
                                                /*placeholder: (context, url) {
                                                  return placeHolder(
                                                      ImgType.cover,
                                                      null,
                                                      Dimens.pt280);
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
                                                    begin:
                                                        Alignment.bottomCenter,
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
                                                            height:
                                                                Dimens.pt11),
                                                        SizedBox(
                                                          width: Dimens.pt4,
                                                        ),
                                                        Text(
                                                          state
                                                                      .selectedTagsData
                                                                      .xList[
                                                                          index]
                                                                      .playCount >
                                                                  10000
                                                              ? (state.selectedTagsData.xList[index].playCount /
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
                                                            fontSize:
                                                                Dimens.pt12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      TimeHelper.getTimeText(
                                                          state
                                                              .selectedTagsData
                                                              .xList[index]
                                                              .playTime
                                                              .toDouble()),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              Dimens.pt12),
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
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          //height: Dimens.pt20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
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
                                                                  width: Dimens
                                                                      .pt4),
                                                              Text(
                                                                  state
                                                                      .selectedTagsData
                                                                      .xList[
                                                                          index]
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
                                                  visible: state
                                                              .selectedTagsData
                                                              .xList[index]
                                                              .originCoins ==
                                                          0
                                                      ? true
                                                      : false,
                                                  child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          //height: Dimens.pt20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      Dimens
                                                                          .pt12,
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
                                            state.selectedTagsData.xList[index]
                                                .title,
                                            maxLines: 1,
                                            style:
                                                TextStyle(color: Colors.white),
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
                                                  state
                                                      .selectedTagsData
                                                      .xList[index]
                                                      .publisher
                                                      .name,
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
                                                state
                                                            .selectedTagsData
                                                            .xList[index]
                                                            .likeCount >
                                                        10000
                                                    ? (state
                                                                    .selectedTagsData
                                                                    .xList[
                                                                        index]
                                                                    .likeCount /
                                                                10000)
                                                            .toStringAsFixed(
                                                                1) +
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

            /*state.selectedTagsData == null || state.isLoading
                  ? SliverToBoxAdapter(
                child: Center(
                  child: LoadingWidget(),
                ),
              )
                  : state.selectedTagsData.xList == null
                  ? SliverToBoxAdapter(
                child: Center(
                  child: CErrorWidget(
                    Lang.EMPTY_DATA,
                    retryOnTap: () {
                      state.pageNumber = 1;
                      state.selectedBean.pageNumber = 1;
                      state.selectedBean.type = getPlayTimeType();
                      state.selectedBean.model = getModel();
                      state.selectedBean.tag = Config.dataTags[state.index].id;
                      state.selectedBean.isSelected = true;
                      state.selectedBean.paymentType = 0;
                      dispatch(CommonPostActionCreator.onSelectedBean(state.selectedBean));
                    },
                  ),
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
                    return FrameSeparateWidget(
                      index: index,
                      child: GestureDetector(
                        onTap: () {
                          List<VideoModel> lists = [];

                          state.selectedTagsData.xList
                              .forEach((element) {
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
                          maps['playType'] =
                              VideoPlayConfig.VIDEO_TAG;
                          // JRouter().go(SUB_PLAY_LIST, arguments: maps);

                          Gets.Get.to(SubPlayListPage().buildPage(maps),opaque: false);
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10.0),
                              child: Stack(
                                alignment:
                                AlignmentDirectional.bottomCenter,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: state.selectedTagsData
                                        .xList[index].cover,
                                    fit: BoxFit.cover,
                                    cacheManager: ImageCacheManager(),
                                    placeholder: (context, url) {
                                      return placeHolder(ImgType.cover,
                                          null, Dimens.pt280);
                                    },
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
                                          begin:
                                          Alignment.bottomCenter,
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
                                                  height:
                                                  Dimens.pt11),
                                              SizedBox(
                                                width: Dimens.pt4,
                                              ),
                                              Text(
                                                state
                                                    .selectedTagsData
                                                    .xList[
                                                index]
                                                    .playCount >
                                                    10000
                                                    ? (state.selectedTagsData.xList[index].playCount /
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
                                                  fontSize:
                                                  Dimens.pt12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            TimeHelper.getTimeText(
                                                state
                                                    .selectedTagsData
                                                    .xList[index]
                                                    .playTime
                                                    .toDouble()),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                Dimens.pt12),
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
                                            alignment:
                                            Alignment.center,
                                            children: [
                                              Container(
                                                //height: Dimens.pt20,
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomLeft:
                                                      Radius.circular(
                                                          4)),
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
                                                        width: Dimens
                                                            .pt4),
                                                    Text(
                                                        state
                                                            .selectedTagsData
                                                            .xList[
                                                        index]
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
                                        visible: state
                                            .selectedTagsData
                                            .xList[index]
                                            .originCoins == 0
                                            ? true
                                            : false,
                                        child: Stack(
                                            alignment:
                                            Alignment.center,
                                            children: [
                                              Container(
                                                //height: Dimens.pt20,
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomLeft:
                                                      Radius.circular(
                                                          4)),
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
                                  state.selectedTagsData.xList[index]
                                      .title,
                                  maxLines: 1,
                                  style:
                                  TextStyle(color: Colors.white),
                                )),

                            SizedBox(
                              height: Dimens.pt4,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        state
                                            .selectedTagsData
                                            .xList[index]
                                            .publisher
                                            .name,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white, fontSize:
                                        Dimens
                                            .pt10,),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      state
                                          .selectedTagsData
                                          .xList[index]
                                          .likeCount >
                                          10000
                                          ? (state
                                          .selectedTagsData
                                          .xList[
                                      index]
                                          .likeCount /
                                          10000)
                                          .toStringAsFixed(
                                          1) +
                                          "w"
                                          : state.selectedTagsData
                                          .xList[index].likeCount
                                          .toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white, fontSize:
                                      Dimens
                                          .pt10,),
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
                      ),
                    );
                  }),
                ),
              ),*/
          ],
        ),
      ),
    ),
  );
}
