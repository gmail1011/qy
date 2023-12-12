import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/passion_novel_view_page/page.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'state.dart';

Widget buildView(
    PassionRecordingState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: CustomAppbar(title: Lang.RECORD,), 
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: Dimens.pt5),
            alignment: Alignment.center,
            child: UnderLineTabBar(
              tabs: Lang.RECORDS_TABS,
              tabController: state.tabController,
              insetsBottom: 0,
              fontSize: Dimens.pt18,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(.2),
                    width: .5
                  ),
                ),
              ),
              padding: EdgeInsets.only(top: AppPaddings.appMargin),
              child: TabBarView(
                controller: state.tabController,
                children: [
                  PassionNovelViewPage().buildPage({'target': NOVEL_ENTRANCE.BROWSE}),
                  PassionNovelViewPage().buildPage({'target': NOVEL_ENTRANCE.COLLECT}),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
