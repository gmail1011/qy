import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/page/home/floating_move_view.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/user/member_centre_page/vip/vip_countdown_widget.dart';
import 'package:flutter_app/page/video/video_publish/page.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_page.dart';
import 'package:flutter_app/weibo_page/red_appbar_menu.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/alert_tool.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'community_action.dart';
import 'community_follow/community_follow_page.dart';
import 'community_state.dart';
import 'community_tab/page.dart';

Widget buildView(
    CommunityState state, Dispatch dispatch, ViewService viewService) {
  GlobalKey _rightKey = GlobalKey();
  return VisibilityDetector(
    key: Key("YYMarquee"),
    onVisibilityChanged: (visibleInfo) {
      if (visibleInfo.visibleFraction == 0) {
        bus.emit(EventBusUtils.closeActivityFloating);
      } else {
        bus.emit(EventBusUtils.showActivityFloating);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff151515),
        leadingWidth: 80.w,
        leading: UnconstrainedBox(
          child: Container(
            width: 80.w,
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      bus.emit(EventBusUtils.closeActivityFloating);
                      bus.emit(EventBusUtils.pausePlayer);
                      Gets.Get.to(SearchPage().buildPage(null), opaque: false)
                          .then((value) {
                        bus.emit(EventBusUtils.showActivityFloating);
                      });
                      AnalyticsEvent.clickToSearchEvent();
                    },
                    child: UnconstrainedBox(
                      child: SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: svgAssets(AssetsSvg.IC_SEARCH,
                            height: 20.w,
                            width: 20.w,
                            color: AppColors.weiboColor),
                      ),
                    )),
                SizedBox(
                  width: 16.w,
                ),
                VariableConfig.luckyDrawH5 == null ||
                        VariableConfig.luckyDrawH5 == ""
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          ///抽奖
                          ///
                          bus.emit(EventBusUtils.closeActivityFloating);

                          String token = await netManager.getToken();

                          Map<String, dynamic> arguments = {
                            "title": "抽奖",
                            "url": VariableConfig.luckyDrawH5 +
                                "&token=" +
                                token +
                                "&appUrl=" +
                                Address.baseHost
                          };

                          debugPrint(arguments.toString());

                          // 跳转链接
                          JRouter()
                              .go(PAGE_WEB, arguments: arguments)
                              .then((value) {
                            bus.emit(EventBusUtils.showActivityFloating);
                          });
                        },
                        child: Image.asset(
                          "assets/weibo/activity_icon.png",
                          width: 26.w,
                          height: 26.w,
                        ),
                      ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                },
                child: Image.asset(
                  "assets/weibo/signIn.png",
                  width: 20.w,
                  height: 24.w,
                ),
              ),
              SizedBox(
                width: 17.w,
              ),
              Container(
                height: double.infinity,
                key: _rightKey,
                padding: EdgeInsets.only(right: 18.w),
                child: GestureDetector(
                    onTap: () {
                      AlertTool.showPopMenu(
                        viewService.context,
                        originKey: _rightKey,
                        itemHeight: 58.w,
                        itemWidth: 130.w,
                        type: PopWindowType.topRight,
                        itemSelectedColor: AppColors.weiboColor,
                        dividerColor: Color.fromRGBO(21, 21, 21, 0.33),
                        backgroundColor: Color.fromRGBO(47, 48, 51, 1),
                        itemsData: [
                          PopModel(
                              name: '图文',
                              image: "assets/weibo/publish_image_text.png",
                              fontSize: 20.w,
                              id: 1),
                          PopModel(
                              name: '视频',
                              image: "assets/weibo/publish_video.png",
                              fontSize: 20.w,
                              id: 2),
                        ],
                        clickCallback: (index, model) async {
                          Map<String, dynamic> map;
                          if (index == 0) {
                            map = {'type': UploadType.UPLOAD_IMG};
                          } else {
                            map = {'type': UploadType.UPLOAD_VIDEO};
                          }

                          bus.emit(EventBusUtils.pausePlayer);

                          bus.emit(EventBusUtils.closeActivityFloating);

                          Gets.Get.to(
                                  VideoAndPicturePublishPage().buildPage(map),
                                  opaque: false)
                              .then((value) {
                            bus.emit(EventBusUtils.showActivityFloating);
                          });
                        },
                      );
                    },
                    child: Image.asset(
                      "assets/weibo/video_plus.png",
                      width: 20.w,
                      height: 20.w,
                    )),
              ),
            ],
          ),
        ],
        title: commonTabBar(Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: TabBar(
            isScrollable: true,
            controller: state.tabController,
            tabs: Lang.COMMUNITY_TABS
                .map(
                  (e) => RedAppbarMenu(
                    title: e,
                    tabController: state.tabController,
                  ),
                )
                .toList(),
            indicator: RoundUnderlineTabIndicator(
              borderSide: BorderSide(
                color: AppColors.weiboColor,
                // color: Colors.transparent,
                width: 3,
              ),
            ),
            indicatorWeight: 4,
            unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 22),
            unselectedLabelStyle: TextStyle(fontSize: 24),
            labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
          ),
        )),
      ),
      body: Stack(
        children: [
          ExtendedTabBarView(
            controller: state.tabController,
            children: [
              CommunityFollowPage().buildPage(null),
              CommunityTabPage().buildPage({"community": state.community}),
              // CommunityHotListPage()
            ],
          ),
          FloatingMoveView(),
        ],
      ),
      floatingActionButton: (state.showCutDownTimeButton ?? false)
          ? SizedBox(
              width: Dimens.pt94,
              height: Dimens.pt82,
              child: FloatingActionButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    //社区首页 新人限时礼包
                    Config.payFromType = PayFormType.user;

                    bus.emit(EventBusUtils.closeActivityFloating);

                    Gets.Get.to(
                            () =>
                                MemberCentrePage().buildPage({"position": "0"}),
                            opaque: false)
                        .then((value) {
                      bus.emit(EventBusUtils.showActivityFloating);
                    });
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Image(
                        image: AssetImage(AssetsImages.IC_NEW_PERSON_BAG),
                        width: Dimens.pt94,
                        height: Dimens.pt82,
                      ),
                      Positioned(
                        bottom: Dimens.pt6,
                        child: Row(
                          children: [
                            SizedBox(width: Dimens.pt6),
                            Consumer<CountdwonUpdate>(
                              builder: (context, value, Widget child) {
                                Countdown countdown = value.countdown;
                                if (countdown.countdownSec == 0) {
                                  dispatch(CommunityActionCreator
                                      .showNewPersonCutDownTime(false));
                                  return Container();
                                }
                                return VIPCountDownWidget(
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfff61940),
                                  seconds: countdown.countdownSec ?? 0,
                                  countdownEnd: () {},
                                  countdownChange: (_seconds) {
                                    countdown.countdownSec = _seconds;
                                    Provider.of<CountdwonUpdate>(context,
                                            listen: false)
                                        .setCountdown(countdown);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
  );
}
