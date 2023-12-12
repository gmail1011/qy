import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_data_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'state.dart';

Widget buildView(
    AudiobookMoreState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Scaffold(
    body: Column(
      children: [
        _transparentAppbar(state),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: state.typeTabs.map((e) {
              return AudiobookDataListPage()
                  .buildPage({'type': 2, 'typeStr': e ?? ''});
            }).toList(),
          ),
        ),
      ],
    ),
  ));
}

/// 透明的appbar
Widget _transparentAppbar(AudiobookMoreState state) {
  return Container(
    width: screen.screenWidth,
    height: kToolbarHeight + screen.paddingTop,
    padding: EdgeInsets.only(
        right: AppPaddings.appMargin,
        top: screen.paddingTop,
        left: AppPaddings.appMargin),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: Dimens.pt26,
            width: Dimens.pt26,
            alignment: Alignment.center,
            child: svgAssets(AssetsSvg.BACK, fit: BoxFit.scaleDown),
          ),
          onTap: () {
            safePopPage();
          },
        ),
        Expanded(
          child: UnderLineTabBar(
            fontSize: Dimens.pt12,
            tabController: state.tabController,
            tabs: state.typeTabs ?? [],
            insetsBottom: 0,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.only(left: AppPaddings.appMargin),
            child: svgAssets(AssetsSvg.IC_SEARCH, height: Dimens.pt15),
          ),
          onTap: () {
            JRouter().go(PAGE_NOVEL_SEARCH,
                arguments: {"type": NOVEL_SEARCH_PAGE_TYPE.PAGE_AUDIOBOOK});
          },
        ),
      ],
    ),
  );
}
