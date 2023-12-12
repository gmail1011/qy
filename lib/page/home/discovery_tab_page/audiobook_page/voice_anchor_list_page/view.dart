import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/voice_anchor_data_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'state.dart';

Widget buildView(
    VoiceAnchorListState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: CustomAppbar(
        title: "声优主播",
        actions: [
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
      body: VoiceAnchorDataListPage().buildPage(null),
    ),
  );
}
