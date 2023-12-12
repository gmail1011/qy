import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/video/video_list_model/main_player_ui_show_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/page/home/index/action.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'state.dart';

Widget  buildView(IndexState state, Dispatch dispatch, ViewService viewService) {
  Widget pageView = ExtendedTabBarView(
    controller: state.pageController,
    //横向滚动
    physics: ScrollPhysics(),
    children: state.pageList,
  );

  var tabWidgets = <Widget>[
    Consumer<MainPlayerUIShowModel>(builder:
        (BuildContext context, MainPlayerUIShowModel value, Widget child) {
      return value.isShow
          ? GestureDetector(
              onTap: () {
                state.pageController.animateTo(0);
              },
              child: Container(
                child: Text(
                  state.tabList[0],
                ),
              ),
            )
          : Container();
    }),
    Consumer<MainPlayerUIShowModel>(builder:
        (BuildContext context, MainPlayerUIShowModel value, Widget child) {
      return value.isShow
          ? GestureDetector(
              onTap: () {
                state.pageController.animateTo(1);
              },
              child: Container(
                padding: EdgeInsets.only(left: 30.w),
                child: Text(
                  state.tabList[1],
                ),
              ),
            )
          : Container();
    }),
    Consumer<MainPlayerUIShowModel>(builder:
        (BuildContext context, MainPlayerUIShowModel value, Widget child) {
      return Container();
    }),
  ];

  return Stack(
    children: <Widget>[
      pageView,
      Positioned(
        top: screen.topDistanceH,
        left: 0,
        right: 0,
        child: state.currentIndex == 2
            ? Container()
            : Consumer<MainPlayerUIShowModel>(builder: (BuildContext context,
                MainPlayerUIShowModel value, Widget child) {
                return value.isShow
                    ? Container(
                        alignment: Alignment.center,
                        child: TabBar(
                          tabs: tabWidgets,
                          isScrollable: true,
                          labelStyle: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 22.w,
                          ),
                          unselectedLabelStyle: TextStyle(
                              color: Colors.grey[400], fontSize: 22.w),
                          controller: state.pageController,
                          labelPadding: EdgeInsets.all(0),
                          indicator: RoundUnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3.5,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )
                    : Container();
              }),
      ),
      Positioned(
        top: screen.topDistanceH,
        right: Dimens.pt16,
        child: state.currentIndex == 2
            ? Container()
            : Consumer<MainPlayerUIShowModel>(
                builder: (BuildContext context, MainPlayerUIShowModel model,
                    Widget child) {
                  return model.isShow
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                              padding: EdgeInsets.only(top: 6),
                              child: svgAssets(AssetsSvg.IC_SEARCH,
                                  height: Dimens.pt15)),
                          onTap: () {
                            dispatch(IndexActionCreator.onSearch());
                          },
                        )
                      : Container();
                },
              ),
      ),
    ],
  );
}
