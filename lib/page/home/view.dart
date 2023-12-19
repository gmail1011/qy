import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/page/game_surface/overlay/overlay_tool_wrapper.dart';
import 'package:flutter_app/page/home/mine/action.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/c_navigation_bar_item.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(HomeState state, Dispatch dispatch, ViewService viewService) {
  // 构建悬浮按钮工具
  Widget wrapOverlayTool({Widget child}) => Builder(
      builder: (ctx) => OverlayToolWrapper(
            child: child,
          ));

  //

  return wrapOverlayTool(
    child: WillPopScope(
        child: Scaffold(
          body: Stack(children: [
            Container(
                width: screen.screenWidth,
                height: screen.screenHeight,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: state.pageController,
                        children: state.pageList,
                      ),
                    ),
                    // 底部按钮及其他
                    Container(
                      color: Color.fromRGBO(21, 21, 21, 1),
                      height: screen.bottomNavBarH + screen.paddingBottom,
                      child: Column(
                        children: <Widget>[
                          CNavigationBarItem(
                            screenSize: screen.screenSize,
                            navBarH: screen.bottomNavBarH,
                            onTap: (int index) {
                              // List tabList = Config.playGame
                              // ? ['社区', '抖音',  '游戏', '楼凤', '会员','我的']
                              //     : ['社区', '抖音',  '楼凤', '会员','我的'];

                              clearAllCache();

                              List tabList = ['首页', '猎奇', '社区','消息', '我的'];
                              if (state.currentIndex == index) {
                                return;
                              }
                              if (index == 4) {
                                viewService.broadcast(MineActionCreator.onUpdateUserInfo());
                                viewService.broadcast(MineActionCreator.onUpdateWalletInfo());
                              }
                              dispatch(HomeActionCreator.changeTab(index));
                              AnalyticsEvent.clickToHomeTab(tabList[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            // 分享在videoItem里面，这里是一个假的位置
            Align(
              child: Padding(
                padding: EdgeInsets.only(bottom: Dimens.pt20 + screen.paddingBottom),
                child: Container(
                  key: state.intro.keys[0],
                  height: 20,
                  width: 20,
                  // color: Colors.red,
                ),
              ),
              alignment: Alignment.bottomCenter,
            ),
            // 发现在Cnaviitem里面，这里是一个假的位置
            Positioned(
              bottom: Dimens.pt168 + screen.paddingBottom,
              right: Dimens.pt25,
              child: Container(
                key: state.intro.keys[1],
                height: 25,
                width: 20,
                // color: Colors.red,
              ),
            ),
          ]),
        ),
        onWillPop: () async {
          if (state.lastPopTime == null || DateTime.now().difference(state.lastPopTime) > Duration(seconds: 2)) {
            state.lastPopTime = DateTime.now();
            if (viewService.context == null) return;
            showToast(msg: Lang.EXIT_CONTENT);
          } else {
            state.lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return;
        }),
  );
}
