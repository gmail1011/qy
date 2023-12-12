import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/account_qrcode/page.dart';
import 'package:flutter_app/page/ai/floating_ai_move_view.dart';
import 'package:flutter_app/page/home/mine/action.dart';
import 'package:flutter_app/page/home/msg/fans/page.dart';
import 'package:flutter_app/page/publish/makeVideo/make_video_page.dart';
import 'package:flutter_app/page/setting/my_favorite/page.dart';
import 'package:flutter_app/page/user/boutique_app/page.dart';
import 'package:flutter_app/page/user/edit_user_info/page.dart';
import 'package:flutter_app/page/user/history_records/page.dart';
import 'package:flutter_app/page/user/my_certification/page.dart';
import 'package:flutter_app/page/user/my_purchases/page.dart';
import 'package:flutter_app/page/user/official_community/page.dart';
import 'package:flutter_app/page/user/offline_cache/page.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/message/message_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import '../../../common/manager/event_manager.dart';
import '../../../utils/global_variable.dart';
import 'mine_follow_page/page.dart';
import 'state.dart';

Widget buildView(MineState state, Dispatch dispatch, ViewService viewService) {
  ///头部背景和头像
  var userInfoUI = InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: () {
      if (GlobalStore?.getMe()?.uid == null) {
        return;
      }

      Map<String, dynamic> arguments = {
        'uid': GlobalStore?.getMe()?.uid,
        'uniqueId': DateTime.now().toIso8601String(),
      };
      Gets.Get.to(() => BloggerPage(arguments), opaque: false);
    },
    child: Container(
      padding: EdgeInsets.only(top: Dimens.pt50 - screen.paddingTop),
      child: Row(
        children: [
          HeaderWidget(
            headPath: state.meInfo?.portrait ?? "",
            level: (state.meInfo?.superUser ?? false) ? 1 : 0,
            headWidth: Dimens.pt40,
            headHeight: Dimens.pt40,
            levelSize: 14,
            positionedSize: 0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: Dimens.pt10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ///user name
                      Container(
                        margin: EdgeInsets.only(top: Dimens.pt11),
                        child: Text(
                          state.meInfo == null
                              ? Lang.UN_KNOWN
                              : ((state.meInfo?.name?.length ?? 0) > 9
                                  ? state.meInfo?.name?.substring(0, 9)
                                  : state.meInfo?.name),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt16,
                            color: GlobalStore.isVIP()
                                ? Color.fromRGBO(246, 197, 89, 1)
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      ///personnal setting

                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Gets.Get.to(() => EditUserInfoPage().buildPage({}),
                              opaque: false);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: Dimens.pt2,
                              right: Dimens.pt10,
                              top: Dimens.pt14,
                              left: Dimens.pt10),
                          child: svgAssets(AssetsSvg.USER_IC_USER_SETTING,
                              width: Dimens.pt15, height: Dimens.pt14),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: Dimens.pt10)),
                ],
              ),
            ),
          ),

          ///进入主页
          svgAssets(AssetsSvg.USER_IC_USER_HOME_PAGE,
              width: Dimens.pt86, height: Dimens.pt35),
        ],
      ),
    ),
  );

  ///center UI
  var centerWidget = Container(
    margin: EdgeInsets.only(bottom: 12),
    alignment: Alignment.topLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ///用户基本信息
        _buildUserInfoUI(state),

        ///VIP UI
        GlobalStore.isVIP() ? _buildVipUI(state) : _buildNotVipUI(),

        ///功能UI
        Container(
          margin: EdgeInsets.only(top: Dimens.pt16),
          color: AppColors.userItemColor,
          padding: const EdgeInsets.only(top: 18, left: 14, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ///创作中心
              _buttonWidget(AssetsSvg.ICON_USER_FUC01, "创作中心", () {
                Gets.Get.to(() => MakeVideoPage().buildPage({}), opaque: false);
              }),

              ///我的认证
              _buttonWidget(AssetsSvg.ICON_USER_FUC02, "我的认证", () {
                Gets.Get.to(() => MyCertificationPage().buildPage({}),
                    opaque: false);
              }),

              ///我要赚钱
              _buttonWidget(AssetsSvg.ICON_USER_FUC08, "我要赚钱", () {
              }),

              ///我的购买
              _buttonWidget(AssetsSvg.ICON_USER_FUC04, "我的购买", () {
                Gets.Get.to(() => MyPurchasesPage().buildPage({}),
                    opaque: false);
              }),
            ],
          ),
        ),

        ///功能UI
        Container(
          color: AppColors.userItemColor,
          padding:
              const EdgeInsets.only(top: 18, left: 14, right: 14, bottom: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ///兑换会员
              _buttonWidget(AssetsSvg.ICON_USER_FUC09, "兑换会员", () {
                Config.payFromType = PayFormType.user;
                Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
              }),

              ///在线客服
              _buttonWidget(AssetsSvg.ICON_USER_FUC05, "在线客服", () {
                csManager.openServices(viewService.context);
              }),

              ///消息
              _myMessage(AssetsSvg.ICON_USER_MYMESSAGE, "我的消息", () {
                Gets.Get.to(() => MessagePage().buildPage({}), opaque: false);
              }),
            ],
          ),
        ),
      ],
    ),
  );

  return FullBg(
    child: Scaffold(
      body: BaseRequestView(
        controller: state.requestController,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, screen.paddingTop, 16, 0),
              child: pullYsRefresh(
                refreshController: state.refreshController,
                enablePullUp: false,
                enablePullDown: true,
                onRefresh: () async {
                  Future.delayed(Duration(milliseconds: 1000), () {
                    dispatch(MineActionCreator.onRefresh());
                  });
                },
                child: CustomScrollView(
                  controller: state.scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //头部
                          userInfoUI,
                          SizedBox(height: Dimens.pt16),
                          centerWidget,

                          /*_createMineItem(
                          "优惠券", AssetsImages.ICON_USER_ITEM_MYLOVE, () {
                        Gets.Get.to(() => TicketPage(),
                            opaque: false);
                      }),*/

                          _createMineItem(
                              "我的喜欢", AssetsImages.ICON_USER_ITEM_MYLOVE, () {
                            Gets.Get.to(() => MyFavoritePage().buildPage({}),
                                opaque: false);
                          }),
                          _createMineItem(
                              "历史记录", AssetsImages.ICON_USER_ITEM_HISTORY, () {
                            Gets.Get.to(
                                () => HistoryRecordsPage().buildPage({}),
                                opaque: false);
                          }),
                          // _createMineItem(
                          //     "我要求片", AssetsImages.ICON_USER_ITEM_GET_VIDEO, () {
                          //   JRouter().jumpPage(WISH_LIST_PAGE);
                          // }),
                          _createMineItem(
                              "离线缓存", AssetsImages.ICON_USER_ITEM_OFFLINE_CACHE,
                              () {
                            Gets.Get.to(() => OfflineCachePage().buildPage({}),
                                opaque: false);
                          }),
                          _createMineItem(
                              "账号凭证", AssetsImages.ICON_USER_ITEM_CERTIFICATE,
                              () {
                            Gets.Get.to(() => AccountQrCodePage().buildPage({}),
                                opaque: false);
                          }),
                          _createMineItem(
                              "官方社群", AssetsImages.ICON_USER_ITEM_GROUP, () {
                            Gets.Get.to(
                                () => OfficialCommunityPage().buildPage({}),
                                opaque: false);
                          }),
                          _createMineItem(
                              "精品应用", AssetsImages.ICON_USER_ITEM_APP, () {
                            Gets.Get.to(() => BoutiqueAppPage().buildPage({}),
                                opaque: false);
                          }),
                          _createMineItem(
                              "设置中心", AssetsImages.ICON_USER_ITEM_CENTER, () {
                            // Gets.Get.to(SettingPage().buildPage({}), opaque: false);
                            Gets.Get.to(() => EditUserInfoPage().buildPage({}),
                                opaque: false);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FloatingAiMoveView(),
          ],
        ),
      ),
    ),
  );
}

///用户基本信息
Widget _buildUserInfoUI(MineState state) {
  return Container(
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getShowCountStr(state.meInfo?.like ?? 0),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: Dimens.pt5),
              Container(
                child: Text(
                  "获赞",
                  //textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: AppColors.userDesTextColor,
                    fontSize: Dimens.pt15,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () =>
              Gets.Get.to(() => MineFollowPage().buildPage({}), opaque: false),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getShowCountStr(state.meInfo?.follow ?? 0),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.pt15,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: Dimens.pt5),
                Text(
                  "关注",
                  style: TextStyle(
                    color: AppColors.userDesTextColor,
                    fontSize: Dimens.pt15,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              Gets.Get.to(() => FansPage().buildPage({}), opaque: false),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getShowCountStr(state.meInfo?.fans ?? 0),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.pt15,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: Dimens.pt5),
                Text(
                  "粉丝",
                  style: TextStyle(
                    color: AppColors.userDesTextColor,
                    fontSize: Dimens.pt15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

///未开通会员 UI
GestureDetector _buildNotVipUI() {
  return GestureDetector(
    onTap: () {
      Config.payFromType = PayFormType.user;
      Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
    },
    child: Container(
      margin: EdgeInsets.only(top: Dimens.pt16),
      height: Dimens.pt64,
      padding: EdgeInsets.only(left: Dimens.pt2, right: Dimens.pt12),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsImages.BG_USER_VIP_KING),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.circular(Dimens.pt4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Dimens.pt45, width: Dimens.pt57),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("开通会员",
                  style: TextStyle(
                      fontSize: Dimens.pt18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userVipTextColor)),
              SizedBox(height: Dimens.pt3),
              Text("享受尊贵权益 十万部影片无限观看",
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: AppColors.userVipTextColor)),
            ],
          )),
          Text("会员中心",
              style: TextStyle(
                  fontSize: Dimens.pt12, color: AppColors.userVipTextColor)),
          SizedBox(width: Dimens.pt4),
          svgAssets(AssetsSvg.ICON_USER_VIP_ARROW,
              height: Dimens.pt11, width: Dimens.pt7),
        ],
      ),
    ),
  );
}

///开通会员 UI
GestureDetector _buildVipUI(MineState state) {
  return GestureDetector(
    onTap: () {
      Config.payFromType = PayFormType.user;
      Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
    },
    child: Container(
      margin: EdgeInsets.only(top: Dimens.pt16),
      height: Dimens.pt64,
      padding: EdgeInsets.only(left: Dimens.pt2, right: Dimens.pt18),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsImages.BG_USER_VIP_KING),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.circular(Dimens.pt4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Dimens.pt45, width: Dimens.pt57),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("VIP会员", //state.meInfo.vipLevel == 2 ? "超级会员" : "普通会员",
                  style: TextStyle(
                      fontSize: Dimens.pt18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.userVipTextColor)),
              SizedBox(height: Dimens.pt3),
              Text(
                  "有效期：${getVipStringFromTime(state.meInfo?.vipExpireDate, netManager.getFixedCurTime(), isChina: true)}",
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: AppColors.userVipTextColor)),
            ],
          )),
          Text("会员中心",
              style: TextStyle(
                  fontSize: Dimens.pt12, color: AppColors.userVipTextColor)),
          SizedBox(width: Dimens.pt4),
          svgAssets(AssetsSvg.ICON_USER_VIP_ARROW,
              height: Dimens.pt11, width: Dimens.pt7),
        ],
      ),
    ),
  );
}

///设置我的item
Widget _createMineItem(String title, String imagePath, VoidCallback callback) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: Dimens.pt42,
      decoration: BoxDecoration(
        color: AppColors.userItemColor,
        borderRadius: BorderRadius.circular(Dimens.pt4),
      ),
      child: Row(
        children: [
          SizedBox(width: Dimens.pt14),
          Image(
              image: AssetImage(imagePath),
              width: Dimens.pt20,
              height: Dimens.pt20),
          SizedBox(width: Dimens.pt8),
          Expanded(
            child: Text(title,
                style: TextStyle(color: Colors.white, fontSize: Dimens.pt14)),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            size: Dimens.pt16,
            color: Colors.white,
          ),
          SizedBox(width: Dimens.pt14),
        ],
      ),
    ),
  );
}

///Grid 按钮UI
Widget _buttonWidget(String imagePath, String title, VoidCallback callback) {
  return GestureDetector(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        svgAssets(imagePath, height: Dimens.pt26, width: Dimens.pt26),
        SizedBox(height: Dimens.pt2),
        Text(title,
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt12))
      ],
    ),
    onTap: callback,
  );
}

//我的消息
Widget _myMessage(String imagePath, String title, VoidCallback callback) {
  return StatefulBuilder(
      builder: (context, setInnerState) => GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: [
                    svgAssets(imagePath,
                        height: Dimens.pt26, width: Dimens.pt26),
                    if (Config.newMessageTip.newsTip??false)
                      Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: Color(0xfff74f49),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.w))),
                          ))
                    // Positioned(
                    //   top: Dimens.pt6,
                    //   right: 0,
                    //   child: Consumer<MsgCountModel>(builder:
                    //       (BuildContext context, MsgCountModel msgCountModel,
                    //       Widget child) {
                    //     return msgCountModel.countNum == 0
                    //         ? Container()
                    //         : ClipOval(
                    //         child: Container(
                    //           color: Color(0xfff65c63),
                    //           width: Dimens.pt6,
                    //           height: Dimens.pt6,
                    //         ));
                    //   }),
                    // )
                  ],
                ),
                SizedBox(height: Dimens.pt2),
                Text(title,
                    style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt12))
              ],
            ),
            onTap: () {
              Config.messageNewsStatus = false;
              setInnerState(() {});
              GlobalVariable.eventBus.fire(HomeMineUnReadChange());
              callback();
            },
          ));
}

///刷新VIP时间
String getVipStringFromTime(String time, DateTime nowTime, {bool isChina}) {
  nowTime = nowTime ?? DateTime.now();
  String result = DateTimeUtil.calTime(DateTimeUtil.utc2iso(time), nowTime);
  String vipTime;
  List<String> timeList = result.split("_");
  if (time.length > 2) {
    if (int.parse(timeList[0]) > 3 ||
        (int.parse(timeList[0]) == 3 && int.parse(timeList[1]) > 0) ||
        (int.parse(timeList[0]) == 3 && int.parse(timeList[1]) == 0) &&
            int.parse(timeList[2]) > 0) {
      //大于3天
      var experidTime =
          TextUtil.isNotEmpty(time) ? DateTime.parse(time) : DateTime.now();
      if (experidTime.year - nowTime.year > 10) {
        vipTime = Lang.VIP_FOREVER;
      } else {
        vipTime = DateTimeUtil.utcTurnYear(time, isChina: isChina);
      }
    } else if (int.parse(timeList[0]) >= 1) {
      //大于等于1天，小于等于3天
      vipTime = timeList[0] + Lang.DAY;
    } else if (int.parse(timeList[1]) >= 1) {
      //一小时以上
      vipTime = timeList[1] + Lang.HOURS;
    } else {
      vipTime = Lang.VIP_ONE_TIME;
    }
  }
  return vipTime;
}

String getExpireGoldTime(String time, DateTime nowTime) {
  nowTime = nowTime ?? DateTime.now();
  String result = DateTimeUtil.calTime(DateTimeUtil.utc2iso(time), nowTime);
  String vipTime;
  List<String> timeList = result.split("_");
  if (time.length > 2) {
    if (int.parse(timeList[0]) > 3 ||
        (int.parse(timeList[0]) == 3 && int.parse(timeList[1]) > 0) ||
        (int.parse(timeList[0]) == 3 && int.parse(timeList[1]) == 0) &&
            int.parse(timeList[2]) > 0) {
      //大于3天
      var experidTime =
          TextUtil.isNotEmpty(time) ? DateTime.parse(time) : DateTime.now();
      if (experidTime.year - nowTime.year > 10) {
        vipTime = Lang.VIP_FOREVER;
      } else {
        vipTime = DateTimeUtil.utcTurnYear(time);
      }
    } else if (int.parse(timeList[0]) >= 1) {
      //大于等于1天，小于等于3天
      vipTime = timeList[0] + Lang.DAY;
    } else if (int.parse(timeList[1]) >= 1) {
      //一小时以上
      vipTime = timeList[1] + Lang.HOURS;
    } else {
      vipTime = Lang.VIP_ONE_TIME;
    }
  }
  return vipTime;
}
