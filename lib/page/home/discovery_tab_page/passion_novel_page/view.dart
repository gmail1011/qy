import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'state.dart';

Widget buildView(
    PassionNovelState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Scaffold(
          appBar: state.showTitle ? getCommonAppBar(Lang.PASSION_NOVEL) : null,
          body: state.tabController == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: Dimens.pt12),
                      child: UnderLineTabBar(
                        fontSize: Dimens.pt12,
                        tabController: state.tabController,
                        tabs: state.tabNames,
                        insetsBottom: 0,
                      ),
                    ),
                    Expanded(
                      child: ExtendedTabBarView(
                        controller: state.tabController,
                        children: state.tabViewList,
                      ),
                    ),
                  ],
                )));
}
