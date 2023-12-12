import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/action.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_app/widget/vertical_tabs.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:octo_image/octo_image.dart';
import '../../ads_banner_widget.dart';
import 'action.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:path/path.dart' as path;

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

  Widget tabsContent(String caption, [String description = '']) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Text(
            caption,
            style: TextStyle(fontSize: 25),
          ),
          Divider(
            height: 20,
            color: Colors.black45,
          ),
          Text(
            description,
            style: TextStyle(fontSize: 15, color: Colors.black87),
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
    child: Container(
      color: AppColors.primaryColor,
      margin: EdgeInsets.only(
        top: Dimens.pt10,
      ),
      child: Column(
        children: [
          Offstage(
            offstage: state.adsList == null || state.adsList.length == 0
                ? true
                : false,
            child: Container(
              padding: EdgeInsets.only(
                  left: Dimens.pt16, right: Dimens.pt16, top: Dimens.pt6),
              child: bannerWidget,
            ),
          ),
          SizedBox(
            height: Dimens.pt10,
          ),
          state.tagDetailList.length == 0
              ? Container(
                  margin: EdgeInsets.only(top: Dimens.pt160),
                  alignment: Alignment.center,
                  child: LoadingWidget())
              : Expanded(
                  child: VerticalTabs(
                    tabsWidth: Dimens.pt80,
                    indicatorWidth: Dimens.pt3,
                    backgroundColor: Colors.white,
                    selectedTabBackgroundColor: Colors.black,
                    tabBackgroundColor: Color.fromRGBO(51, 51, 51, 1),
                    indicatorColor: Color.fromRGBO(253, 88, 60, 1),
                    tabTextStyle: TextStyle(
                        color:
                            Color.fromRGBO(255, 255, 255, 1).withOpacity(0.8),
                        fontSize: Dimens.pt14,
                        fontWeight: FontWeight.w600),
                    selectedTabTextStyle: TextStyle(
                        color: Color.fromRGBO(253, 88, 60, 1),
                        fontSize: Dimens.pt14,
                        fontWeight: FontWeight.w600),
                    tabs: state.tags.tags.map((e) {
                      return Tab(
                          child: Container(
                              height: Dimens.pt24,
                              alignment: Alignment.center,
                              child: Text(e.tagName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt14,
                                      fontWeight: FontWeight.w600))));
                    }).toList(),
                    contents: state.tagDetailList.map((e) {
                      return MediaQuery.removePadding(
                        removeTop: true,
                        context: viewService.context,
                        child: Container(
                          color: AppColors.primaryColor,
                          //height: 1200,
                          padding: EdgeInsets.only(
                              left: Dimens.pt6, right: Dimens.pt10),
                          child: pullYsRefresh(
                            refreshController: e.refreshController,
                            enablePullDown: false,
                            onLoading: () {
                              e.pageNum += 1;

                              dispatch(CommonPostActionCreator.onLoadMore(e));
                            },
                            onRefresh: () {
                              //e.pageNum += 1;
                              //dispatch(CommonPostActionCreator.onLoadMore(e));
                            },
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1.24),
                              itemCount: e.list.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Map<String, dynamic> maps = Map();
                                    maps['pageNumber'] = 1;
                                    maps['pageSize'] = 3;
                                    maps['currentPosition'] = index;
                                    maps['videoList'] = e.list;
                                    maps['tagID'] = state.tags.tags[0].id;
                                    maps['playType'] =
                                        VideoPlayConfig.VIDEO_TAG;
                                    if (isHorizontalVideo(
                                        resolutionWidth(e.list[index].resolution),
                                        resolutionHeight(e.list[index].resolution))) {


                                      VideoModel viewModel = VideoModel.fromJson(e.list[index].toJson());
                                      Gets.Get.to(() =>VideoPage(viewModel),opaque: false);

                                    } else {
                                      Gets.Get.to(() =>SubPlayListPage().buildPage(maps),
                                          opaque: false);
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

                                            /*CustomNetworkImage(
                                              imageUrl: e.list[index].cover,
                                              type: ImgType.cover,
                                              height: Dimens.pt84,
                                              fit: BoxFit.cover,
                                            ),*/

                                            CachedNetworkImage(
                                              imageUrl: path.join(
                                                  Address.baseImagePath ?? '',
                                                  e.list[index].cover),
                                              fit: BoxFit.cover,
                                              height: Dimens.pt84,
                                              cacheManager: ImageCacheManager(),
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
                                                    left: Dimens.pt10,
                                                    right: Dimens.pt10,
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
                                                          e.list[index]
                                                                      .playCount >
                                                                  10000
                                                              ? (e.list[index].playCount /
                                                                          10000)
                                                                      .toStringAsFixed(
                                                                          1) +
                                                                  "w"
                                                              : e.list[index]
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
                                                      TimeHelper.getTimeText(e
                                                          .list[index].playTime
                                                          .toDouble()),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              Dimens.pt10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                top: -1,
                                                right: -1,
                                                child: Visibility(
                                                  visible: e.list[index]
                                                                  .originCoins !=
                                                              null &&
                                                          e.list[index]
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
                                                            //color: Color.fromRGBO(255, 0, 169, 1),
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
                                                                  e.list[index]
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
                                                  visible: e.list[index]
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
                                            e.list[index].title,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt12),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onSelect: (index) {
                      dispatch(CommonPostActionCreator.onTagClicks(index));
                    },
                  ),
                ),
        ],
      ),
    ),
  );
}
