import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'add_action.dart';
import 'add_state.dart';

Widget buildView(AddState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: SearchAppBar(
      controller: state.textEditingController,
      autofocus: false,
      isSearchBtn: true,
      onSubmitted: (values) {
        if (TextUtil.isEmpty(values)) {
          showToast(msg: "请输入要搜索的用户");
          return;
        }
        //dispatch(AddActionCreator.setSearchUser(true));
        dispatch(AddActionCreator.setSearchUser(true));
        Future.delayed(Duration(milliseconds: 200), () {
          dispatch(AddActionCreator.onUserLoadMore(state.userPageNum = 1));
        });
      },
    ),
    body: Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: state.isSearchUser
          ? state.searchBeanData == null
              ? LoadingWidget()
              : state.searchBeanData.xList == null ||
                      state.searchBeanData.xList.length == 0
                  ? CErrorWidget("暂无数据")
                  : KeepAliveWidget(
                      pullYsRefresh(
                        refreshController: state.refreshUserController,
                        enablePullDown: false,
                        onRefresh: () {
                          dispatch(AddActionCreator.onUserLoadMore(
                              state.userPageNum = 1));
                        },
                        onLoading: () {
                          dispatch(AddActionCreator.onUserLoadMore(
                              state.userPageNum += 1));
                        },
                        child: ListView.builder(
                          itemCount: state.searchBeanData.xList.length,
                          itemBuilder: (context, index) {
                            return StatefulBuilder(builder: (context, states) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 16.w, right: 16.w, bottom: 6.w),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Map<String, dynamic> arguments = {
                                              'uid': state.searchBeanData
                                                  .xList[index].uid,
                                              'uniqueId': DateTime.now()
                                                  .toIso8601String(),
                                            };

                                            Gets.Get.to(BloggerPage(arguments),
                                                opaque: false);
                                          },
                                          child: HeaderWidget(
                                            headPath: state.searchBeanData
                                                    .xList[index]?.portrait ??
                                                "",
                                            level: (state
                                                            .searchBeanData
                                                            .xList[index]
                                                            ?.superUser ??
                                                        false)
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
                                            Map<String, dynamic> arguments = {
                                              'uid': state.searchBeanData
                                                  .xList[index].uid,
                                              'uniqueId': DateTime.now()
                                                  .toIso8601String(),
                                            };

                                            Gets.Get.to(BloggerPage(arguments),
                                                opaque: false);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.searchBeanData
                                                      .xList[index].name,
                                                  style: TextStyle(
                                                      color: (state.searchBeanData
                                                          .xList[index]?.isVip ?? false)
                                                          ? Color.fromRGBO(246, 197, 89, 1)
                                                          : Colors.white,
                                                      fontSize: 15.nsp),
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
                                                      color: Color.fromRGBO(
                                                          78, 88, 110, 1),
                                                      fontSize: 15.nsp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Visibility(
                                            visible: state.searchBeanData
                                                    .xList[index].hasFollowed
                                                ? false
                                                : true,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await netManager.client
                                                    .getFollow(
                                                        state.searchBeanData
                                                            .xList[index].uid,
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
                                                        .hasFollowed = false
                                                    : state
                                                        .searchBeanData
                                                        .xList[index]
                                                        .hasFollowed = true;

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
                    )
          : Column(
              children: [
                SizedBox(
                  height: 28.w,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "为你推荐",
                    style: TextStyle(color: Colors.white, fontSize: 18.nsp),
                  ),
                ),
                SizedBox(
                  height: 16.w,
                ),
                state.fansObj == null
                    ? LoadingWidget()
                    : state.fansObj.xList == null ||
                            state.fansObj.xList.length == 0
                        ? CErrorWidget("暂无数据")
                        : Expanded(
                            child: pullYsRefresh(
                              refreshController: state.refreshController,
                              enablePullDown: false,
                              onRefresh: () {
                                dispatch(AddActionCreator.onLoadMore(
                                    state.pageNumber = 1));
                              },
                              onLoading: () {
                                dispatch(AddActionCreator.onLoadMore(
                                    state.pageNumber += 1));
                              },
                              child: ListView.builder(
                                itemCount: state.fansObj.xList.length,
                                itemBuilder: (context, index) {
                                  return StatefulBuilder(
                                      builder: (context, states) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 6.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Map<String, dynamic>
                                                      arguments = {
                                                    'uid': state.fansObj
                                                        .xList[index].uid,
                                                    'uniqueId': DateTime.now()
                                                        .toIso8601String(),
                                                  };

                                                  Gets.Get.to(
                                                      BloggerPage(arguments),
                                                      opaque: false);
                                                },
                                                child: HeaderWidget(
                                                  headPath: state
                                                          .fansObj
                                                          .xList[index]
                                                          .portrait ??
                                                      "",
                                                  level: (state
                                                                  .fansObj
                                                                  .xList[index]
                                                                  ?.superUser ??
                                                              false)
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
                                                    'uid': state.fansObj
                                                        .xList[index].uid,
                                                    'uniqueId': DateTime.now()
                                                        .toIso8601String(),
                                                  };

                                                  Gets.Get.to(
                                                      BloggerPage(arguments),
                                                      opaque: false);
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        state.fansObj
                                                            .xList[index].name,
                                                        style: TextStyle(
                                                            color: (state.fansObj
                                                                .xList[index]?.isVip ?? false)
                                                                ? Color.fromRGBO(246, 197, 89, 1)
                                                                : Colors.white,
                                                            fontSize: 18.nsp),
                                                      ),
                                                      SizedBox(
                                                        height: 9.w,
                                                      ),
                                                      Text(
                                                        "粉丝: " +
                                                            state
                                                                .fansObj
                                                                .xList[index]
                                                                .fans
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
                                                              .fansObj
                                                              .xList[index]
                                                              .hasFollow ??
                                                          false
                                                      ? false
                                                      : true,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await netManager.client
                                                          .getFollow(
                                                              state
                                                                  .fansObj
                                                                  .xList[index]
                                                                  .uid,
                                                              !state
                                                                  .fansObj
                                                                  .xList[index]
                                                                  .hasFollow);

                                                      state.fansObj.xList[index]
                                                              .hasFollow
                                                          ? state
                                                              .fansObj
                                                              .xList[index]
                                                              .hasFollow = false
                                                          : state
                                                              .fansObj
                                                              .xList[index]
                                                              .hasFollow = true;

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
              ],
            ),
    ),
  );
}
