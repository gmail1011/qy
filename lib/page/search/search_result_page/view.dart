import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';

import 'package:flutter_app/page/search/search_result_page/search_tag_page/page.dart';
import 'package:flutter_app/page/search/search_result_page/search_user_page/page.dart';
import 'package:flutter_app/page/search/search_result_page/search_video_page/page.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/hj_custom_tabbar.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';

import 'hjll_search_result_page/HjllSearchPostResultPage.dart';
import 'hjll_search_result_page/HjllSearchVideoResultPage.dart';
import 'state.dart';

Widget buildView(SearchResultState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      // appBar: SearchAppBar(
      //   controller: state.editingController,
      //   isSearchBtn: true,
      //   autofocus: false,
      //   onSubmitted: (text) {
      //     dispatch(SearchResultActionCreator.onSubmitted(text));
      //   },
      // ),
      appBar: getCommonAppBar("搜索结果"),
      body: Container(
        child: Column(
          children: [
            // TabBar(
            //   isScrollable: false,
            //   indicatorSize: TabBarIndicatorSize.tab,
            //   indicatorColor: AppColors.primaryRaised,
            //   labelStyle: TextStyle(
            //     fontSize: Dimens.pt14,
            //     fontWeight: FontWeight.w700,
            //   ),
            //   unselectedLabelStyle: TextStyle(
            //     fontSize: Dimens.pt14,
            //   ),
            //   controller: state.tabController,
            //   unselectedLabelColor: Colors.white,
            //   labelColor: AppColors.primaryRaised,
            //   tabs: state.myTabs,
            // ),
            Container(
              height: 32,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: HJCustomTabBar(
                ["视频", "帖子"],
                state.tabController,
                isSearchStyle: true,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  HjlSearchVideoResultPage(keywords: state.keywords),
                  HjlSearchPostResultPage(keywords: state.keywords),
                ],
                controller: state.tabController,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
