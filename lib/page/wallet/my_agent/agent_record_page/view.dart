import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/wallet/my_agent/agent_record_page/promote_income_page/page.dart';
import 'package:flutter_app/page/wallet/my_agent/agent_record_page/video_income_page/page.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'state.dart';
import 'withdraw_income_page/page.dart';

Widget buildView(
    AgentRecordState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: TabBar(
          tabs: Lang.AGENT_RECORD_TABS.map((v) {
            return Text(v);
          }).toList(),
          isScrollable: true,
          labelColor: AppColors.primaryRaised,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(
              fontSize: Dimens.pt17,
              color: AppColors.primaryRaised,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
              fontSize: Dimens.pt17,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          controller: state.tabController,
          indicatorColor: AppColors.primaryRaised,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
        ),
      ),
      body: ExtendedTabBarView(
        controller: state.tabController,
        children: <Widget>[
          PromoteIncomePage().buildPage(null),
          VideoIncomePage().buildPage(null),
          WithdrawIncomePage().buildPage(null),
        ],
      ),
    ),
  );
}
