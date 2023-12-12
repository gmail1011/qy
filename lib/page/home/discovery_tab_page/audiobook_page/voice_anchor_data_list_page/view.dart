import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(VoiceAnchorDataListState state, Dispatch dispatch,
    ViewService viewService) {
  return PullRefreshView(
    controller: state.pullRefreshController,
    retryOnTap: () {
      dispatch(VoiceAnchorDataListActionCreator.loadData());
    },
    onLoading: () {
      dispatch(VoiceAnchorDataListActionCreator.loadMoreData());
    },
    onRefresh: () {
      dispatch(VoiceAnchorDataListActionCreator.loadData());
    },
    child: ListView.builder(
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        var item = state.list[index];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            JRouter().go(PAGE_VOICE_ANCHOR_INFO, arguments: {'model': item});
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: AppPaddings.appMargin, vertical: 6),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0xFF2F2F5F),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                HeaderWidget(
                  headPath: item.avatar ?? '',
                  level: 0,
                  headWidth: Dimens.pt60,
                  headHeight: Dimens.pt60,
                ),
                Expanded(
                  child: Container(
                    height: Dimens.pt60,
                    padding: EdgeInsets.only(left: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          item.name ?? '',
                          style: TextStyle(
                            fontSize: AppFontSize.fontSize18,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "作品：${item.totalRaido ?? 0}部",
                              style: TextStyle(
                                fontSize: AppFontSize.fontSize12,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "收藏：${item.countCollect ?? 0}人",
                              style: TextStyle(
                                fontSize: AppFontSize.fontSize12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: state.list?.length ?? 0,
    ),
  );
}
