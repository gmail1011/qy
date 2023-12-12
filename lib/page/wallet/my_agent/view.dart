import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/wallet/my_agent/view/agent_view.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/message/InCome.dart';
import 'package:flutter_app/widget/YYMarquee.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:marquee/marquee.dart';

import 'state.dart';

Widget buildView(
    MyAgentState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar("我要赚钱"),
      body: BaseRequestView(
        controller: state.requestController,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: Dimens.pt100),
          child: Container(
            padding: EdgeInsets.only(
                left: Dimens.pt16, right: Dimens.pt16, top: Dimens.pt16),
            child: Column(
              children: <Widget>[
                createIncomeBalanceWidget(state, dispatch, viewService),
                Container(
                  height: Dimens.pt38,
                  width: screen.screenWidth,
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  padding: EdgeInsets.only(top: 9, bottom: 9, left: 26),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color.fromRGBO(30, 30, 30, 1),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/weibo/lingdang.png",
                        width: Dimens.pt20,
                        height: Dimens.pt20,
                      ),
                      Expanded(
                        child: Container(
                          height: Dimens.pt40,
                          padding: EdgeInsets.only(
                            left: 12,
                            right: 16,
                          ),


                          /*child: state.marquee == null
                              ? Container()
                              : Marquee(
                                  text: state.marquee,
                                  style: TextStyle(
                                    fontSize: Dimens.pt14,
                                    color: Colors.white,
                                  ),
                                  scrollAxis: Axis.vertical,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20,
                                  velocity: 100,
                                  pauseAfterRound: Duration(seconds: 1),
                                  showFadingOnlyWhenScrolling: true,
                                  fadingEdgeStartFraction: 0.1,
                                  fadingEdgeEndFraction: 0.1,
                                  numberOfRounds: 3,
                                  startPadding: 10,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),*/

                          /*Marquee(
                                  text: state.marquee,
                                  style: TextStyle(
                                    fontSize: Dimens.pt14,
                                    color: Colors.white,
                                  ),
                                  scrollAxis: Axis.vertical,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 100.0,
                                  pauseAfterRound: Duration(seconds: 5),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 5),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(seconds: 5),
                                  decelerationCurve: Curves.easeOut,
                                ),*/
                          child: YYMarquee(
                              Text(
                                  state.marquee == null
                                      ? " "
                                      : state.marquee.toString(),
                                  style: TextStyle(
                                    fontSize: Dimens.pt14,
                                    color: Colors.white,
                                  )),
                              200,
                              new Duration(seconds: 5),
                              230.0,
                              keyName: "community_recommend"),
                        ),
                      ),
                    ],
                  ),
                ),
                _createAgentMenu(state),
                _buttonWidget(state, dispatch, viewService),
                _descriptionView(state, dispatch, viewService),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

///推广收益UI
_createAgentMenu(MyAgentState state) {
  return Container(
    margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _createAgentMenuItem(
            "推广收益", "${state.userIncomeModel?.proxyIncome ?? 0}"),
        _createAgentMenuItem(
            "投稿收益", "${state.userIncomeModel?.vidIncome ?? 0}"),
      ],
    ),
  );
}

///推广收益Item
_createAgentMenuItem(String str1, String str2) {
  return Row(
    children: [
      Text(str1,
          style: TextStyle(
              color: AppColors.userDesTextColor, fontSize: Dimens.pt16)),
      SizedBox(width: 20),
      Text(str2, style: TextStyle(color: Colors.white, fontSize: Dimens.pt16)),
    ],
  );
}

// balance
Widget createIncomeBalanceWidget(
    MyAgentState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: screen.screenWidth,
          padding: EdgeInsets.only(top: Dimens.pt16, bottom: Dimens.pt22),
          decoration: BoxDecoration(
            color: AppColors.userMakeBgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: screen.screenWidth - Dimens.pt16 * 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        svgAssets(AssetsSvg.ICON_WITHDRAW_RECTANGLE,
                            width: Dimens.pt6, height: Dimens.pt19),
                        const SizedBox(width: 6),
                        Text(
                          "收益余额",
                          style: TextStyle(
                              fontSize: Dimens.pt14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: Dimens.pt22, top: Dimens.pt27),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              svgAssets(AssetsSvg.NEW_GOLD_COIN,
                                  width: Dimens.pt20, height: Dimens.pt20),
                              const SizedBox(width: 8),
                              Text(
                                "${state.wallet?.income ?? 0}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.pt32,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "可提现余额${((state.wallet?.income ?? 0) / 10).toStringAsFixed(2)}元",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: Dimens.pt12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        eagleClick(state.selfId(),
                            sourceId: state.eagleId(viewService.context),
                            label:
                                "withdraw${state.userIncomeModel?.income ?? "0"}");
                        JRouter().go(PAGE_WITHDRAW);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: Dimens.pt84,
                        height: Dimens.pt28,
                        margin: const EdgeInsets.only(right: 11),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                                colors: AppColors.taskCenterLineColors)),
                        child: Text(
                          "立即提现",
                          style: TextStyle(
                              color: Colors.white, fontSize: Dimens.pt12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

///代理收益
Widget _buttonWidget(
    MyAgentState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.only(top: 22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _button(() {
          Gets.Get.to(() => InComePage(), opaque: false);
        }, AssetsImages.IC_AGENT_JL2, "账单明细"),
        _button(() {
          JRouter().jumpPage(PAGE_PROMOTION_RECORD);
        }, AssetsImages.IC_AGENT_JT2, "推广记录"),
        _button(() {
          JRouter().jumpPage(PAGE_PERSONAL_CARD);
          AnalyticsEvent.clickToSharePromotionEvent();
        }, AssetsImages.IC_AGENT_MX2, "分享推广"),
      ],
    ),
  );
}

///推广返利
Widget _descriptionView(
    MyAgentState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _createSubTitle("推广返利"),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "累计充值",
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Colors.white,
            ),
          ),
          Text(
            "返利百分比",
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Colors.white,
            ),
          ),
        ],
      ),
      _agentView("2千以下", "返利 50%"),
      _agentView("2千~1万", "返利 60%"),
      _agentView("1万~3万", "返利 65%"),
      _agentView("3万以上", "返利 70%"),
      _createSubTitle("推广流程"),
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: Dimens.pt30,
                  height: Dimens.pt30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD303),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "1",
                    style: TextStyle(fontSize: Dimens.pt22),
                  ),
                ),
                Container(
                  width: Dimens.pt2,
                  height: Dimens.pt90,
                  alignment: Alignment.center,
                  color: Color(0xFFFFD303),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: AppPaddings.appMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(height: 1.5),
                        children: [
                          TextSpan(
                              style: TextStyle(fontSize: Dimens.pt18),
                              text: "第一步：点击「"),
                          TextSpan(
                            style: TextStyle(
                                fontSize: Dimens.pt18, color: Colors.red),
                            text: "分享推广",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                JRouter().jumpPage(PAGE_PERSONAL_CARD);
                              },
                          ),
                          TextSpan(
                              style: TextStyle(fontSize: Dimens.pt18),
                              text: "」"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "将「二维码」分享给其他人或其他渠道，对方扫码下载APP并登录生成了新账号，则视作推广成功。",
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: Dimens.pt12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: Dimens.pt30,
                  height: Dimens.pt30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD303),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "2",
                    style: TextStyle(fontSize: Dimens.pt22),
                  ),
                ),
                Container(
                  width: Dimens.pt2,
                  height: Dimens.pt90,
                  alignment: Alignment.center,
                  color: Color(0xFFFFD303),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: AppPaddings.appMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "第二步：对方「充值」",
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: Dimens.pt18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(height: 1.5),
                        children: [
                          TextSpan(
                              style: TextStyle(fontSize: Dimens.pt12),
                              text: "推广的用户充值，则充值金额按照「推广级别」的比列返利给您，若有什么疑问请联系「"),
                          TextSpan(
                            style: TextStyle(
                                fontSize: Dimens.pt12, color: Colors.red),
                            text: "在线客服",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                csManager.openServices(viewService.context);
                              },
                          ),
                          TextSpan(
                              style: TextStyle(fontSize: Dimens.pt12),
                              text: "」"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: Dimens.pt30,
                  height: Dimens.pt30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD303),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "3",
                    style: TextStyle(fontSize: Dimens.pt22),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: AppPaddings.appMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(height: 1.5),
                        children: [
                          TextSpan(
                              style: TextStyle(fontSize: Dimens.pt18),
                              text: "第三步："),
                          TextSpan(
                            style: TextStyle(
                                fontSize: Dimens.pt18, color: Colors.red),
                            text: "收益提现",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                JRouter().go(PAGE_WITHDRAW);
                              },
                          ),
                          TextSpan(
                              style: TextStyle(fontSize: Dimens.pt18),
                              text: "或"),
                          TextSpan(
                            style: TextStyle(
                                fontSize: Dimens.pt18, color: Colors.red),
                            text: "兑换会员",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Config.payFromType = PayFormType.user;
                                Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "收益可提现或兑换会员，月入万元不是梦！",
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: Dimens.pt12),
                    ),
                    Row(
                      children: [
                        Text(
                          "立即提现",
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontSize: Dimens.pt12),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: ImageLoader.withP(
                            ImageType.IMAGE_ASSETS,
                            address: AssetsImages.IC_MY_AGENT_ARROW,
                            width: Dimens.pt16,
                          ).load(),
                        ),
                        Text(
                          "银行卡/支付宝",
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontSize: Dimens.pt12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "兑换会员",
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontSize: Dimens.pt12),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: ImageLoader.withP(
                            ImageType.IMAGE_ASSETS,
                            address: AssetsImages.IC_MY_AGENT_ARROW,
                            width: Dimens.pt16,
                          ).load(),
                        ),
                        Text(
                          "无限观影",
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontSize: Dimens.pt12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "举例：推广的用户充值100元，返利60～75元，业绩越高比例越高。",
                      style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontSize: Dimens.pt10),
                    ),
                    // SizedBox(
                    //   height: 6,
                    // ),
                    // Text(
                    //   "获得返利公式：（100-100*15%）*60%=45元\n15%为支付通道手续费",
                    //   style: TextStyle(
                    //       height: 1.5,
                    //       color: Colors.white,
                    //       fontSize: Dimens.pt10),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      agentHLine(),
      Text(
        "一看即会，任何人都可参与，边吃瓜边赚钱",
        style: TextStyle(fontSize: Dimens.pt16, color: Colors.white),
      ),
      RichText(
        text: TextSpan(
          style: TextStyle(height: 1.5),
          children: [
            TextSpan(
              style: TextStyle(fontSize: Dimens.pt16),
              text: "终身享受利润分红，任何疑问请联系",
            ),
            TextSpan(
              style: TextStyle(fontSize: Dimens.pt16, color: Colors.red),
              text: "在线客服",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  csManager.openServices(viewService.context);
                },
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _button(VoidCallback callback, String imagePath, String title) {
  return GestureDetector(
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ImageLoader.withP(ImageType.IMAGE_ASSETS,
                address: imagePath, height: Dimens.pt45, width: Dimens.pt45)
            .load(),
        Container(height: Dimens.pt6),
        Text(title,
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt14))
      ],
    ),
    onTap: callback,
  );
}

Widget _agentView(String title, String subTitle) {
  return Container(
    margin: EdgeInsets.only(top: 12, bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Dimens.pt12,
            color: Colors.white,
          ),
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: Dimens.pt12,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

///subTitle
_createSubTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(top: 20, bottom: 20),
    child: Text(title,
        style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.pt17,
            fontWeight: FontWeight.bold)),
  );
}
