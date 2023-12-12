import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/user/common/module_type.dart';
import 'package:flutter_app/page/user/common/picture_word/page.dart';
import 'package:flutter_app/page/user/common/short_video/page.dart';
import 'package:flutter_app/page/user/common/video/page.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    MyPurchasesState state, Dispatch dispatch, ViewService viewService) {
  const List<String> _myTabs = [
    Lang.SELECT_TITLE3,
    Lang.SELECT_TITLE1,
    Lang.SELECT_TITLE4,
  ];

  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        titleSpacing: .0,
        title: Text(
          "我的购买",
          style: TextStyle(
              fontSize: AppFontSize.fontSize18,
              color: Colors.white,
              height: 1.4),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => safePopPage(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(25),
          child: commonTabBar(
            TabBar(
              isScrollable: true,
              controller: state.tabController,
              tabs: _myTabs.map((e) => Text(e)).toList(),
              indicator: RoundUnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.weiboColor, width: 2),
              ),
              indicatorWeight: 4,
              unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
              labelColor: Colors.white,
              labelPadding: EdgeInsets.symmetric(horizontal: 30),
              labelStyle: TextStyle(fontSize: Dimens.pt16),
              unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: state.tabController,
        children: [
          LongVideoPage()
              .buildPage({"type": ModuleType.LONG_VIDEO_MY_PURCHASES}),
          ShortVideoPage()
              .buildPage({"type": ModuleType.SHORT_VIDEO_MY_PURCHASES}),
          PictureWordPage()
              .buildPage({"type": ModuleType.PICTRUE_WORD_MY_PURCHASES}),
        ],
        dragStartBehavior: DragStartBehavior.down,
      ),
    ),
  );
}
