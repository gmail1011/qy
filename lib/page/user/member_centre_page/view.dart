import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/user/member_centre_page/member_tabbar_view.dart';
import 'package:flutter_app/page/user/member_centre_page/vip/page.dart';
import 'package:flutter_app/page/user/member_centre_page/wallet/page.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/text_util.dart';

import 'action.dart';
import 'state.dart';

/// 会员购买
Widget buildView(
    MemberCentreState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: getCommonAppBar(Lang.MEMBER_CENTRE),
        body: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       Color.fromRGBO(43, 43, 43, 0),
              //       Color.fromRGBO(147, 129, 70, 1),
              //     ],
              //   ),
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: Dimens.pt50,
                    margin: EdgeInsets.only(left: Dimens.pt16, bottom: Dimens.pt10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///用户名称-VIP时间
                        HeaderWidget(
                          headPath: state.meInfo?.portrait ?? "",
                          level: (state.meInfo?.superUser ?? false) ? 1 : 0,
                          headWidth: Dimens.pt49,
                          headHeight: Dimens.pt49,
                          tabCallback: () {
                            if (TextUtil.isNotEmpty(
                                state.meInfo?.portrait ?? false)) {
                              showPictureSwipe(
                                  viewService.context, [state.meInfo.portrait], 0);
                            }
                          },
                        ),
                        SizedBox(width: Dimens.pt22),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.meInfo == null
                                        ? Lang.UN_KNOWN
                                        : state.meInfo.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: Dimens.pt16,
                                      color: ((state.meInfo?.isVip ?? false) &&
                                          (state.meInfo?.vipLevel ?? 0) > 0)
                                          ? Colors.white //Color.fromRGBO(246, 197, 89, 1)
                                          : Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String code = await showRedemptionCodeDialog(
                                          viewService.context);
                                      l.d("showRedemptionCodeDialog-result",
                                          "$code");
                                      if (null != code) {
                                        dispatch(MemberCentreActionCreator
                                            .submitRedemptionCode(code));
                                      }
                                    },
                                    child: Container(
                                      width: Dimens.pt80,
                                      height: Dimens.pt26,
                                      margin: EdgeInsets.only(right: 20),
                                      padding: EdgeInsets.only(bottom: 2),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(37),
                                          ),
                                          border: Border.all(
                                            color: Color(0xFFF4d88a),
                                            width: 0.6,
                                          )),
                                      child: Text(
                                        "使用兑换码",
                                        style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color: Color(0xFFF4d88a),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimens.pt3),
                              Text(
                                GlobalStore.isVIP()
                                    ? getVipStringFromTime(
                                    state.meInfo?.vipExpireDate,
                                    netManager.getFixedCurTime())
                                    : "您当前未开通会员",
                                style: TextStyle(
                                    fontSize: Dimens.pt13,
                                    color: GlobalStore.isVIP()
                                        ? Color.fromRGBO(255, 118, 0, 1)// Color.fromRGBO(246, 197, 89, 1)
                                        : Colors.white.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MemberTabbarView(tabBarController: state.tabBarController),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: state.tabBarController,
                children: [
                  VIPPage().buildPage(state.specifyVipCardId != ""
                      ? {"specifyVipCardId": state.specifyVipCardId}
                      : null),
                  WalletPage().buildPage(null),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


///刷新VIP时间
String getVipStringFromTime(String time, DateTime nowTime) {
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
        vipTime = Lang.VIP_END_TIME + Lang.VIP_FOREVER;
      } else {
        vipTime = DateTimeUtil.utcTurnYear(time);
      }
    } else if (int.parse(timeList[0]) >= 1) {
      //大于等于1天，小于等于3天
      vipTime = Lang.VIP_REMAINING_TIME + timeList[0] + Lang.DAY;
    } else if (int.parse(timeList[1]) >= 1) {
      //一小时以上
      vipTime = Lang.VIP_REMAINING_TIME + timeList[1] + Lang.HOURS;
    } else {
      vipTime = Lang.VIP_ONE_TIME;
    }
  }
  return vipTime;
}
