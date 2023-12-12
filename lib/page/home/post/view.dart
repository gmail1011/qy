import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/page.dart';
import 'package:flutter_app/page/home/post/page/common_post_discovery/page.dart';
import 'package:flutter_app/page/home/post/page/common_post_tab/page.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/page/search/search_view/search_appbar_liaoba.dart';
import 'package:flutter_app/widget/YYMarquee.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/post/action.dart';
import 'package:flutter_app/page/home/post/page/common_post/page.dart';
import 'package:flutter_app/page/home/post/page/pay_post/page.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'ads_banner_widget.dart';
import 'state.dart';

Widget buildView(
  PostState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Widget bannerWidget = AdsBannerWidget(
    state.adsList,
    width: Dimens.pt360,
    height: Dimens.pt300,
    onItemClick: (index) {
      var ad = state.adsList[index];
      JRouter().handleAdsInfo(ad.href, id: ad.id);
      /*eagleClick(state.selfId(),
          sourceId: state.eagleId(viewService.context),
          label: "banner(${ad?.id ?? ""})");*/
    },
  );

  /*var tabWidgets = <Widget>[
    //推荐
    Tab(text: state.tabList[0]),
    //最新
    Tab(text: state.tabList[1]),
    //附近
    Tab(text: state.tabList[2]),
    //原创
    Tab(text: state.tabList[3]),
    //会员
    Tab(text: state.tabList[4]),
  ];*/

  /*var tabWidgets = <Widget>[
    //推荐
    Tab(text: state.tabList[0]),
    //最新
    Tab(text: state.tabList[1]),
    //附近
    Tab(text: state.tabList[2]),
    //原创
    Tab(text: state.tabList[3]),
    //会员
    Tab(text: state.tabList[4]),
  ];*/

  var tabWidgets = Config.homeDataTags.map((e) {
    return Tab(text: e.subModuleName);
  }).toList();

  List<Widget> widgets = [];

  for (int i = 0; i < Config.homeDataTags.length - 1; i++) {
    if (i == 0) {
      widgets.add(extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab0'),
          //推荐
          CommonPostPage().buildPage({
            "type": "1",
            "subType": "0",
            "initList": state.list,
            "adsList": state.adsList
          })));

    } else if (Config.homeDataTags[i].subModuleName == "发现") {
      widgets.add(extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab1'),
          CommonPostDiscoveryPage().buildPage({"type": "0", "subType": "0"})));
    } else {
      widgets.add(KeepAliveWidget(CommonPostTabPage().buildPage({
        "type": "0",
        "subType": "0",
        "index": i,
      })));
    }
  }

  widgets.add(extended.NestedScrollViewInnerScrollPositionKeyWidget(
      Key('AudiobookPage'),
      AudiobookPage().buildPage(null)));

  var topBottomMargin =
      screen.bottomNavBarH + screen.paddingBottom + Dimens.pt40;
  var searchBottomMargin = topBottomMargin - Dimens.pt60;
  var rightMargin = Dimens.pt16;

  Widget _getUploadWidget() {
    if (TextUtil.isEmpty(state.taskId)) {
      return Positioned(
        right: rightMargin,
        bottom: searchBottomMargin,
        child: GestureDetector(
          onTap: () => dispatch(PostActionCreator.onSelectUploadType()),
          child: ImageLoader.withP(
            ImageType.IMAGE_SVG,
            address: AssetsSvg.PUBLISH,
            width: Dimens.pt40,
            height: Dimens.pt40,
          ).load(),
        ),
      );
    } else {
      return Positioned(
        right: Dimens.pt3,
        bottom: searchBottomMargin - Dimens.pt20,
        child: GestureDetector(
          onTap: () {
            if (state.uploadProgress < 0 && state.uploadRetryCnt < 4) {
              // l.i("post_view", "do retry taskId:${state.taskId} retryCnt:${state.uploadRetryCnt}");
              state.uploadRetryCnt++;
              taskManager.retry(state.taskId);
            }
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: Dimens.pt5),
                child: Text(
                  (state.uploadProgress < 0)
                      ? Lang.UPLOAD_FAILED_TIP
                      : Lang.UPLOADING_TIP,
                  style: TextStyle(
                      color: AppColors.primaryRaised,
                      fontSize: Dimens.pt16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x4c59253F),
                ),
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 2,
                  percent: state.uploadProgress < 0 ? 0 : state.uploadProgress,
                  animationDuration: 2000,
                  center: Text(
                    (state.uploadProgress < 0)
                        ? Lang.RETRY
                        : "${(((state.uploadProgress ?? 0) * 100).toInt())}%",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: AppColors.primaryRaised,
                    ),
                  ),
                  backgroundColor: Color(0x4cffffff),
                  progressColor: AppColors.primaryRaised,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  return KeyboardDismissOnTap(
    child: FullBg(
      child: Stack(
        children: <Widget>[
          extended.NestedScrollView(
            controller: state.scrollController,
            pinnedHeaderSliverHeightBuilder: () {
              return Dimens.pt44 + screen.paddingTop;
            },
            innerScrollPositionKeyBuilder: () {
              var index = "Tab";
              if (state.primaryTC.index == 0) {
                index += state.primaryTC.index.toString();
              } else if (state.primaryTC.index == 1) {
                index += (state.primaryTC.index.toString());
              } else if (state.primaryTC.index == 2) {
                index += state.primaryTC.index.toString();
              } else if (state.primaryTC.index == 3) {
                index += (state.primaryTC.index.toString() +
                    state.payTabController.index.toString());
              }
              return Key(index);
            },
            headerSliverBuilder: (c, f) {
              var expandedHeight = 0.0;
              /*if (Platform.isIOS && screen.paddingTop > 20) {
                expandedHeight = Dimens.pt250 + Dimens.pt8;
              } else {
                expandedHeight = Dimens.pt260 + Dimens.pt20;
              }*/

              if (Platform.isIOS && screen.paddingTop > 20) {
                expandedHeight = Dimens.pt90 + Dimens.pt8;
              } else {
                expandedHeight = Dimens.pt100 + Dimens.pt20;
              }

              return [
                SliverAppBar(
                    elevation: 0.0,
                    //expandedHeight: expandedHeight,
                    expandedHeight: Dimens.pt0,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: true,
                    snap: false,
                    primary: true,
                    /*flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        children: <Widget>[
                          bannerWidget,
                          getHengLine(),
                        ],
                      ),
                    ),*/
                    bottom: PreferredSize(
                        child: Container(
                          color: AppColors.primaryColor,
                          alignment: Alignment.bottomLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchAppBarLiaoBa(
                                  controller: state.controller,
                                  showPopBtn: false,
                                  autofocus: false,
                                  showCancelBtn: false,
                                  onTap: () async {
                                    await JRouter().go(PAGE_SPECIAL);
                                  },
                                ),

                                TabBar(
                                  tabs: tabWidgets,
                                  isScrollable: true,
                                  indicatorColor: Colors.white,
                                  labelStyle: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: Dimens.pt16),
                                  unselectedLabelStyle: TextStyle(
                                      color: Color(0xffBDBDBD),
                                      fontSize: Dimens.pt16),
                                  controller: state.primaryTC,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorWeight: 0,
                                  indicator: RoundUnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 3.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // getHengLine(h: 0.5),
                                Container(
                                  height: Dimens.pt24,
                                  color: Color.fromRGBO(242, 210, 158, 1),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: Dimens.pt28,
                                          right: Dimens.pt18,
                                        ),
                                        child: YYMarquee(
                                            Text(
                                                state.announce == null
                                                    ? " "
                                                    : state.announce.toString(),
                                                style: TextStyle(
                                                  fontSize: Dimens.pt12,
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1),
                                                )),
                                            200,
                                            new Duration(seconds: 5),
                                            230.0, keyName: "post_view"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: Dimens.pt10,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Image.asset(
                                            "assets/images/laba_vip.png",
                                            width: Dimens.pt16,
                                            height: Dimens.pt16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        preferredSize: Size(Dimens.pt360, Dimens.pt116)))
              ];
            },
            /*body: ExtendedTabBarView(
              controller: state.primaryTC,
              children: [
                //最热
                extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab0'),
                    //推荐
                    CommonPostPage().buildPage({
                      "type": "1",
                      "subType": "0",
                      "initList": state.list,
                      "adsList": state.adsList
                    })),
                extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab1'),
                    //最新
                    //CommonPostPage().buildPage({"type": "0", "subType": "0"})),
                    CommonPostDiscoveryPage().buildPage({"type": "0", "subType": "0"})),
                //CommonPostDiscoveryPage().buildPage({"type": "0", "subType": "0"}),
                extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab2'),
                    //同城
                    CommonPostPage().buildPage({"type": "2", "subType": "0"})),
                PayPostPage().buildPage({
                  "vc": state.payTabController,
                  "type": "3",
                  "subType": "0"
                }), //付费

                extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key('Tab4'),
                    //推荐
                    CommonPostPage().buildPage({
                      "type": "4",
                      "subType": "0",
                    })),
              ],
              linkWithAncestor: true,
            ),*/

            body: ExtendedTabBarView(
              controller: state.primaryTC,
              children: widgets,
              linkWithAncestor: true,
            ),
          ),

          //回到顶部
          state.showToTopBtn
              ? Positioned(
                  right: rightMargin,
                  bottom: topBottomMargin,
                  child: InkResponse(
                    splashColor: Colors.transparent,
                    child: ImageLoader.withP(ImageType.IMAGE_SVG,
                            address: AssetsSvg.BACK_TOP,
                            width: Dimens.pt40,
                            height: Dimens.pt40)
                        .load(),
                    onTap: () {
                      state.scrollController.animateTo(0.0,
                          duration: Duration(milliseconds: 50),
                          curve: Curves.easeIn);
                    },
                  ),
                )
              : Container(),

          /// 上传widget
         // _getUploadWidget()
        ],
      ),
    ),
  );
}
