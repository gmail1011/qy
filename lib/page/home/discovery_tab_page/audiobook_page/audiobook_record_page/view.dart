import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_data_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/voice_anchor_data_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'audio_episode_record_page/page.dart';
import 'state.dart';

Widget buildView(
    AudiobookRecordState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: CustomAppbar(
        title: Lang.RECORD,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color(0xFFD8D8D8).withOpacity(.2), width: 1),
              ),
            ),
            width: double.infinity,
            margin: EdgeInsets.only(top: Dimens.pt5),
            alignment: Alignment.center,
            child: UnderLineTabBar(
              tabs: Lang.AUDIOBOOK_RECORDS_TABS,
              tabController: state.tabController,
              insetsBottom: 0,
              fontSize: Dimens.pt18,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: ExtendedTabBarView(
              children: [
                AudioEpisodeRecordPage().buildPage(null),
                AudiobookDataListPage().buildPage({'type': 3}),
                _collectView(state),
              ],
              controller: state.tabController,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _collectView(AudiobookRecordState state) {
  return Container(
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: AppPaddings.appMargin),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2F2F5F),
              borderRadius: BorderRadius.circular(Dimens.pt30),
            ),
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.transparent,
              controller: state.tabController1,
              labelPadding: EdgeInsets.symmetric(
                horizontal: Dimens.pt15,
                vertical: Dimens.pt3,
              ),
              labelColor: Colors.white.withOpacity(0.7),
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                  fontSize: AppFontSize.fontSize10,
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                  fontSize: AppFontSize.fontSize10,
                  fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.pt30),
                // gradient: LinearGradient(
                //     colors: [Color(0xFFFFDA7E), Color(0xFFFDC0BE)]),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color(0xFFFF245A).withOpacity(0.35),
                //     blurRadius: 3,
                //     offset: Offset(0, 2),
                //   )
                // ],
                color: Color(0xffFF84C3),
              ),
              tabs: Lang.AUDIOBOOK_COLLECT_TABS
                  .map((item) => Text(item))
                  .toList(),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: ExtendedTabBarView(
            children: [
              AudiobookDataListPage().buildPage({'type': 4}),
              VoiceAnchorDataListPage().buildPage({'type': 2}),
            ],
            controller: state.tabController1,
          ),
        ),
      ],
    ),
  );
}
