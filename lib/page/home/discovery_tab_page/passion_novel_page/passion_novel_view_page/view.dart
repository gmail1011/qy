import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PassionNovelViewState state, Dispatch dispatch, ViewService viewService) {
  var list = state.list;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
    child: PullRefreshView(
      emptyText: state.target == NOVEL_ENTRANCE.SEARCH
          ? Lang.SEARCH_EMPTY_DATA
          : Lang.EMPTY_DATA,
      onLoading: () {
        dispatch(PassionNovelViewActionCreator.moreData());
      },
      onRefresh: () {
        dispatch(PassionNovelViewActionCreator.refresh());
      },
      retryOnTap: () {
        dispatch(PassionNovelViewActionCreator.moreData());
      },
      controller: state.pullController,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = list[index];
          return passionItem(item, (noveItem) {
            dispatch(PassionNovelViewActionCreator.replaceItem(noveItem));
          }, state, context);
        },
        itemCount: list.length,
      ),
    ),
  );
}
