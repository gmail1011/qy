import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/page/anwang_trade/AnWangTradePage.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import '../../utils/EventBusUtils.dart';
import '../widget/bloggerPage.dart';
import 'community_follow_action.dart';
import 'community_follow_state.dart';
import 'hot_up_list_view.dart';

Widget buildView(
    CommunityFollowState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    color: AppColors.weiboBackgroundColor,
    child: pullYsRefresh(
      refreshController: state.refreshController,
      // enableTwoLevel:true,
      // canTwoLevelText:"松手进入暗网交易",
      // onTwoLevel:(){
      //   Map<String, dynamic> maps = Map();
      //   Gets.Get.to(AnWangTradePage()).then((value) {
      //     state.refreshController.requestRefresh();
      //   });
      // },
      onRefresh: () {
        dispatch(CommunityFollowActionCreator.onLoadMore(state.pageNumber = 1));
      },
      onLoading: () {
        dispatch(
            CommunityFollowActionCreator.onLoadMore(state.pageNumber += 1));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 16.w,
            ),
          ),
          state.commonPostRes == null
              ? SliverToBoxAdapter(
                  child: Padding(
                  padding: EdgeInsets.only(top: 200.w),
                  child: LoadingWidget(),
                ))
              : state.commonPostRes.vInfo == null ||
                      state.commonPostRes.vInfo.length == 0
                  ? SliverToBoxAdapter(child: CErrorWidget("暂无数据"))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (index == 0)
                          return HotUpListView(toBloggerTap: (item) async {
                            Map<String, dynamic> arguments = {
                              'uid': item?.uid,
                              'uniqueId': DateTime.now().toIso8601String(),
                            };
                            bus.emit(EventBusUtils.closeActivityFloating);
                            await Gets.Get.to(() => BloggerPage(arguments),
                                    opaque: false)
                                .then((value) {
                              bus.emit(EventBusUtils.showActivityFloating);
                            });
                          });
                        return WordImageWidget(
                          key: UniqueKey(),
                          videoModel: state.commonPostRes.vInfo[index - 1],
                          index: index,
                        );
                      }, childCount: state.commonPostRes.vInfo.length + 1),
                    ),
        ],
      ),
    ),
  );
}
