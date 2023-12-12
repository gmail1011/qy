import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_result_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'search_action.dart';
import 'search_state.dart';

int changeCount = 0;

Widget buildView(
    SearchState state, Dispatch dispatch, ViewService viewService) {
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
            AnalyticsEvent.clickToSearchInputEvent(values);
            Gets.Get.to(
              SearchResultPage().buildPage({"keyword": values}),
            ).then((value) {
              List<String> lists =
                  state.prefs.getStringList("history")?.toSet()?.toList();
              state.searchLists = lists;
              dispatch(SearchActionCreator.reFresh());
            });
          }
        },
      ),
      body: pullYsRefresh(
        refreshController: state.refreshController,
        enablePullDown: false,
        enablePullUp: false,
        child: Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 22.w,
                ),
              ),
              SliverVisibility(
                visible:
                    state.searchLists == null || state.searchLists.length == 0
                        ? false
                        : true,
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        "历史记录",
                        style: TextStyle(color: Colors.white, fontSize: 18.nsp),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          dispatch(SearchActionCreator.clearHistory());
                        },
                        child: Image.asset(
                          "assets/weibo/lajitong.png",
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverVisibility(
                visible:
                    state.searchLists == null || state.searchLists.length == 0
                        ? false
                        : true,
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10.w,
                  ),
                ),
              ),
              state.searchLists == null || state.searchLists.length == 0
                  ? SliverToBoxAdapter(
                      child: Container(),
                    )
                  : SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: 7,
                      children: state.searchLists.map((e) {
                        return GestureDetector(
                          onTap: () {
                            Gets.Get.to(
                              SearchResultPage().buildPage({"keyword": e}),
                            ).then((value) {
                              List<String> lists = state.prefs
                                  .getStringList("history")
                                  .toSet()
                                  .toList();
                              state.searchLists = lists;
                              dispatch(SearchActionCreator.reFresh());
                            });
                          },
                          child: Text(
                            e,
                            style: TextStyle(
                                color: Color.fromRGBO(124, 135, 159, 1),
                                fontSize: 15.nsp),
                          ),
                        );
                      }).toList(),
                    ),
              SliverVisibility(
                visible:
                    state.searchLists == null || state.searchLists.length == 0
                        ? false
                        : true,
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 25.w,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      "热门推荐",
                      style: TextStyle(color: Colors.white, fontSize: 18.nsp),
                    ),
                    Spacer(),
                    Image.asset(
                      "assets/weibo/huan_yi_huan.png",
                      width: 22.w,
                      height: 22.w,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        int count;
                        if (changeCount == 3) {
                          //count = 1;
                          changeCount = 1;
                        } else {
                          //count = state.changeCount += 1;
                          changeCount += 1;
                        }
                        dispatch(SearchActionCreator.onAction(count));
                      },
                      child: Text(
                        "换一换",
                        style: TextStyle(
                            color: Color.fromRGBO(100, 113, 141, 1),
                            fontSize: 16.nsp),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10.w,
                ),
              ),
              state.tagList == null || state.tagList.length == 0
                  ? SliverToBoxAdapter(
                      child: LoadingWidget(),
                    )
                  : SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: 7,
                      children: state.tagList[changeCount].map((e) {
                        return GestureDetector(
                          onTap: () {
                            Gets.Get.to(()=> SearchResultPage().buildPage({"keyword": e.name}));
                            AnalyticsEvent.clickToSearchHotTagEvent(e.name);
                          },
                          child:
                          Row(
                            children: [
                              Text(
                                e.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color.fromRGBO(124, 135, 159, 1),
                                    fontSize: 15.nsp),
                              ),
                              SizedBox(width: 2,),
                              TextUtil.isEmpty(e.desc)?SizedBox():Container(
                                width: 19,
                                height: 19,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors:e.desc=="爆"?[
                                      Color.fromRGBO(211, 31, 234, 1),
                                      Color.fromRGBO(255, 74, 74, 1),
                                    ]:e.desc=="荐"?[
                                      Color.fromRGBO(234, 93, 31, 1),
                                      Color.fromRGBO(234, 93, 31, 1),
                                    ]:[
                                    Color.fromRGBO(232, 79, 79, 1),
                                    Color.fromRGBO(232, 79, 79, 1),
                                  ],
                                 ),
                                 borderRadius: BorderRadius.all(Radius.circular(3))
                                ),
                                child: Text(e.desc,style: TextStyle(color: Color.fromRGBO(255, 253, 252, 1),fontSize: 12),),
                              )
                            ],
                          ),

                        );
                      }).toList(),
                    ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 31.w,
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      "猜你喜欢",
                      style: TextStyle(color: Colors.white, fontSize: 18.nsp),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        ///执行猜你喜欢-换一换
                        dispatch(SearchActionCreator.updateGuessLikeList(
                            state.changeCount));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/weibo/huan_yi_huan.png",
                              width: 22.w,
                              height: 22.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "换一换",
                              style: TextStyle(
                                  color: Color.fromRGBO(100, 113, 141, 1),
                                  fontSize: 16.nsp),
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
                  height: 30.w,
                ),
              ),
              state.guessLikeData == null
                  ? SliverToBoxAdapter(
                      child: LoadingWidget(),
                    )
                  : state.guessLikeShowList == null ||
                          state.guessLikeShowList.length == 0
                      ? SliverToBoxAdapter(child: CErrorWidget("暂无数据"))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Container(
                              color: AppColors.weiboBackgroundColor,
                              margin: EdgeInsets.only(bottom: 22.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Map<String, dynamic> arguments = {
                                            'uid': state
                                                .guessLikeShowList[index].uid,
                                            'uniqueId': DateTime.now()
                                                .toIso8601String(),
                                          };
                                          Gets.Get.to(
                                            BloggerPage(arguments),
                                          );
                                        },
                                        child: HeaderWidget(
                                          headPath: state
                                              .guessLikeShowList[index]
                                              .portrait,
                                          level: (state.guessLikeShowList[index]
                                                          ?.superUser ?? false)
                                              ? 1
                                              : 0,
                                          headWidth: 52.w,
                                          headHeight: 52.w,
                                          levelSize: 14.w,
                                          positionedSize: 0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Map<String, dynamic> arguments = {
                                            'uid': state
                                                .guessLikeShowList[index].uid,
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
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    state
                                                        .guessLikeShowList[
                                                            index]
                                                        .name,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            246, 197, 89, 1),
                                                        fontSize: 17.nsp),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Row(
                                                    children: state
                                                        .guessLikeShowList[
                                                            index]
                                                        .awardsImage
                                                        .map((e) {
                                                      return Row(
                                                        children: [
                                                          CustomNetworkImage(
                                                            imageUrl: e,
                                                            width: 18.w,
                                                            height: 18.w,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                Container(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 6.w,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "粉丝: ",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            124, 135, 159, 1),
                                                        fontSize: 13.nsp),
                                                  ),
                                                  Text(
                                                    state
                                                        .guessLikeShowList[
                                                            index]
                                                        .fans
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            124, 135, 159, 1),
                                                        fontSize: 13.nsp),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Visibility(
                                        visible: !state.guessLikeShowList[index]
                                                .hasFollow
                                            ? true
                                            : false,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await netManager.client.getFollow(
                                                state.guessLikeShowList[index]
                                                    .uid,
                                                true);

                                            Config.followBlogger[state
                                                .guessLikeShowList[index]
                                                .uid] = true;

                                            state.guessLikeShowList[index]
                                                .hasFollow = true;

                                            dispatch(SearchActionCreator
                                                .reFreshGuessYouLike(
                                                    state.guessLikeData));
                                          },
                                          child: Image.asset(
                                            "assets/weibo/guanzhu.png",
                                            width: 68.w,
                                            height: 26.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.w,
                                  ),
                                  state.guessLikeShowList[index].vInfos ==
                                              null ||
                                          state.guessLikeShowList[index].vInfos
                                                  .length ==
                                              0
                                      ? Container()
                                      : Container(
                                          height: 210.w,
                                          child: GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 6,
                                                    mainAxisSpacing: 6,
                                                    childAspectRatio:
                                                        126 / 210),
                                            itemCount: state
                                                .guessLikeShowList[index]
                                                .vInfos
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int indexs) {
                                              return Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Map<String, dynamic>
                                                            map = Map();
                                                        map['playType'] =
                                                            VideoPlayConfig
                                                                .VIDEO_TAG;
                                                        map['tagID'] = state
                                                                    .guessLikeShowList[
                                                                        index]
                                                                    .vInfos[0]
                                                                    .tags
                                                                    .length ==
                                                                0
                                                            ? null
                                                            : state
                                                                .guessLikeShowList[
                                                                    index]
                                                                .vInfos[0]
                                                                .tags[0]
                                                                .id;
                                                        map['currentPosition'] =
                                                            indexs;
                                                        map['pageNumber'] = 1;
                                                        map['uid'] = state
                                                            .guessLikeShowList[
                                                                index]
                                                            .uid;
                                                        map['pageSize'] = 20;
                                                        map['videoList'] = state
                                                            .guessLikeShowList[
                                                                index]
                                                            .vInfos
                                                            .map((it) => VideoModel
                                                                .fromJson(it
                                                                    .toJson()))
                                                            .toList();

                                                        Gets.Get.to(
                                                          SubPlayListPage()
                                                              .buildPage(map),
                                                        );
                                                      },
                                                      child: CustomNetworkImage(
                                                        fit: BoxFit.cover,
                                                        height: 190.w,
                                                        width: 126.w,
                                                        placeholder:
                                                            Image.asset(
                                                          "assets/weibo/loading_normal.png",
                                                          fit: BoxFit.cover,
                                                        ),
                                                        imageUrl: state
                                                            .guessLikeShowList[
                                                                index]
                                                            .vInfos[indexs]
                                                            .cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3.w,
                                                  ),
                                                  Text(
                                                    state
                                                        .guessLikeShowList[
                                                            index]
                                                        .vInfos[indexs]
                                                        .title,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.w),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                ],
                              ),
                            );
                          }, childCount: state.guessLikeShowList?.length ?? 0),
                        ),
            ],
          ),
        ),
      ),
    ),
  );
}
