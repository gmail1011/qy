import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart' as Gets;
import 'EntryHistory/entry_history_page.dart';
import 'entry_video_action.dart';
import 'entry_video_state.dart';

Widget buildView(
    EntryVideoState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: CustomAppbar(
      title: "参赛视频",
      actions: [
        GestureDetector(
          onTap: () {
            /*Navigator.of(viewService.context)
                .push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EntryHistoryPage().buildPage(null)))
                .then((value) {
                  if(value != null){
                    dispatch(EntryVideoActionCreator.onSelected(value));
                  }

            });*/

            Gets.Get.to(() =>EntryHistoryPage().buildPage(null),opaque: false).then((value) {
              if(value != null){
                dispatch(EntryVideoActionCreator.onSelected(value));
              }

            });
          },
          child: Text(
            "往届赛事",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: Dimens.pt12,
            ),
          ),
        ),
      ],
    ),
    body: state.entryVideoData == null
        ? Center(
            child: LoadingWidget(),
          )
        : /*CustomScrollView(
            slivers: [



              SliverAppBar(
                //floating: true,
                // snap: true,
                pinned: false,
                // stretch: true,
                automaticallyImplyLeading: false,
                expandedHeight: Dimens.pt290,
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
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  CustomNetworkImage(
                                    imageUrl: state.entryVideoData.activityBackgroundImage,
                                    type: ImgType.cover,
                                    height: Dimens.pt150,
                                    fit: BoxFit.cover,
                                  ),
                                  state.isBeforeToday ? Container() : Container(
                                    padding: EdgeInsets.only(
                                      top: Dimens.pt10,
                                      bottom: Dimens.pt10,
                                    ),
                                    margin: EdgeInsets.only(
                                      left: Dimens.pt30,
                                      right: Dimens.pt30,
                                      top: Dimens.pt60,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "活动倒计时 : ",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: Dimens.pt18),
                                          ),
                                          SizedBox(
                                            width: Dimens.pt6,
                                          ),
                                          Text(
                                            state.countDownTime,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: Dimens.pt18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimens.pt10,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt8,
                                    right: Dimens.pt8,
                                    bottom: Dimens.pt16,
                                  ),
                                  child: Text(
                                    state.entryVideoData.activityDesc,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12),
                                  )),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: Dimens.pt14),
                                      alignment: Alignment.center,
                                      child: TabBar(
                                        isScrollable: true,
                                        controller: state.tabController,
                                        tabs: state.tabsString
                                            .map(
                                              (e) => Text(
                                            e,
                                            style: TextStyle(fontSize: Dimens.pt16),
                                          ),
                                        )
                                            .toList(),
                                        labelColor: Colors.white,
                                        unselectedLabelColor: Colors.white,
                                        indicator: RoundUnderlineTabIndicator(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: Dimens.pt16,
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),



             *//* SliverToBoxAdapter(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CustomNetworkImage(
                      imageUrl: state.entryVideoData.activityBackgroundImage,
                      type: ImgType.cover,
                      height: Dimens.pt150,
                      fit: BoxFit.cover,
                    ),
                    state.isBeforeToday ? Container() : Container(
                      padding: EdgeInsets.only(
                        top: Dimens.pt10,
                        bottom: Dimens.pt10,
                      ),
                      margin: EdgeInsets.only(
                        left: Dimens.pt30,
                        right: Dimens.pt30,
                        top: Dimens.pt60,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "活动倒计时 : ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: Dimens.pt18),
                            ),
                            SizedBox(
                              width: Dimens.pt6,
                            ),
                            Text(
                              state.countDownTime,
                              style: TextStyle(
                                  color: Colors.white, fontSize: Dimens.pt18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: Dimens.pt10,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: Dimens.pt8,
                      right: Dimens.pt8,
                      bottom: Dimens.pt16,
                    ),
                    child: Text(
                      state.entryVideoData.activityDesc,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: Dimens.pt12),
                    )),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: Dimens.pt14),
                        alignment: Alignment.center,
                        child: TabBar(
                          isScrollable: true,
                          controller: state.tabController,
                          tabs: state.tabsString
                              .map(
                                (e) => Text(
                              e,
                              style: TextStyle(fontSize: Dimens.pt16),
                            ),
                          )
                              .toList(),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          indicator: RoundUnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  width: Dimens.pt16,
                ),
              ),
              SliverToBoxAdapter(
                child: TabBarView(
                  controller: state.tabController,
                  children: [
                    state.entryVideoData == null ||
                        state.entryVideoData.workList.length == 0
                        ? Center(
                      child: CErrorWidget(
                        Lang.EMPTY_DATA,
                        retryOnTap: () {
                          dispatch(EntryVideoActionCreator.onAction());
                        },
                      ),
                    )
                        : KeepAliveWidget(pullYsRefresh(
                      refreshController: state.refreshController,
                      enablePullDown: false,
                      onRefresh: () {

                      },
                      onLoading: () {
                        dispatch(EntryVideoActionCreator.onDataLoadMore(state.pageNumber += 1));
                      },
                      child: ListView.builder(
                        itemCount: state.entryVideoData.workList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              List<VideoModel> lists = [];

                              state.entryVideoData.workList
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
                              JRouter()
                                  .go(SUB_PLAY_LIST, arguments: maps);
                            },
                            child: Container(
                              height: Dimens.pt160,
                              margin: EdgeInsets.only(
                                top: Dimens.pt10,
                                left: Dimens.pt16,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CustomNetworkImage(
                                      imageUrl: state.entryVideoData
                                          .workList[index].cover,
                                      type: ImgType.cover,
                                      height: Dimens.pt160,
                                      width: Dimens.pt110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimens.pt16,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "TOP " + (index + 1).toString(),
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              252, 48, 102, 1),
                                          fontSize: Dimens.pt20,
                                        ),
                                      ),
                                      Text(
                                        state.entryVideoData
                                            .workList[index].title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt13,
                                        ),
                                      ),
                                      Text(
                                        "原创作者：" +  state
                                            .entryVideoData
                                            .workList[index]
                                            .publisher
                                            .name,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withOpacity(0.5),
                                          fontSize: Dimens.pt12,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/heart_red.png",width: Dimens.pt14,height: Dimens.pt14,),
                                          SizedBox(
                                            width: Dimens.pt8,
                                          ),
                                          Text(
                                            state
                                                .entryVideoData
                                                .workList[index]
                                                .likeCount >
                                                10000
                                                ? (state
                                                .entryVideoData
                                                .workList[
                                            index]
                                                .likeCount /
                                                10000)
                                                .toStringAsFixed(
                                                1) +
                                                "w"
                                                : state
                                                .entryVideoData
                                                .workList[index]
                                                .likeCount
                                                .toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimens.pt10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )),
                    state.entryVideoData1 == null ||
                        state.entryVideoData1.workList.length == 0
                        ? Center(
                      child: CErrorWidget(
                        Lang.EMPTY_DATA,
                        retryOnTap: () {
                          dispatch(EntryVideoActionCreator.onAction1());
                        },
                      ),
                    )
                        : KeepAliveWidget(pullYsRefresh(
                      enablePullDown: false,
                      refreshController: state.refreshController1,
                      onLoading: (){
                        dispatch(EntryVideoActionCreator.onDataLoadMore1(state.pageNumber1 += 1));
                      },
                      child: ListView.builder(
                        itemCount: state.entryVideoData1.workList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              List<VideoModel> lists = [];

                              state.entryVideoData1.workList
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
                              maps['playType'] = VideoPlayConfig.VIDEO_TAG;
                              JRouter().go(SUB_PLAY_LIST, arguments: maps);
                            },
                            child: Container(
                              height: Dimens.pt160,
                              margin: EdgeInsets.only(
                                top: Dimens.pt10,
                                left: Dimens.pt16,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CustomNetworkImage(
                                      imageUrl: state.entryVideoData1
                                          .workList[index].cover,
                                      type: ImgType.cover,
                                      height: Dimens.pt160,
                                      width: Dimens.pt110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimens.pt16,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "TOP " + (index + 1).toString(),
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              252, 48, 102, 1),
                                          fontSize: Dimens.pt20,
                                        ),
                                      ),
                                      Text(
                                        state.entryVideoData1
                                            .workList[index].title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt13,
                                        ),
                                      ),
                                      Text(
                                        "原创作者：" + state.entryVideoData1
                                            .workList[index].publisher.name,
                                        style: TextStyle(
                                          color:
                                          Colors.white.withOpacity(0.5),
                                          fontSize: Dimens.pt12,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/heart_red.png",width: Dimens.pt14,height: Dimens.pt14,),
                                          SizedBox(
                                            width: Dimens.pt8,
                                          ),
                                          Text(
                                            state
                                                .entryVideoData1
                                                .workList[index]
                                                .likeCount >
                                                10000
                                                ? (state
                                                .entryVideoData1
                                                .workList[
                                            index]
                                                .likeCount /
                                                10000)
                                                .toStringAsFixed(
                                                1) +
                                                "w"
                                                : state
                                                .entryVideoData1
                                                .workList[index]
                                                .likeCount
                                                .toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimens.pt10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )),
                  ],
                ),
              ),*//*
            ],
          ),*/
    NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        // 返回一个 Sliver 数组给外部可滚动组件。
        return <Widget>[
          SliverAppBar(
            //floating: true,
            // snap: true,
            pinned: false,
            // stretch: true,
            automaticallyImplyLeading: false,
            expandedHeight: Dimens.pt260,
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
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CustomNetworkImage(
                                imageUrl: state.entryVideoData.activityBackgroundImage,
                                type: ImgType.cover,
                                height: Dimens.pt150,
                                fit: BoxFit.cover,
                              ),
                              state.isBeforeToday ? Container() : Container(
                                padding: EdgeInsets.only(
                                  top: Dimens.pt10,
                                  bottom: Dimens.pt10,
                                ),
                                margin: EdgeInsets.only(
                                  left: Dimens.pt30,
                                  right: Dimens.pt30,
                                  top: Dimens.pt60,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "活动倒计时 : ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: Dimens.pt18),
                                      ),
                                      SizedBox(
                                        width: Dimens.pt6,
                                      ),
                                      Text(
                                        state.countDownTime ?? "",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: Dimens.pt18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimens.pt10,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: Dimens.pt8,
                                right: Dimens.pt8,
                                bottom: Dimens.pt16,
                              ),
                              child: Text(
                                state.entryVideoData.activityDesc,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: Dimens.pt12),
                              )),


                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ];
      },
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Dimens.pt2),
                  alignment: Alignment.center,
                  child: TabBar(
                    isScrollable: true,
                    controller: state.tabController,
                    tabs: state.tabsString
                        .map(
                          (e) => Text(
                        e,
                        style: TextStyle(fontSize: Dimens.pt16),
                      ),
                    )
                        .toList(),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    indicator: RoundUnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: Dimens.pt10,
          ),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                state.entryVideoData == null ||
                    state.entryVideoData.workList.length == 0
                    ? Center(
                  child: CErrorWidget(
                    Lang.EMPTY_DATA,
                    retryOnTap: () {
                      dispatch(EntryVideoActionCreator.onAction());
                    },
                  ),
                )
                    : KeepAliveWidget(pullYsRefresh(
                  refreshController: state.refreshController,
                  enablePullDown: false,
                  onRefresh: () {

                  },
                  onLoading: () {
                    dispatch(EntryVideoActionCreator.onDataLoadMore(state.pageNumber += 1));
                  },
                  child: ListView.builder(
                    itemCount: state.entryVideoData.workList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          List<VideoModel> lists = [];

                          state.entryVideoData.workList
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
                          JRouter()
                              .go(SUB_PLAY_LIST, arguments: maps);
                        },
                        child: Container(
                          height: Dimens.pt160,
                          margin: EdgeInsets.only(
                            top: Dimens.pt10,
                            left: Dimens.pt16,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                child: CustomNetworkImage(
                                  imageUrl: state.entryVideoData
                                      .workList[index].cover,
                                  type: ImgType.cover,
                                  height: Dimens.pt160,
                                  width: Dimens.pt110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: Dimens.pt16,
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TOP " + (index + 1).toString(),
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          252, 48, 102, 1),
                                      fontSize: Dimens.pt20,
                                    ),
                                  ),
                                  Text(
                                    state.entryVideoData
                                        .workList[index].title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt13,
                                    ),
                                  ),
                                  Text(
                                    "原创作者：" +  state
                                        .entryVideoData
                                        .workList[index]
                                        .publisher
                                        .name,
                                    style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.5),
                                      fontSize: Dimens.pt12,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/heart_red.png",width: Dimens.pt14,height: Dimens.pt14,),
                                      SizedBox(
                                        width: Dimens.pt8,
                                      ),
                                      Text(
                                        state
                                            .entryVideoData
                                            .workList[index]
                                            .likeCount >
                                            10000
                                            ? (state
                                            .entryVideoData
                                            .workList[
                                        index]
                                            .likeCount /
                                            10000)
                                            .toStringAsFixed(
                                            1) +
                                            "w"
                                            : state
                                            .entryVideoData
                                            .workList[index]
                                            .likeCount
                                            .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
                state.entryVideoData1 == null ||
                    state.entryVideoData1.workList.length == 0
                    ? Center(
                  child: CErrorWidget(
                    Lang.EMPTY_DATA,
                    retryOnTap: () {
                      dispatch(EntryVideoActionCreator.onAction1());
                    },
                  ),
                )
                    : KeepAliveWidget(pullYsRefresh(
                  enablePullDown: false,
                  refreshController: state.refreshController1,
                  onLoading: (){
                    dispatch(EntryVideoActionCreator.onDataLoadMore1(state.pageNumber1 += 1));
                  },
                  child: ListView.builder(
                    itemCount: state.entryVideoData1.workList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          List<VideoModel> lists = [];

                          state.entryVideoData1.workList
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
                          height: Dimens.pt160,
                          margin: EdgeInsets.only(
                            top: Dimens.pt10,
                            left: Dimens.pt16,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                child: CustomNetworkImage(
                                  imageUrl: state.entryVideoData1
                                      .workList[index].cover,
                                  type: ImgType.cover,
                                  height: Dimens.pt160,
                                  width: Dimens.pt110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: Dimens.pt16,
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TOP " + (index + 1).toString(),
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          252, 48, 102, 1),
                                      fontSize: Dimens.pt20,
                                    ),
                                  ),
                                  Text(
                                    state.entryVideoData1
                                        .workList[index].title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt13,
                                    ),
                                  ),
                                  Text(
                                    "原创作者：" + state.entryVideoData1
                                        .workList[index].publisher.name,
                                    style: TextStyle(
                                      color:
                                      Colors.white.withOpacity(0.5),
                                      fontSize: Dimens.pt12,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/heart_red.png",width: Dimens.pt14,height: Dimens.pt14,),
                                      SizedBox(
                                        width: Dimens.pt8,
                                      ),
                                      Text(
                                        state
                                            .entryVideoData1
                                            .workList[index]
                                            .likeCount >
                                            10000
                                            ? (state
                                            .entryVideoData1
                                            .workList[
                                        index]
                                            .likeCount /
                                            10000)
                                            .toStringAsFixed(
                                            1) +
                                            "w"
                                            : state
                                            .entryVideoData1
                                            .workList[index]
                                            .likeCount
                                            .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
