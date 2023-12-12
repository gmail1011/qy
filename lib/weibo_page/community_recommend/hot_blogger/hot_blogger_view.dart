import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:get/route_manager.dart' as Gets;
import 'hot_blogger_action.dart';
import 'hot_blogger_state.dart';

Widget buildView(
    HotBloggerState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: AppColors.weiboBackgroundColor,
    appBar: getCommonAppBar("热门UP主"),
    body: state.bloggerDataList == null
        ? LoadingWidget()
        : pullYsRefresh(
            refreshController: state.refreshController,
            onLoading: () {

            },
            onRefresh: () {
              dispatch(HotBloggerActionCreator.onRefreshData());
            },
            enablePullUp: false,
            child: ListView.builder(
              itemCount: state.bloggerDataList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> arguments = {
                      'uid': state.bloggerDataList[index].uid,
                      'uniqueId': DateTime.now().toIso8601String(),
                    };

                    await Gets.Get.to(() => BloggerPage(arguments),
                        opaque: false);
                    /*if (item?.hasFollow == false) {
                      dispatch(CommunityRecommendActionCreator.checkFollowUser(
                          item?.uid, changeDataIndex));
                    }*/
                  },
                  child: Container(
                    width: screen.screenWidth,
                    height: Dimens.pt120,
                    padding: EdgeInsets.only(bottom: 10, left: 12, right: 12),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 12, right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.weiboJianPrimaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: CustomNetworkImage(
                              imageUrl: state.bloggerDataList[index].portrait,
                              width: Dimens.pt100,
                              height: Dimens.pt100,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 12, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: Dimens.pt122,
                                        child: Text(
                                          state.bloggerDataList[index].name,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: Dimens.pt16,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Spacer(),
                                      !state.bloggerDataList[index].hasFollow
                                          ? GestureDetector(
                                        onTap: () async {
                                          Map map = {};
                                          int followUID = map["uid"];
                                          int changeDataIndex =
                                          map["changeDataIndex"];

                                          await netManager.client.getFollow(
                                              state.bloggerDataList[index]
                                                  .uid,
                                              !state.bloggerDataList[index]
                                                  .hasFollow);

                                          Config.followBlogger[state
                                              .bloggerDataList[index]
                                              .uid] =
                                          !state.bloggerDataList[index]
                                              .hasFollow;

                                          state.bloggerDataList[index]
                                              .hasFollow =
                                          !state.bloggerDataList[index]
                                              .hasFollow;
                                          dispatch(HotBloggerActionCreator
                                              .onRefreshFollow(
                                              state.bloggerDataList));
                                        },
                                        child: Image.asset(
                                          "assets/weibo/guanzhu.png",
                                          width: Dimens.pt66,
                                          height: Dimens.pt25,
                                        ),
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  //width: 220,
                                  margin: EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                  ),
                                  child: Text(
                                    state.bloggerDataList[index].summary,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Color.fromRGBO(194, 194, 194, 1)),
                                  ),
                                ),
                                Container(
                                  //width: 200,
                                  margin: EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "作品数: " +
                                            state
                                                .bloggerDataList[index].totalWorks
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: Dimens.pt12,
                                            color:
                                            Color.fromRGBO(194, 194, 194, 1)),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Text(
                                            "查看全部作品",
                                            style: TextStyle(
                                                fontSize: Dimens.pt12,
                                                color: Color.fromRGBO(
                                                    255, 167, 86, 1)),
                                          ),
                                          Image.asset(
                                            "assets/images/double_right.png",
                                            width: Dimens.pt16,
                                            height: Dimens.pt16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                );
              },
            ),
          ),
  );
}
