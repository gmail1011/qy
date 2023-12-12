import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/widget/full_list_view.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/local_server/m3u_preload.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    SubPlayListState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.videoBackgroundColor,
    body: _getPageView(state, dispatch, viewService),
    // endDrawer: !state.canDrawer ? null : _getDrawer(state),
    // drawerEdgeDragWidth: 120,
  );
}

/// 获取水平的pageview
Widget _getPageView(
    SubPlayListState state, Dispatch dispatch, ViewService viewService) {
  return ExtendedTabBarView(
    physics: state.canDrawer ? null : NeverScrollableScrollPhysics(),
    controller: state.tabController,
    children: <Widget>[
      _getMain(state, dispatch, viewService),
      _getUserCenter(state),
    ],
  );
}

Widget _getMain(
    SubPlayListState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  // l.i("subPlaylist", "onPageChanged()...initPosition:${state.curVideoIndex}");
  return Stack(
    children: <Widget>[
      FullListView(
          itemCount: adapter.itemCount,
          itemBuilder: adapter.itemBuilder,
          initPlayPosition: state.curVideoIndex,
          onPageChanged: (index) {
            l.i("subPlaylist",
                "onPageChanged()...old:${state.curVideoIndex} index:$index");
            if (index == state.curVideoIndex) return;
            // if (state.videoList[state.curVideoIndex].videoModel.isVideo()) {
            //   autoPlayModel.disposeAll();
            // }
            state.curVideoIndex = index;
            eagleClick(state.selfId(),
                          sourceId: state.eagleId(viewService.context),
                          label: state.type.toString());
            //更新下一个播放索引
            dispatch(SubPlayListActionCreator.setAutoPlayIndex(index));

            ///二级播放页面可以不用缓存 数据，有点费cdn流量
            if (index + 1 < state.videoList.length) {
              M3uPreload().preCacheNext(
                  state.videoList[index + 1]?.videoModel?.sourceURL,
                  skipPath: state.videoList[index]?.videoModel?.sourceURL);
            }

            if (state.hasNext && state.videoList.length - index <= 6) {
              dispatch(SubPlayListActionCreator.loadData());
            } else if (!state.hasNext &&
                (state.videoList.length - 1) <= index) {
              showToast(
                  msg: Lang.NO_MORE_DATA, toastLength: Toast.LENGTH_SHORT);
            }
          }),
      // PageView.builder(
      //   controller: state.pageController,
      //   itemCount: adapter.itemCount,
      //   itemBuilder: adapter.itemBuilder,
      //   physics: ClampingScrollPhysics(),
      //   pageSnapping: true,
      //   scrollDirection: Axis.vertical,
      //   onPageChanged: (index) {
      //     l.i("subPlaylist",
      //         "onPageChanged()...old:${state.curVideoIndex} index:$index");
      //     if (index == state.curVideoIndex) return;
      //     // if (state.videoList[state.curVideoIndex].videoModel.isVideo()) {
      //     //   autoPlayModel.disposeAll();
      //     // }
      //     state.curVideoIndex = index;
      //     //更新下一个播放索引
      //     dispatch(SubPlayListActionCreator.setAutoPlayIndex(index));

      //     ///二级播放页面可以不用缓存 数据，有点费cdn流量
      //     if (index + 1 < state.videoList.length) {
      //       M3uPreload().preCacheNext(
      //           state.videoList[index + 1]?.videoModel?.sourceURL,
      //           skipPath: state.videoList[index]?.videoModel?.sourceURL);
      //     }

      //     if (state.hasNext && state.videoList.length - index <= 6) {
      //       dispatch(SubPlayListActionCreator.loadData());
      //     } else if (!state.hasNext && (state.videoList.length - 1) <= index) {
      //       showToast(msg: Lang.NO_MORE_DATA, toastLength: Toast.LENGTH_SHORT);
      //     }
      //   },
      // ),
      Positioned(
        top: Dimens.pt40,
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              safePopPage();
            }),
      ),
    ],
  );
}

Widget _getUserCenter(SubPlayListState state) {
  /*return routers.buildPage(PAGE_VIDEO_USER_CENTER, {
    'uniqueId': state.uniqueId,
    KEY_VIDEO_LIST_TYPE: VideoListType.SECOND,
    // 'uid': newUid,
  });*/


  Map<String, dynamic> map = {
    'uniqueId': state.uniqueId,
    'uid': state.videoList[state.curVideoIndex].videoModel.publisher?.uid,
  };

  return BloggerPage(map);

}
