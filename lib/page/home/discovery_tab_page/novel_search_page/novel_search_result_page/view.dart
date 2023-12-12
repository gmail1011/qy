import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_data_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/passion_novel_view_page/page.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    NovelSearchResultState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: SearchAppBar(
        controller: state.editingController,
        isSearchBtn: true,
        onSubmitted: (text) {
          dispatch(NovelSearchResultActionCreator.onSubmitted(text));
        },
      ),
      body: state.type == NOVEL_SEARCH_PAGE_TYPE.PAGE_AUDIOBOOK
          ? AudiobookDataListPage().buildPage({
              "type": 6,
              "typeStr": state.keywords,
            })
          : PassionNovelViewPage().buildPage({
              'target': NOVEL_ENTRANCE.SEARCH,
              'keyword': state.keywords,
            }),
    ),
  );
}
