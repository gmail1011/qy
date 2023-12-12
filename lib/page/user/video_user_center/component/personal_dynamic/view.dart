import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../action.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    UserDynamicPostState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  return NotificationListener(
      onNotification: (notification) {
        switch (notification.runtimeType) {
          case ScrollStartNotification:
            viewService.broadcast(
                VideoUserCenterActionCreator.onShowFollowBtnUI(false));
            break;
          case ScrollEndNotification:
            viewService.broadcast(
                VideoUserCenterActionCreator.onShowFollowBtnUI(true));
            break;
          case ScrollUpdateNotification:
            if (notification.metrics.pixels < screen.displayHeight &&
                state.showToTopBtn) {
              state.showToTopBtn = false;
              viewService.broadcast(VideoUserCenterActionCreator.onIsShowTopBtn(
                  state.showToTopBtn));
            } else if (notification.metrics.pixels >= screen.displayHeight &&
                !state.showToTopBtn) {
              state.showToTopBtn = true;
              viewService.broadcast(VideoUserCenterActionCreator.onIsShowTopBtn(
                  state.showToTopBtn));
            }
            break;
        }
        return true;
      },
      child: !state.loadComplete
          ? Container(
              child: Center(
              child: LoadingWidget(),
            ))
          : EasyRefresh.custom(
              controller: state.controller,
              footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
              emptyWidget:
                  state.videoList.length != 0 ? null : EmptyWidget('user', 0),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    adapter.itemBuilder,
                   /* (context,index){
                       return ;
                    },*/
                    childCount: adapter.itemCount,
                  ),
                ),
              ],
              onLoad: () async {
                if (state.hasNext ?? false) {
                  dispatch(UserDynamicPostActionCreator.onLoadData());
                }
              },
            )
  );
}
