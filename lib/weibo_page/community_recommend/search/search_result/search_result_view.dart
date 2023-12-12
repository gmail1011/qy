import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/weibo_page/community_recommend/topic_detail/topic_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'search_result_action.dart';
import 'search_result_state.dart';

Widget buildView(
    SearchResultState state, Dispatch dispatch, ViewService viewService) {
  return KeyboardDismissOnTap(
    child: Scaffold(
      appBar: SearchAppBar(
        controller: state.textEditingController,
        isSearchBtn: true,
        autofocus: false,
        onSubmitted: (values) {
          if (TextUtil.isEmpty(values)) {
            showToast(msg: "请输入搜索内容");
          } else {
            dispatch(SearchResultActionCreator.setKeyWord(values));
          }
        },
      ),
      body: Column(
        children: [
          SizedBox(
            height: 12.w,
          ),
          Container(
            alignment: Alignment.center,
            child: commonTabBar(
              TabBar(
                isScrollable: false,
                controller: state.tabController,
                tabs: Lang.SEARCH_RESULT
                    .map(
                      (e) => Text(
                        e,
                        style: TextStyle(fontSize: 16.nsp),
                      ),
                    )
                    .toList(),
                indicator: RoundUnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 127, 15, 1),
                    width: 3,
                  ),
                ),
                indicatorWeight: 4,
                unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 16.nsp),
                unselectedLabelStyle: TextStyle(fontSize: 16.nsp),
                //labelPadding: EdgeInsets.symmetric(horizontal: 22.w),
              ),
            ),
          ),
          SizedBox(
            height: 21.w,
          ),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                state.searchVideoData == null
                    ? LoadingWidget()
                    : state.searchVideoData.xList == null ||
                            state.searchVideoData.xList.length == 0
                        ? CErrorWidget("暂无数据")
                        : KeepAliveWidget(
                            pullYsRefresh(
                              refreshController: state.refreshVideoController,
                              enablePullDown: false,
                              onRefresh: () {
                                dispatch(
                                    SearchResultActionCreator.onVideoLoadMore(
                                        state.videoPageNum = 1));
                              },
                              onLoading: () {
                                dispatch(
                                    SearchResultActionCreator.onVideoLoadMore(
                                        state.videoPageNum += 1));
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return WordImageWidget(
                                        key: UniqueKey(),
                                        videoModel: VideoModel.fromJson(state
                                            .searchVideoData.xList[index]
                                            .toJson()),
                                        index: index,
                                      );
                                    },
                                        childCount:
                                            state.searchVideoData.xList.length),
                                  ),
                                ],
                              ),
                            ),
                          ),
                state.searchWordData == null
                    ? LoadingWidget()
                    : state.searchWordData.xList == null ||
                            state.searchWordData.xList.length == 0
                        ? CErrorWidget("暂无数据")
                        : KeepAliveWidget(
                            pullYsRefresh(
                              refreshController: state.refreshWordController,
                              enablePullDown: false,
                              onRefresh: () {
                                dispatch(
                                    SearchResultActionCreator.onWordLoadMore(
                                        state.wordPageNum = 1));
                              },
                              onLoading: () {
                                dispatch(
                                    SearchResultActionCreator.onWordLoadMore(
                                        state.wordPageNum += 1));
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return WordImageWidget(
                                        key: UniqueKey(),
                                        videoModel: VideoModel.fromJson(state
                                            .searchWordData.xList[index]
                                            .toJson()),
                                        index: index,
                                      );
                                    },
                                        childCount:
                                            state.searchWordData.xList.length),
                                  ),
                                ],
                              ),
                            ),
                          ),
                state.searchMovieData == null
                    ? LoadingWidget()
                    : state.searchMovieData.xList == null ||
                            state.searchMovieData.xList.length == 0
                        ? CErrorWidget("暂无数据")
                        : KeepAliveWidget(
                            Container(
                              margin: EdgeInsets.only(left: 16.w, right: 16.w),
                              child: pullYsRefresh(
                                refreshController: state.refreshMovieController,
                                enablePullDown: false,
                                onRefresh: () {
                                  dispatch(
                                      SearchResultActionCreator.onMovieLoadMore(
                                          state.moviePageNum = 1));
                                },
                                onLoading: () {
                                  dispatch(
                                      SearchResultActionCreator.onMovieLoadMore(
                                          state.moviePageNum += 1));
                                },
                                child: GridView.builder(
                                  itemCount: state.searchMovieData.xList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, //横向数量
                                    crossAxisSpacing: 14, //间距
                                    mainAxisSpacing: 10, //行距
                                    childAspectRatio: 191.w / 132.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Map<String, dynamic> maps = Map();
                                        maps["videoId"] = state
                                            .searchMovieData.xList[index].id;

                                        VideoModel videos  =  VideoModel.fromJson(state
                                            .searchMovieData.xList[index].toJson());

                                        maps["videoModel"] = videos;

                                        Gets.Get.to(
                                          FilmTvVideoDetailPage()
                                              .buildPage(maps),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2)),
                                                child: CustomNetworkImage(
                                                  imageUrl: state
                                                      .searchMovieData
                                                      .xList[index]
                                                      .cover,
                                                  fit: BoxFit.cover,
                                                  type: ImgType.cover,
                                                  width: 191.w,
                                                  height: 107.w,
                                                ),
                                              ),
                                              Container(
                                                height: 18.w,
                                                alignment: Alignment.center,
                                                /*decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [Colors.black54, Colors.transparent],
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter),
                                                  ),*/
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 6,
                                                      right: 6,
                                                      bottom: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              "assets/weibo/play_icon.png",
                                                              width: 10.w,
                                                              height: 8.w),
                                                          SizedBox(
                                                            width: 4.w,
                                                          ),
                                                          Text(
                                                            state
                                                                        .searchMovieData
                                                                        .xList[
                                                                            index]
                                                                        .playCount >
                                                                    10000
                                                                ? (state.searchMovieData.xList[index].playCount /
                                                                            10000)
                                                                        .toStringAsFixed(
                                                                            1) +
                                                                    "w"
                                                                : state
                                                                    .searchMovieData
                                                                    .xList[
                                                                        index]
                                                                    .playCount
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      227,
                                                                      227,
                                                                      227,
                                                                      1),
                                                              fontSize: 10.nsp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        TimeHelper.getTimeText(
                                                            state
                                                                .searchMovieData
                                                                .xList[index]
                                                                .playTime
                                                                .toDouble()),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    227,
                                                                    227,
                                                                    227,
                                                                    1),
                                                            fontSize: 10.nsp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: -1,
                                                  left: -1,
                                                  child: Visibility(
                                                    visible: state
                                                                    .searchMovieData
                                                                    .xList[
                                                                        index]
                                                                    .originCoins !=
                                                                null &&
                                                            state
                                                                    .searchMovieData
                                                                    .xList[
                                                                        index]
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
                                                                  BorderRadius
                                                                      .only(
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            4),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        4),
                                                              ),
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color
                                                                      .fromRGBO(
                                                                          247,
                                                                          131,
                                                                          97,
                                                                          1),
                                                                  Color
                                                                      .fromRGBO(
                                                                          245,
                                                                          75,
                                                                          100,
                                                                          1),
                                                                ],
                                                              ),
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: Dimens.pt4,
                                                              right: Dimens.pt7,
                                                              top: Dimens.pt2,
                                                              bottom:
                                                                  Dimens.pt2,
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
                                                                                .ICON_VIDEO_GOLD,
                                                                        width: Dimens
                                                                            .pt12,
                                                                        height:
                                                                            Dimens.pt12)
                                                                    .load(),
                                                                SizedBox(
                                                                    width: Dimens
                                                                        .pt4),
                                                                Text(
                                                                    state
                                                                        .searchMovieData
                                                                        .xList[
                                                                            index]
                                                                        .originCoins
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .textColorWhite,
                                                                      fontSize:
                                                                          12.nsp,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  )),
                                              Positioned(
                                                  top: -1,
                                                  left: -1,
                                                  child: Visibility(
                                                    visible: state
                                                                .searchMovieData
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
                                                                  BorderRadius
                                                                      .only(
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            4),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        4),
                                                              ),
                                                              //color: Color.fromRGBO(255, 0, 169, 1),
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: AppColors
                                                                    .buttonWeiBo,
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                              ),
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: Dimens.pt10,
                                                              right:
                                                                  Dimens.pt10,
                                                              top: Dimens.pt2,
                                                              bottom:
                                                                  Dimens.pt2,
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
                                                                          .white,
                                                                      fontSize:
                                                                          12.nsp),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.w,
                                          ),
                                          Text(
                                            state.searchMovieData.xList[index]
                                                .title,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 12.nsp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                state.searchBeanData == null
                    ? LoadingWidget()
                    : state.searchBeanData.xList == null ||
                            state.searchBeanData.xList.length == 0
                        ? CErrorWidget("暂无数据")
                        : KeepAliveWidget(
                            pullYsRefresh(
                              refreshController: state.refreshUserController,
                              enablePullDown: false,
                              onRefresh: () {
                                dispatch(
                                    SearchResultActionCreator.onUserLoadMore(
                                        state.userPageNum = 1));
                              },
                              onLoading: () {
                                dispatch(
                                    SearchResultActionCreator.onUserLoadMore(
                                        state.userPageNum += 1));
                              },
                              child: ListView.builder(
                                itemCount: state.searchBeanData.xList.length,
                                itemBuilder: (context, index) {
                                  return StatefulBuilder(
                                      builder: (context, states) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 16.w, right: 16.w, bottom: 6.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Map<String, dynamic>
                                                      arguments = {
                                                    'uid': state.searchBeanData
                                                        .xList[index].uid,
                                                    'uniqueId': DateTime.now()
                                                        .toIso8601String(),
                                                  };

                                                  Gets.Get.to(
                                                    BloggerPage(arguments),
                                                  );
                                                },
                                                child: HeaderWidget(
                                                  headPath: state
                                                          .searchBeanData
                                                          .xList[index]
                                                          .portrait ??
                                                      "",
                                                  level: (state.searchBeanData.xList[index].superUser ?? false)
                                                      ? 1
                                                      : 0,
                                                  headWidth: 78.w,
                                                  headHeight: 78.w,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 9.w,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Map<String, dynamic>
                                                      arguments = {
                                                    'uid': state.searchBeanData
                                                        .xList[index].uid,
                                                    'uniqueId': DateTime.now()
                                                        .toIso8601String(),
                                                  };

                                                  Gets.Get.to(
                                                    BloggerPage(arguments),
                                                  );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            state
                                                                .searchBeanData
                                                                .xList[index]
                                                                .name,
                                                            style: TextStyle(
                                                                color: state
                                                                            .searchBeanData
                                                                            .xList[
                                                                                index]
                                                                            .vipLevel >
                                                                        0
                                                                    ? Color
                                                                        .fromRGBO(
                                                                            246,
                                                                            197,
                                                                            89,
                                                                            1)
                                                                    : Colors
                                                                        .white,
                                                                fontSize:
                                                                    15.nsp),
                                                          ),
                                                          SizedBox(
                                                            width: 9.w,
                                                          ),
                                                          state
                                                                      .searchBeanData
                                                                      .xList[
                                                                          index]
                                                                      .vipLevel >
                                                                  0
                                                              ? Image.asset(
                                                                  "assets/weibo/huangguan.png",
                                                                  width: 19.w,
                                                                  height: 19.w,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                )
                                                              : Container(),

                                                          /*Row(
                                                            children:
                                                            state.searchBeanData.xList[index].awardsImage.map((e) {
                                                              return Row(
                                                                children: [
                                                                  CustomNetworkImage(
                                                                    imageUrl: e,
                                                                    fit: BoxFit.contain,
                                                                    width: 18.w,
                                                                    height: 18.w,
                                                                    placeholder: Container(
                                                                      color: Colors.transparent,
                                                                      width: 18.w,
                                                                      height: 18.w,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  ),
                                                                ],
                                                              );
                                                            }).toList(),
                                                          ),*/
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 9.w,
                                                      ),
                                                      Text(
                                                        "粉丝: " +
                                                            state
                                                                .searchBeanData
                                                                .xList[index]
                                                                .fansCount
                                                                .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    78,
                                                                    88,
                                                                    110,
                                                                    1),
                                                            fontSize: 15.nsp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Visibility(
                                                  visible: state
                                                          .searchBeanData
                                                          .xList[index]
                                                          .hasFollowed
                                                      ? false
                                                      : true,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await netManager.client
                                                          .getFollow(
                                                              state
                                                                  .searchBeanData
                                                                  .xList[index]
                                                                  .uid,
                                                              !state
                                                                  .searchBeanData
                                                                  .xList[index]
                                                                  .hasFollowed);

                                                      state
                                                              .searchBeanData
                                                              .xList[index]
                                                              .hasFollowed
                                                          ? state
                                                                  .searchBeanData
                                                                  .xList[index]
                                                                  .hasFollowed =
                                                              false
                                                          : state
                                                                  .searchBeanData
                                                                  .xList[index]
                                                                  .hasFollowed =
                                                              true;

                                                      showToast(msg: "关注成功");
                                                      states(() {});
                                                    },
                                                    child: Image.asset(
                                                      "assets/weibo/guanzhu.png",
                                                      width: 68.w,
                                                      height: 26.w,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 9.w,
                                          ),
                                          Container(
                                            height: 1.w,
                                            margin: EdgeInsets.only(
                                                left: 78.w, right: 58.w),
                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                state.searchBeanDataTopic == null
                    ? LoadingWidget()
                    : state.searchBeanDataTopic.xList == null ||
                            state.searchBeanDataTopic.xList.length == 0
                        ? CErrorWidget("暂无数据")
                        : KeepAliveWidget(
                            pullYsRefresh(
                              refreshController: state.refreshTopicController,
                              enablePullDown: false,
                              onRefresh: () {
                                dispatch(
                                    SearchResultActionCreator.onTopicLoadMore(
                                        state.topicPageNum = 1));
                              },
                              onLoading: () {
                                dispatch(
                                    SearchResultActionCreator.onTopicLoadMore(
                                        state.topicPageNum += 1));
                              },
                              child: ListView.builder(
                                itemCount:
                                    state.searchBeanDataTopic.xList.length,
                                itemBuilder: (context, index) {
                                  return StatefulBuilder(
                                      builder: (context, states) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          left: 16.w,
                                          right: 16.w,
                                          bottom: 20.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(11)),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Gets.Get.to(
                                                      TopicDetailPage()
                                                          .buildPage({
                                                        "tagsBean": TagsBean
                                                            .fromMap(state
                                                                .searchBeanDataTopic
                                                                .xList[index]
                                                                .toJson())
                                                      }),
                                                    );
                                                  },
                                                  child: CustomNetworkImage(
                                                    fit: BoxFit.cover,
                                                    width: 64.w,
                                                    height: 64.w,
                                                    imageUrl: state
                                                        .searchBeanDataTopic
                                                        .xList[index]
                                                        .coverImg,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 9.w,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Gets.Get.to(
                                                    TopicDetailPage()
                                                        .buildPage({
                                                      "tagsBean":
                                                          TagsBean.fromMap(state
                                                              .searchBeanDataTopic
                                                              .xList[index]
                                                              .toJson())
                                                    }),
                                                  );
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "#" +
                                                            state
                                                                .searchBeanDataTopic
                                                                .xList[index]
                                                                .name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17.nsp),
                                                      ),
                                                      SizedBox(
                                                        height: 9.w,
                                                      ),
                                                      Text(
                                                        "话题总播放: " +
                                                            state
                                                                .searchBeanDataTopic
                                                                .xList[index]
                                                                .playCount
                                                                .toString() +
                                                            "次",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    124,
                                                                    135,
                                                                    159,
                                                                    1),
                                                            fontSize: 13.nsp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              ),
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
