import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
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
import 'package:popup_window/popup_window.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:get/route_manager.dart' as Gets;
import 'common_post_detail_action.dart';
import 'common_post_detail_state.dart';

Widget buildView(
    common_post_detailState state, Dispatch dispatch, ViewService viewService) {
  int getPlayTimeType() {
    if (state.selectedType == "全部类型") {
      return 0;
    } else if (state.selectedType == "长视频") {
      return 1;
    } else if (state.selectedType == "短视频") {
      return 2;
    }
  }

  String getModel() {
    if (state.selectedSort == "热门推荐") {
      return "hot";
    } else if (state.selectedSort == "最多播放") {
      return "wathch";
    } else if (state.selectedSort == "收藏最多") {
      return "like";
    } else if (state.selectedSort == "最新上架") {
      return "new";
    }
  }

  return Scaffold(
      appBar: AppBar(
        title: Text(
          state.title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupWindowButton(
            offset: Offset(0, 200),
            buttonBuilder: (BuildContext context) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: Dimens.pt13),
                child: Text(
                  "筛选",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
            windowBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: Material(
                    child: Container(
                      color: Colors.black,
                      height: 160,
                      child: StatefulBuilder(
                        builder: (contexts, setStates) {
                          return Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                color: AppColors.primaryColor,
                                child: ChipsChoice<String>.single(
                                  wrapped: true,
                                  spacing: 3,
                                  runSpacing: 2,
                                  value: state.selectedType,
                                  onChanged: (val) {
                                    state.selectedType = val;
                                    setStates(() {
                                      state.pageNumber = 1;
                                      state.selectedBean.pageNumber = 1;
                                      state.selectedBean.sortType = getModel();
                                      state.selectedBean.playTimeType =
                                          getPlayTimeType();
                                      state.selectedBean.isSelected = true;
                                      dispatch(common_post_detailActionCreator
                                          .onSelectedData(state.selectedBean));
                                    });
                                  },
                                  choiceItems:
                                      C2Choice.listFrom<String, String>(
                                    source: state.typeOptions,
                                    value: (i, v) => v,
                                    label: (i, v) => v,
                                  ),
                                  choiceStyle: C2ChoiceStyle(
                                    color: Colors.black,
                                    showCheckmark: false,
                                    avatarBorderColor: Colors.black,
                                    brightness: Brightness.dark,
                                    borderColor: Colors.black,
                                    borderWidth: 0,
                                    labelStyle: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Colors.white),
                                  ),
                                  choiceActiveStyle: C2ChoiceStyle(
                                    color: Colors.red,
                                    borderColor: Colors.red,
                                    showCheckmark: false,
                                    disabledColor: Colors.red,
                                    brightness: Brightness.dark,
                                    labelStyle: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: ChipsChoice<String>.single(
                                  wrapped: true,
                                  spacing: 3,
                                  value: state.selectedSort,
                                  onChanged: (val) {
                                    state.selectedSort = val;
                                    setStates(() {
                                      state.pageNumber = 1;
                                      state.selectedBean.pageNumber = 1;
                                      state.selectedBean.sortType = getModel();
                                      state.selectedBean.playTimeType =
                                          getPlayTimeType();
                                      state.selectedBean.isSelected = true;
                                      dispatch(common_post_detailActionCreator
                                          .onSelectedData(state.selectedBean));
                                    });
                                  },
                                  choiceItems:
                                      C2Choice.listFrom<String, String>(
                                    source: state.sortOptions,
                                    value: (i, v) => v,
                                    label: (i, v) => v,
                                  ),
                                  choiceStyle: C2ChoiceStyle(
                                    color: Colors.black,
                                    brightness: Brightness.dark,
                                    showCheckmark: false,
                                    borderColor: Colors.black,
                                    borderWidth: 0,
                                    labelStyle: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Colors.white),
                                  ),
                                  choiceActiveStyle: C2ChoiceStyle(
                                    color: Colors.red,
                                    borderColor: Colors.red,
                                    showCheckmark: false,
                                    disabledColor: Colors.red,
                                    brightness: Brightness.dark,
                                    labelStyle: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            onWindowShow: () {
              print('PopupWindowButton window show');
            },
            onWindowDismiss: () {
              print('PopupWindowButton window dismiss');
            },
          ),
        ],
      ),
      backgroundColor: AppColors.primaryColor,
      body: state.liaoBaHistoryData == null
          ? Center(
              child: LoadingWidget(),
            )
          : state.liaoBaHistoryData.videos.length == 0 ||
                  state.liaoBaHistoryData.videos == null
              ? Center(
                  child: CErrorWidget(
                    Lang.EMPTY_DATA,
                    retryOnTap: () {
                      dispatch(common_post_detailActionCreator.onAction());
                    },
                  ),
                )
              : pullYsRefresh(
        refreshController: state.refreshController,
        onLoading: () {
          state.pageNumber += 1;

          state.selectedBean.pageNumber = state.pageNumber;
          state.selectedBean.sortType = getModel();
          state.selectedBean.playTimeType = getPlayTimeType();
          state.selectedBean.isSelected = true;
          dispatch(common_post_detailActionCreator
              .onSelectedData(state.selectedBean));
        },
        onRefresh: () {
          // dispatch(HistoryActionCreator.onLoadMore(state.pageNumber = 1 ));
        },
        enablePullDown: false,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: state.liaoBaHistoryData.videos.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                List<VideoModel> lists = [];

                state.liaoBaHistoryData.videos.forEach((element) {
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
                                      .videos[index].cover,
                                  true,
                                  false),
                              fit: BoxFit.cover,
                              memCacheHeight: 600,
                              cacheManager: ImageCacheManager(),
                              fadeInCurve: Curves.linear,
                              fadeOutCurve: Curves.linear,
                              fadeInDuration: Duration(milliseconds: 100),
                              fadeOutDuration: Duration(milliseconds: 100),
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
                                            .videos[index]
                                            .playCount >
                                            10000
                                            ? (state
                                            .liaoBaHistoryData
                                            .videos[
                                        index]
                                            .playCount /
                                            10000)
                                            .toStringAsFixed(
                                            1) +
                                            "w"
                                            : state
                                            .liaoBaHistoryData
                                            .videos[index]
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
                                        .videos[index]
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
                                    .videos[index]
                                    .originCoins !=
                                    null &&
                                    state
                                        .liaoBaHistoryData
                                        .videos[index]
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
                                                    .videos[index]
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
                                    .videos[index]
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
                          state.liaoBaHistoryData.videos[index]
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
                                    .videos[index]
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
                                    .videos[index].publisher.name,
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
                              state.liaoBaHistoryData.videos[index]
                                  .likeCount >
                                  10000
                                  ? (state
                                  .liaoBaHistoryData
                                  .videos[index]
                                  .likeCount /
                                  10000)
                                  .toStringAsFixed(1) +
                                  "w"
                                  : state.liaoBaHistoryData
                                  .videos[index].likeCount
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
