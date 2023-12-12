import 'package:expandable_text/expandable_text.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../community_recommend_page.dart';
import 'topic_detail_action.dart';
import 'topic_detail_state.dart';
import 'package:get/route_manager.dart' as Gets;

Widget buildView(
    TopicDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: AppColors.weiboBackgroundColor,
    appBar: AppBar(
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 18.w),
          /*child: Image.asset(
            "assets/weibo/topic_detail_share.png",
            width: 24.w,
            height: 24.w,
          ),*/
          child: GestureDetector(
              onTap: () {
                showShareVideoDialog(viewService.context, () async {
                  await Future.delayed(Duration(milliseconds: 500));
                },
                    videoModel: new VideoModel()
                      ..cover = state.tagsBean.coverImg
                      ..title = "网黄up的分享平台,随时随地发现性鲜事",
                    topicName: state.tagsBean.name,
                    isLongVideo: false);
              },
              child: Icon(
                Icons.share,
                color: Colors.white,
                size: 24,
              )),
        ),
      ],
    ),
    body: state.isCollected == null
        ? LoadingWidget()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: CustomNetworkImage(
                        fit: BoxFit.cover,
                        height: 64.w,
                        width: 64.w,
                        imageUrl: state.tagsBean.coverImg,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${state.tagsBean.name}",
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.nsp),
                        ),
                        SizedBox(
                          height: 13.w,
                        ),
                        Text(
                          "播放${getShowCountStr(state.playCount)}",
                          style: TextStyle(
                              color: Color.fromRGBO(124, 135, 159, 1),
                              fontSize: 15.nsp),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        String type = 'tag';
                        String objID = state.tagsBean.id;

                        try {
                          await netManager.client.changeTagStatus(
                              objID, state.isCollected ? false : true, type);

                          dispatch(TopicDetailActionCreator.onAction());
                        } catch (e) {
                          l.d('changeTagStatus', e.toString());
                          if (viewService.context == null) return;
                          //showToast(msg: e.toString());
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(49, 49, 49, 1),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        padding: EdgeInsets.only(
                          left: 13.w,
                          right: 13.w,
                          top: 6.w,
                          bottom: 6.w,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Image.asset(
                              state.isCollected
                                  ? "assets/weibo/collected.png"
                                  : "assets/weibo/collect.png",
                              width: 20.w,
                              height: 20.w,
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              state.isCollected ?? state.tagsBean.hasCollected
                                  ? "已收藏"
                                  : "收藏",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.nsp),
                            ),
                          ],
                        ),
                      ),
                      /*child: StatefulBuilder(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(49, 49, 49, 1),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: EdgeInsets.only(left: 13.w,right: 13.w,top: 6.w,bottom: 6.w,),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                            Image.asset("assets/weibo/colloect.png",width: 16.w,height: 16.w,),
                            SizedBox(width: 6.w,),
                            Text("收藏",style: TextStyle(color: Colors.white,fontSize: 11.nsp),),
                        ],
                      ),
                    ),
                  ),*/
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: commonTabBar(
                  TabBar(
                    isScrollable: true,
                    controller: state.tabController,
                    tabs: Lang.COMMUNITY_TABS_TOPIC
                        .map(
                          (e) => Text(
                            e,
                            style: TextStyle(fontSize: 18.nsp),
                          ),
                        )
                        .toList(),
                    indicator: RoundUnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: AppColors.weiboColor,
                        width: 3,
                      ),
                    ),
                    indicatorWeight: 4,
                    unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 18.nsp),
                    unselectedLabelStyle: TextStyle(fontSize: 18.nsp),
                    labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                ),
              ),
              SizedBox(
                height: 8.w,
              ),
              Expanded(
                child: TabBarView(
                  controller: state.tabController,
                  children: [
                    state.tagVideoBean == null
                        ? LoadingWidget()
                        : state.tagVideoBean.list == null ||
                                state.tagVideoBean.list.length == 0
                            ? CErrorWidget("暂无数据")
                            : Container(
                                //color: Colors.blue,
                                margin: EdgeInsets.only(
                                    top: 6.w, left: 16.w, right: 16.w),
                                child: pullYsRefresh(
                                  refreshController:
                                      state.refreshVideoController,
                                  enablePullDown: false,
                                  onRefresh: () {
                                    dispatch(TopicDetailActionCreator
                                        .onVideoLoadMore(
                                            state.pageVideoNumber = 1));
                                  },
                                  onLoading: () {
                                    dispatch(TopicDetailActionCreator
                                        .onVideoLoadMore(
                                            state.pageVideoNumber += 1));
                                  },
                                  child: GridView.builder(
                                    itemCount: state.tagVideoBean.list.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, //横向数量
                                      crossAxisSpacing: 10, //间距
                                      mainAxisSpacing: 0, //行距
                                      childAspectRatio: 191.w / 318.w,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Map<String, dynamic> maps = Map();
                                          maps['pageNumber'] = 1;
                                          maps['pageSize'] = 3;
                                          maps['currentPosition'] = index;
                                          maps['videoList'] =
                                              state.tagVideoBean.list;
                                          maps['tagID'] = state.tagVideoBean
                                              .list[0].tags[0].id ??
                                              null;
                                          maps['playType'] =
                                              VideoPlayConfig.VIDEO_TAG;

                                          Gets.Get.to(
                                              SubPlayListPage()
                                                  .buildPage(maps),
                                              opaque: false);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          //color: Colors.blue,
                                          //margin: EdgeInsets.only(left: 10.w,right: 10.w),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Stack(
                                                alignment:
                                                AlignmentDirectional
                                                    .bottomCenter,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            3)),
                                                    child: CustomNetworkImage(
                                                      imageUrl: state
                                                          .tagVideoBean
                                                          .list[index]
                                                          .cover,
                                                      fit: BoxFit.cover,
                                                      type: ImgType.cover,
                                                      width: 200.w,
                                                      height: 286.w,
                                                      placeholder:
                                                      Image.asset(
                                                        "assets/weibo/loading_vertical.png",
                                                        width: 200.w,
                                                        height: 286.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 18.w,
                                                    width: 200.w,
                                                    alignment:
                                                    Alignment.center,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.black54,
                                                            Colors.transparent
                                                          ],
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end: Alignment
                                                              .topCenter),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.only(
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
                                                                  height:
                                                                  8.w),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              Text(
                                                                state.tagVideoBean.list[index].playCount >
                                                                    10000
                                                                    ? (state.tagVideoBean.list[index].playCount / 10000).toStringAsFixed(
                                                                    1) +
                                                                    "w"
                                                                    : state
                                                                    .tagVideoBean
                                                                    .list[
                                                                index]
                                                                    .playCount
                                                                    .toString(),
                                                                style:
                                                                TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      227,
                                                                      227,
                                                                      227,
                                                                      1),
                                                                  fontSize:
                                                                  10.nsp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              TimeHelper.getTimeText(state
                                                                  .tagVideoBean
                                                                  .list[index]
                                                                  .playTime
                                                                  .toDouble()),
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      227,
                                                                      227,
                                                                      227,
                                                                      1),
                                                                  fontSize:
                                                                  10.nsp),
                                                            ),
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
                                                            .tagVideoBean
                                                            .list[
                                                        index]
                                                            .originCoins !=
                                                            null &&
                                                            state
                                                                .tagVideoBean
                                                                .list[
                                                            index]
                                                                .originCoins !=
                                                                0
                                                            ? true
                                                            : false,
                                                        child: Stack(
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                //height: Dimens.pt20,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                    bottomRight:
                                                                    Radius.circular(
                                                                        4),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4),
                                                                  ),
                                                                  gradient:
                                                                  LinearGradient(
                                                                    colors: [
                                                                      Color.fromRGBO(247, 131, 97, 1),
                                                                      Color.fromRGBO(245, 75, 100, 1),
                                                                    ],
                                                                  ),
                                                                ),
                                                                padding:
                                                                EdgeInsets
                                                                    .only(
                                                                  left: Dimens
                                                                      .pt4,
                                                                  right: Dimens
                                                                      .pt7,
                                                                  top: Dimens
                                                                      .pt2,
                                                                  bottom:
                                                                  Dimens
                                                                      .pt2,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    ImageLoader.withP(
                                                                        ImageType.IMAGE_SVG,
                                                                        address: AssetsSvg.ICON_VIDEO_GOLD,
                                                                        width: Dimens.pt12,
                                                                        height: Dimens.pt12)
                                                                        .load(),
                                                                    SizedBox(
                                                                        width:
                                                                        Dimens.pt4),
                                                                    Text(
                                                                        state
                                                                            .tagVideoBean
                                                                            .list[
                                                                        index]
                                                                            .originCoins
                                                                            .toString(),
                                                                        style:
                                                                        TextStyle(
                                                                          color:
                                                                          AppColors.textColorWhite,
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
                                                            .tagVideoBean
                                                            .list[
                                                        index]
                                                            .originCoins ==
                                                            0
                                                            ? true
                                                            : false,
                                                        child: Stack(
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                //height: Dimens.pt20,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                    bottomRight:
                                                                    Radius.circular(
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
                                                                EdgeInsets
                                                                    .only(
                                                                  left: Dimens
                                                                      .pt10,
                                                                  right: Dimens
                                                                      .pt10,
                                                                  top: Dimens
                                                                      .pt2,
                                                                  bottom:
                                                                  Dimens
                                                                      .pt2,
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
                                                                          Colors.white,
                                                                          fontSize: 12.nsp),
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
                                              Container(
                                                width: 191.w,
                                                child: Text(
                                                  state.tagVideoBean
                                                      .list[index].title,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 16.nsp,
                                                    color: Colors.white,
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
                    state.tagBean == null
                        ? LoadingWidget()
                        : state.tagBean.list == null ||
                                state.tagBean.list.length == 0
                            ? CErrorWidget("暂无数据")
                            : pullYsRefresh(
                                refreshController: state.refreshController,
                                enablePullDown: false,
                                onRefresh: () {
                                  dispatch(TopicDetailActionCreator.onLoadMore(
                                      state.pageNumber = 1));
                                },
                                onLoading: () {
                                  dispatch(TopicDetailActionCreator.onLoadMore(
                                      state.pageNumber += 1));
                                },
                                child: CustomScrollView(
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: 6.w,
                                      ),
                                    ),
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                        return WordImageWidget(
                                          key: UniqueKey(),
                                          videoModel: state.tagBean.list[index],
                                          index: index,
                                        );
                                      }, childCount: state.tagBean.list.length),
                                    ),
                                  ],
                                ),
                              ),
                    state.tagMovieBean == null
                        ? LoadingWidget()
                        : state.tagMovieBean.list == null ||
                                state.tagMovieBean.list.length == 0
                            ? CErrorWidget("暂无数据")
                            : KeepAliveWidget(
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16.w, right: 16.w, top: 6.w),
                                  child: pullYsRefresh(
                                    refreshController:
                                        state.refreshMovieController,
                                    enablePullDown: false,
                                    onRefresh: () {
                                      dispatch(TopicDetailActionCreator
                                          .onMovieLoadMore(
                                              state.pageMovieNumber = 1));
                                    },
                                    onLoading: () {
                                      dispatch(TopicDetailActionCreator
                                          .onMovieLoadMore(
                                              state.pageMovieNumber += 1));
                                    },
                                    child: GridView.builder(
                                      itemCount: state.tagMovieBean.list.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, //横向数量
                                        crossAxisSpacing: 14, //间距
                                        mainAxisSpacing: 10, //行距
                                        childAspectRatio: 191.w / 156.w,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Map<String, dynamic> maps = Map();
                                            maps["videoId"] = state
                                                .tagMovieBean.list[index].id;

                                            maps["videoModel"] = state
                                                .tagMovieBean.list[index];

                                            Gets.Get.to(
                                                FilmTvVideoDetailPage()
                                                    .buildPage(maps),
                                                opaque: false);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                alignment:
                                                AlignmentDirectional
                                                    .bottomCenter,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            2)),
                                                    child: CustomNetworkImage(
                                                      imageUrl: state
                                                          .tagMovieBean
                                                          .list[index]
                                                          .cover,
                                                      fit: BoxFit.cover,
                                                      type: ImgType.cover,
                                                      width: 191.w,
                                                      height: 107.w,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 18.w,
                                                    alignment:
                                                    Alignment.center,
                                                    /*decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [Colors.black54, Colors.transparent],
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter),
                                                  ),*/
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.only(
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
                                                                  height:
                                                                  8.w),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              Text(
                                                                state.tagMovieBean.list[index].playCount >
                                                                    10000
                                                                    ? (state.tagMovieBean.list[index].playCount / 10000).toStringAsFixed(
                                                                    1) +
                                                                    "w"
                                                                    : state
                                                                    .tagMovieBean
                                                                    .list[
                                                                index]
                                                                    .playCount
                                                                    .toString(),
                                                                style:
                                                                TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                      227,
                                                                      227,
                                                                      227,
                                                                      1),
                                                                  fontSize:
                                                                  10.nsp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            TimeHelper.getTimeText(state
                                                                .tagMovieBean
                                                                .list[index]
                                                                .playTime
                                                                .toDouble()),
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                    227,
                                                                    227,
                                                                    227,
                                                                    1),
                                                                fontSize:
                                                                10.nsp),
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
                                                            .tagMovieBean
                                                            .list[
                                                        index]
                                                            .originCoins !=
                                                            null &&
                                                            state
                                                                .tagMovieBean
                                                                .list[
                                                            index]
                                                                .originCoins !=
                                                                0
                                                            ? true
                                                            : false,
                                                        child: Stack(
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                //height: Dimens.pt20,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                    bottomRight:
                                                                    Radius.circular(
                                                                        4),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        4),
                                                                  ),
                                                                  gradient:
                                                                  LinearGradient(
                                                                    colors: [
                                                                      Color.fromRGBO(247, 131, 97, 1),
                                                                      Color.fromRGBO(245, 75, 100, 1),
                                                                    ],
                                                                  ),
                                                                ),
                                                                padding:
                                                                EdgeInsets
                                                                    .only(
                                                                  left: Dimens
                                                                      .pt4,
                                                                  right: Dimens
                                                                      .pt7,
                                                                  top: Dimens
                                                                      .pt2,
                                                                  bottom:
                                                                  Dimens
                                                                      .pt2,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    ImageLoader.withP(
                                                                        ImageType.IMAGE_SVG,
                                                                        address: AssetsSvg.ICON_VIDEO_GOLD,
                                                                        width: Dimens.pt12,
                                                                        height: Dimens.pt12)
                                                                        .load(),
                                                                    SizedBox(
                                                                        width:
                                                                        Dimens.pt4),
                                                                    Text(
                                                                        state
                                                                            .tagMovieBean
                                                                            .list[
                                                                        index]
                                                                            .originCoins
                                                                            .toString(),
                                                                        style:
                                                                        TextStyle(
                                                                          color:
                                                                          AppColors.textColorWhite,
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
                                                            .tagMovieBean
                                                            .list[
                                                        index]
                                                            .originCoins ==
                                                            0
                                                            ? true
                                                            : false,
                                                        child: Stack(
                                                            alignment:
                                                            Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                //height: Dimens.pt20,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                    bottomRight:
                                                                    Radius.circular(
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
                                                                EdgeInsets
                                                                    .only(
                                                                  left: Dimens
                                                                      .pt10,
                                                                  right: Dimens
                                                                      .pt10,
                                                                  top: Dimens
                                                                      .pt2,
                                                                  bottom:
                                                                  Dimens
                                                                      .pt2,
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
                                                                          Colors.white,
                                                                          fontSize: 12.nsp),
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
                                                state.tagMovieBean.list[index]
                                                    .title,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 16.nsp,
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
                  ],
                ),
              ),
            ],
          ),
  );
}
