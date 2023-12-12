import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'entry_history_action.dart';
import 'entry_history_state.dart';

Widget buildView(
    EntryHistoryState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: CustomAppbar(
      title: "往届赛事",
    ),
    body: state.entryHistoryData == null ||
            state.entryHistoryData.activityList.length == 0
        ? Center(
            child: CErrorWidget(
              Lang.EMPTY_DATA,
              retryOnTap: () {
                dispatch(EntryHistoryActionCreator.onAction());
              },
            ),
          )
        : pullYsRefresh(
            refreshController: state.refreshController,
            onLoading: () {
              dispatch(
                  EntryHistoryActionCreator.onLoadMore(state.pageNumber += 1));
            },
            onRefresh: () {
              dispatch(
                  EntryHistoryActionCreator.onLoadMore(state.pageNumber = 1));
            },
            child: ListView.builder(
              itemCount: state.entryHistoryData.activityList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    safePopPage(state.entryHistoryData.activityList[index].id);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: Dimens.pt16,
                    ),
                    child: CustomNetworkImage(
                      imageUrl: state
                          .entryHistoryData.activityList[index].backgroundImage,
                      type: ImgType.cover,
                      height: Dimens.pt150,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
  );
}
