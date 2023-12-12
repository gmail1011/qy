import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/fuli_guangchang/qian_dao/qian_dao_page.dart';
import 'package:flutter_app/page/fuli_guangchang/ren_wu/ren_wu_page.dart';
import 'package:flutter_app/page/home/AVCommentary/a_v_commentary_page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/page/tag/video_topic/page.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'fu_li_guang_chang_action.dart';
import 'fu_li_guang_chang_state.dart';

Widget buildView(FuLiGuangChangState state, Dispatch dispatch, ViewService viewService) {

  return FullBg(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: Dimens.pt32,
          titleSpacing: 0,
          title: UnderLineTabBar(
            tabController: state.tabController,
            tabs: Lang.FU_LI_TABS,
            onTab: (index) {
              //dispatch(DiscoveryTabActionCreator.onRefreshUI());
            },
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: state.tabController,
            children: [
              qian_daoPage().buildPage(null),
              RenWuPage().buildPage(null),
            ],
          ),
        ),
      ));
}
