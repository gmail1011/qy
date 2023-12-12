import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/page/publish/sexyplaza/sexy_plaza_page.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/flutter_base.dart';

import 'makeVideo/make_video_page.dart';
import 'publish_action.dart';
import 'publish_state.dart';

Widget buildView(
    PublishState state, Dispatch dispatch, ViewService viewService) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: state.tabController,
          tabs: [
            // Text(
            //   "创作视频",
            //   style:
            //       TextStyle(fontSize: Dimens.pt18, fontWeight: FontWeight.w600),
            // ),
            Text(
              "性福广场",
              style:
                  TextStyle(fontSize: Dimens.pt18, fontWeight: FontWeight.w600),
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.8),
          indicator: RoundUnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: state.tabController,
        children: [
          // KeepAliveWidget(MakeVideoPage().buildPage(null)),
          KeepAliveWidget(SexyPlazaPage().buildPage(null)),
        ],
      ),
    ),
  );
}
