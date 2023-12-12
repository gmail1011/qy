import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'state.dart';

Widget buildView(
    RecordingState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      //appBar: getCommonAppBar(Lang.RECORD),
      appBar: AppBar(
        title: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
          labelStyle: TextStyle(
            fontSize: Dimens.pt16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: Dimens.pt16,
          ),
          controller: state.tabBarTitleController,
          unselectedLabelColor: Colors.white.withOpacity(0.4),
          labelColor: Colors.white,
          tabs: state.tabTitleList?.map((it) => Tab(text: it))?.toList(),
        ),
      ),
      body: ExtendedTabBarView(
          controller: state.tabBarTitleController,
          children: [
            Column(
          children: [
            TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.white,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              labelStyle: TextStyle(
                fontSize: Dimens.pt16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: Dimens.pt16,
              ),
              controller: state.tabBarController,
              unselectedLabelColor: Colors.white.withOpacity(0.4),
              labelColor: Colors.white,
              tabs: state.tabList?.map((it) => Tab(text: it))?.toList(),
            ),
            Container(
              height: 1,
              color: Color(0x9C979797),
            ),
            Expanded(
              child: ExtendedTabBarView(
                controller: state.tabBarController,
                children: state.tabView,
              ),
            ),
          ],
        ),
      ]),
    ),
  );
}
