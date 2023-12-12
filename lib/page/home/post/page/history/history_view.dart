import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:get/route_manager.dart';

import 'history_action.dart';
import 'history_state.dart';

Widget buildView(
    HistoryState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: CustomAppbar(
      title: "观看历史",
    ),
    backgroundColor: AppColors.primaryColor,
      body: state.liaoBaHistoryData == null
          ? Center(
        child: LoadingWidget(),
      )
          : state.liaoBaHistoryData.workList.length == 0 ||
          state.liaoBaHistoryData.workList == null
          ? Center(
        child: CErrorWidget(
          Lang.EMPTY_DATA,
          retryOnTap: () {
            dispatch(HistoryActionCreator.onAction());
          },
        ),
      )
          : pullYsRefresh(
        refreshController: state.refreshController,
        onLoading: () {
          dispatch(HistoryActionCreator.onLoadMore(state.pageNumber += 1));
        },
        onRefresh: () {
          // dispatch(HistoryActionCreator.onLoadMore(state.pageNumber = 1 ));
        },
        enablePullDown: false,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: state.liaoBaHistoryData.workList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                List<VideoModel> lists = [];

                state.liaoBaHistoryData.workList.forEach((element) {
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
                  Gets.Get.to(() =>VideoPage(lists[index]),opaque: false);
                } else {
                  Gets.Get.to(() =>SubPlayListPage().buildPage(maps), opaque: false);
                }

              },
              child: Container(
                margin: EdgeInsets.only(
                  left: Dimens.pt2,
                  right: Dimens.pt2,
                ),
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
                              imageUrl: getImagePath(
                                  state.liaoBaHistoryData
                                      .workList[index].cover,
                                  true,
                                  false),
                              fit: BoxFit.cover,
                              memCacheHeight: 600,
                              cacheManager: ImageCacheManager(),
                              fadeInCurve: Curves.linear,
                              fadeOutCurve: Curves.linear,
                              fadeInDuration: Duration(milliseconds: 100),
                              fadeOutDuration: Duration(milliseconds: 100),
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
                                            .liaoBaHistoryData
                                            .workList[index]
                                            .playCount >
                                            10000
                                            ? (state
                                            .liaoBaHistoryData
                                            .workList[
                                        index]
                                            .playCount /
                                            10000)
                                            .toStringAsFixed(
                                            1) +
                                            "w"
                                            : state
                                            .liaoBaHistoryData
                                            .workList[index]
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
                                        .liaoBaHistoryData
                                        .workList[index]
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
                                    .liaoBaHistoryData
                                    .workList[index]
                                    .originCoins !=
                                    null &&
                                    state
                                        .liaoBaHistoryData
                                        .workList[index]
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
                                                    .liaoBaHistoryData
                                                    .workList[index]
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
                                    .liaoBaHistoryData
                                    .workList[index]
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
                                          //color: Color.fromRGBO(255, 0, 169, 1),
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
                                                  color:
                                                  Colors.white),
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
                          state.liaoBaHistoryData.workList[index]
                              .title,
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
                                    .liaoBaHistoryData
                                    .workList[index]
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
                                state.liaoBaHistoryData
                                    .workList[index].publisher.name,
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
                              state.liaoBaHistoryData.workList[index]
                                  .likeCount >
                                  10000
                                  ? (state
                                  .liaoBaHistoryData
                                  .workList[index]
                                  .likeCount /
                                  10000)
                                  .toStringAsFixed(1) +
                                  "w"
                                  : state.liaoBaHistoryData
                                  .workList[index].likeCount
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
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(2),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
  );
}
