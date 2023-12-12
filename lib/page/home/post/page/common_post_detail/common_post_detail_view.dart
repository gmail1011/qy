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
import 'package:flutter_app/page/home/post/page/common_post_detail/SelectedTagsBean.dart';
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
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart' as Gets;
import 'common_post_detail_action.dart';
import 'common_post_detail_state.dart';

Widget buildView(
    CommonPostDetailState state, Dispatch dispatch, ViewService viewService) {
  int getType() {
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
    }else if (state.selectedSort == "热门推荐") {
      return 2;
    }
  }

  int getPayType() {
    if (state.selectedVipGold == "付费类型") {
      return 0;
    } else if (state.selectedVipGold == "VIP") {
      return 1;
    } else if (state.selectedVipGold == "金币") {
      return 2;
    }
  }

  return Scaffold(
    appBar: CustomAppbar(
      title: "所有分类",
    ),
    backgroundColor: AppColors.primaryColor,
    body: BaseRequestView(
      retryOnTap: () {
        dispatch(CommonPostDetailActionCreator.onAction());
      },
      controller: state.baseRequestController,
      child: pullYsRefresh(
        refreshController: state.refreshController,
        enablePullDown: false,
        onLoading: () {
          state.selectedTagsBean.pageNumber += 1;
          state.selectedTagsBean.type = getType();
          state.selectedTagsBean.model = getModel();
          state.selectedTagsBean.paymentType = getPayType();
          state.selectedTagsBean.isSelected = false;

          state.specialModel.tags.forEach((element) {
            if(state.selectedTags == "全部标签"){
              state.selectedTagsBean.tag = "";
            }else{
              if(element.tagName == state.selectedTags){
                state.selectedTagsBean.tag = element.id;
              }
            }
          });



          dispatch(
              CommonPostDetailActionCreator.loadMore(state.selectedTagsBean));
        },
        onRefresh: () {
          state.selectedTagsBean.pageNumber = 1;
          state.selectedTagsBean.type = getType();
          state.selectedTagsBean.model = getModel();
          state.selectedTagsBean.isSelected = false;
          state.selectedTagsBean.paymentType = getPayType();
          state.specialModel.tags.forEach((element) {
            if(state.selectedTags == "全部标签"){
              state.selectedTagsBean.tag = "";
            }else{
              if(element.tagName == state.selectedTags){
                state.selectedTagsBean.tag = element.id;
              }
            }
          });
          dispatch(
              CommonPostDetailActionCreator.loadMore(state.selectedTagsBean));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              //floating: true,
              // snap: true,
              pinned: false,
              // stretch: true,
              automaticallyImplyLeading: false,
              expandedHeight: Dimens.pt280,
              flexibleSpace: FlexibleSpaceBar(
                // title: contain,
                background: StatefulBuilder(
                  builder: (contexts, setStates) {
                    return Container(
                      width: Dimens.pt290,
                      color: AppColors.primaryColor,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              color: AppColors.primaryColor,
                              child: ChipsChoice<String>.single(
                                wrapped: true,
                                spacing: 3,
                                value: state.selectedType,
                                onChanged: (val) {
                                  state.selectedType = val;
                                  setStates(() {
                                    state.selectedTagsBean.pageNumber = 1;
                                    state.selectedTagsBean.type = getType();
                                    state.selectedTagsBean.model = getModel();
                                    state.selectedTagsBean.paymentType =
                                        getPayType();
                                    state.selectedTagsBean.isSelected = true;
                                    state.specialModel.tags.forEach((element) {
                                      if(state.selectedTags == "全部标签"){
                                        state.selectedTagsBean.tag = "";
                                      }else{
                                        if(element.tagName == state.selectedTags){
                                          state.selectedTagsBean.tag = element.id;
                                        }
                                      }
                                    });

                                    dispatch(CommonPostDetailActionCreator
                                        .setLoading(true));


                                    dispatch(CommonPostDetailActionCreator
                                        .loadMore(state.selectedTagsBean));


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
                                    state.selectedTagsBean.pageNumber = 1;
                                    state.selectedTagsBean.type = getType();
                                    state.selectedTagsBean.model = getModel();
                                    state.selectedTagsBean.paymentType =
                                        getPayType();
                                    state.selectedTagsBean.isSelected = true;
                                    state.specialModel.tags.forEach((element) {
                                      if(state.selectedTags == "全部标签"){
                                        state.selectedTagsBean.tag = "";
                                      }else{
                                        if(element.tagName == state.selectedTags){
                                          state.selectedTagsBean.tag = element.id;
                                        }
                                      }
                                    });

                                    dispatch(CommonPostDetailActionCreator
                                        .setLoading(true));

                                    dispatch(CommonPostDetailActionCreator
                                        .loadMore(state.selectedTagsBean));
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
                            Container(
                              alignment: Alignment.centerLeft,
                              child: ChipsChoice<String>.single(
                                wrapped: false,
                                spacing: 3,
                                value: state.selectedTags,
                                onChanged: (val) {
                                  state.selectedTags = val;
                                  setStates(() {
                                    state.selectedTagsBean.pageNumber = 1;
                                    state.selectedTagsBean.type = getType();
                                    state.selectedTagsBean.model = getModel();
                                    state.selectedTagsBean.paymentType =
                                        getPayType();
                                    state.selectedTagsBean.isSelected = true;
                                    state.specialModel.tags.forEach((element) {
                                      if(state.selectedTags == "全部标签"){
                                        state.selectedTagsBean.tag = "";
                                      }else{
                                        if(element.tagName == state.selectedTags){
                                          state.selectedTagsBean.tag = element.id;
                                        }
                                      }
                                    });

                                    dispatch(CommonPostDetailActionCreator
                                        .setLoading(true));

                                    dispatch(CommonPostDetailActionCreator
                                        .loadMore(state.selectedTagsBean));
                                  });
                                },
                                choiceItems:
                                C2Choice.listFrom<String, String>(
                                  source: state.tagsOptions,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceStyle: C2ChoiceStyle(
                                  color: Colors.black,
                                  showCheckmark: false,
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
                                value: state.selectedVipGold,
                                onChanged: (val) {
                                  state.selectedVipGold = val;
                                  setStates(() {
                                    state.selectedTagsBean.pageNumber = 1;
                                    state.selectedTagsBean.type = getType();
                                    state.selectedTagsBean.model = getModel();
                                    state.selectedTagsBean.paymentType =
                                        getPayType();
                                    state.selectedTagsBean.isSelected = true;
                                    state.specialModel.tags.forEach((element) {
                                      if(state.selectedTags == "全部标签"){
                                        state.selectedTagsBean.tag = "";
                                      }else{
                                        if(element.tagName == state.selectedTags){
                                          state.selectedTagsBean.tag = element.id;
                                        }
                                      }
                                    });

                                    dispatch(CommonPostDetailActionCreator
                                        .setLoading(true));

                                    dispatch(CommonPostDetailActionCreator
                                        .loadMore(state.selectedTagsBean));
                                  });
                                },
                                choiceItems:
                                C2Choice.listFrom<String, String>(
                                  source: state.vipGoldOptions,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceStyle: C2ChoiceStyle(
                                  color: Colors.black,
                                  showCheckmark: false,
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            state.selectedTagsData == null || state.isLoading
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
                    dispatch(
                        CommonPostDetailActionCreator.onAction());
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
                                    *//*placeholder: (context, url) {
                                      return placeHolder(ImgType.cover,
                                          null, Dimens.pt280);
                                    },*//*
                                  ),
                                ),*/
                                CachedNetworkImage(
                                  imageUrl: state.selectedTagsData
                                      .xList[index].cover,
                                  fit: BoxFit.cover,
                                  memCacheHeight: 600,
                                  fadeInCurve: Curves.linear,
                                  fadeOutCurve: Curves.linear,
                                  fadeInDuration: Duration(milliseconds: 100),
                                  fadeOutDuration: Duration(milliseconds: 100),
                                  cacheManager: ImageCacheManager(),
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
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
