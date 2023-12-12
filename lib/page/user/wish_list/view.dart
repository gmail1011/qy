import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/page/user/wish_list/wish_publish/page.dart';
import 'package:flutter_app/page/user/wish_list/wish_question/page.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'state.dart';

///心愿工单
Widget buildView(
    WishlistState state, Dispatch dispatch, ViewService viewService) {
  const _myTabs = ["问题", "发布", "我的"];

  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => safePopPage(),
        ),
        title: Text("我要求片", style: TextStyle(fontSize: AppFontSize.fontSize18)),
        actions: [
          const SizedBox(width: 50),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(25),
          child: commonTabBar(
            TabBar(
              controller: state.tabBarController,
              tabs: _myTabs.map((e) => Text(e)).toList(),
              indicator: RoundUnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.weiboColor, width: 2),
              ),
              indicatorWeight: 4,
              unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
              labelColor: Colors.white,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 30),
              labelStyle: TextStyle(fontSize: Dimens.pt16),
              unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: state.tabBarController,
        children: [
          KeepAliveWidget(WishQuestionPage().buildPage({"questionType": 0})),
          KeepAliveWidget(WishPublishPage().buildPage(null)),
          KeepAliveWidget(WishQuestionPage().buildPage({"questionType": 1})),
        ],
      ),
    ),
  );
}
