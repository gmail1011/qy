import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    NovelSearchState state, Dispatch dispatch, ViewService viewService) {
  List list = state.type == NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL
      ? state.list
      : state.audioList;
  return GestureDetector(
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(FocusNode());
    },
    child: FullBg(
      child: Scaffold(
        appBar: SearchAppBar(
          controller: state.textEditingController,
          showPopBtn: false,
          onSubmitted: (text) {
            dispatch(NovelSearchActionCreator.onSubmitted(text));
          },
        ),
        body: PullRefreshView(
          onLoading: () {
            dispatch(NovelSearchActionCreator.moreData());
          },
          onRefresh: () {
            dispatch(NovelSearchActionCreator.refresh());
          },
          retryOnTap: () {
            dispatch(NovelSearchActionCreator.moreData());
          },
          controller: state.pullController,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverVisibility(
                visible: (state.searchHistorys?.length ?? 0) != 0,
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: AppPaddings.appMargin,
                        right: AppPaddings.appMargin,
                        top: 23),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              Lang.SEARCH_HISTORY_TITLE,
                              style: TextStyle(
                                  color: Color(0xFFFF0000),
                                  fontSize: Dimens.pt16),
                            ),
                            GestureDetector(
                              child: Text(
                                Lang.DEL_HISTORY_TITLE,
                                style: TextStyle(
                                    color: Color.fromRGBO(188, 188, 188, 1),
                                    fontSize: Dimens.pt12),
                              ),
                              onTap: () {
                                dispatch(NovelSearchActionCreator.deleteAll());
                              },
                            )
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8),
                          itemBuilder: (context, index) {
                            var string = state.searchHistorys[index];
                            return GestureDetector(
                              onTap: () {
                                dispatch(NovelSearchActionCreator.onSubmitted(
                                    string));
                              },
                              child: _searchHistoryItem(string, () {
                                dispatch(
                                    NovelSearchActionCreator.delete(index));
                              }),
                            );
                          },
                          itemCount: state.showAll
                              ? state.searchHistorys?.length ?? 0
                              : ((state.searchHistorys?.length ?? 0) >
                                      state.showSearchHistoryNum)
                                  ? state.showSearchHistoryNum
                                  : (state.searchHistorys?.length ?? 0),
                        ),
                        Visibility(
                          visible: !state.showAll &&
                              (state.searchHistorys?.length ?? 0) >
                                  state.showSearchHistoryNum,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                dispatch(NovelSearchActionCreator.showAll());
                              },
                              child: Text(
                                Lang.ALL_SEARCH_HISTORY,
                                style: TextStyle(
                                    color: Color.fromRGBO(188, 188, 188, 1),
                                    fontSize: Dimens.pt12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: AppPaddings.appMargin,
                  ),
                  child: Text(
                    "热门小说",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.pt16,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var item = list[index];
                    return hotItem(index, item, onClick: () {
                      if (state.type == NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL) {
                        JRouter()
                            .go(PAGE_NOVEL_PLAYER, arguments: {'id': item.id});
                      } else {
                        JRouter()
                            .go(AUDIO_NOVEL_PAGE, arguments: {"id": item.id});
                      }
                    });
                  },
                  childCount: list.length,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

_searchHistoryItem(String title, VoidCallback deleteClick) {
  return Container(
    color: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: Colors.white,
              size: 13,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              title ?? '',
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
            )
          ],
        ),
        GestureDetector(
          child: Container(
              child: Icon(
            Icons.clear,
            color: Color(0xff999999),
            size: 16,
          )),
          onTap: deleteClick,
        )
      ],
    ),
  );
}
