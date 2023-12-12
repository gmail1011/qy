import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/page/publish/makeVideo/shouyi/shou_yi_detail_page.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'bang_dan_state.dart';

Widget buildView(
    BangDanState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: AppColors.primaryColor,
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => safePopPage(),
      ),
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: false,
      title: Text("榜单详情", style: TextStyle(fontSize: AppFontSize.fontSize18)),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(25),
        child: commonTabBar(
          TabBar(
            controller: state.tabController,
            tabs:
                state.rankTypeList.map((e) => Text(e.typeDesc ?? "")).toList(),
            unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
            labelColor: Colors.white,
            indicator: RoundUnderlineTabIndicator(
              borderSide: BorderSide(color: AppColors.weiboColor, width: 2),
            ),
            indicatorWeight: 4,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            labelStyle: TextStyle(fontSize: Dimens.pt16),
            unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
          ),
        ),
      ),
    ),
    body: TabBarView(
      controller: state.tabController,
      children: state.rankTypeList
          .map((rankType) => KeepAliveWidget(
              ShouYiDetailPage().buildPage({"rankType": rankType})))
          .toList(),
    ),
  );
}
