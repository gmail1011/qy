import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SearchTagState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: BaseRequestView(
      controller: state.baseRequestController,
      child: pullYsRefresh(
        // enablePullDown: false,
        onLoading: () {
          dispatch(SearchTagActionCreator.loadMoedData());
        },
        onRefresh: () {
          dispatch(SearchTagActionCreator.loadData());
        },
        refreshController: state.refreshController,
        child: ListView.builder(
          itemCount: state.searchTags?.length ?? 0,
          padding: EdgeInsets.only(left: 0),
          itemBuilder: (BuildContext context, int index) {
            var item = state.searchTags[index];
            return Container(
              child: GestureDetector(
                onTap: () {
                  Map<String, dynamic> maps = Map();
                  maps['tagId'] = item.id;
                  JRouter().go(PAGE_TAG, arguments: maps);
                },
                child: Container(
                  color: Colors.transparent,
                  width: Dimens.pt360,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          padding:
                              EdgeInsets.only(left: 0, top: 10, bottom: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: 35,
                                  height: 35,
                                  child: GestureDetector(
                                    child: svgAssets(
                                        item.hasCollected == true
                                            ? AssetsSvg
                                                .SEARCH_PAGE_SEARCH_RED_HEART
                                            : AssetsSvg
                                                .SEARCH_PAGE_SEARCH_BLACK_HEART,
                                        width: 35,
                                        height: 35),
                                    onTap: () {
                                      dispatch(
                                          SearchTagActionCreator.collectTag(
                                              index));
                                    },
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 2),
                                  child: Text(
                                    '  #${item.name}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ))
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          (item?.playCount ?? 0) >= 10000
                              ? '${((item?.playCount ?? 0) / 10000).toStringAsFixed(2)}${Lang.W_COUNT_PLAY}'
                              : '${item?.playCount}' + Lang.GOLD_2,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
