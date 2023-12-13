import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/page/wallet/pay_for/action.dart';
import 'package:flutter_app/page/wallet/pay_for/model/pay_type.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/pay_notice_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:getwidget/getwidget.dart';

import 'state.dart';

///钱包充值列表
Widget buildView(PayForState state, Dispatch dispatch, ViewService viewService) {
  return !state.selectTickets
      ? Stack(
          alignment: Alignment.center,
          children: <Widget>[
            state.isPayLoading ? LoadingWidget() : Container(),
            Container(
              decoration: BoxDecoration(
               color: Color(0xff2e2e2e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.pt17),
                  topRight: Radius.circular(Dimens.pt17),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: Dimens.pt50,
                    alignment: Alignment.center,
                    child: Center(
                        child: Text(
                      "选择支付方式",
                      style: TextStyle(
                        fontSize: Dimens.pt17,
                        color: Colors.white,
                      ),
                    )),
                  ),
                  Center(
                    child: Divider(
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                      height: 1,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CustomScrollView(
                      controller: state.scrollController,
                      slivers: [

                        SliverToBoxAdapter(
                          child: Container(height: 10,),
                        ),

                        SliverList(
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            PayType payType = state.payList[index];
                            String giftStr = '';

                            return _buildPayTypeItemUI(state, dispatch, payType, giftStr, index);
                          }, childCount: state.payList?.length ?? 0),
                        ),
                        SliverToBoxAdapter(child: _buildBuyVIPGoldCoinUI(state, dispatch)),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: Dimens.pt26, right: Dimens.pt26, top: Dimens.pt8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "温馨提示：",
                                style:
                                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600 , fontSize: Dimens.pt13),
                              ),
                              SizedBox(height: Dimens.pt5),
                              Text(
                                "1、跳转后请及时付款，超时支付无法到账，要重新发起。\n2、每天发起支付不能超过5次，连续发起且未支付，账号可能被加入黑名单。",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                  fontSize: Dimens.pt12,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.pt8),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.pt12),

                  commonSubmitButton("￥${(state.vipItem == null ? 0 : state.vipItem.discountedPrice ?? 0) ~/ 10}/立即支付", onTap: () {
                    ///1.金币购买会员
                    if (state.payRadioType == -1) {
                      l.e("购买会员", "金币购买会员");

                      ///不需要返回参数
                      if (!(state.needBackArgs ?? false)) {
                        safePopPage(viewService.context);
                      }
                      dispatch(PayForActionCreator.glodBuyVip());
                      return;
                    }

                    ///2.浏览器支付风险提示
                    _buildPayNoticeDialog(state, dispatch, viewService);
                  }),

                  SizedBox(height: Dimens.pt12),



                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [


                      Text(
                        "支付中如有问题，请咨询  ",
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                      ),


                      GestureDetector(
                        onTap: (){
                          csManager.openServices(FlutterBase.appContext);
                        },
                        child: Text(
                          "在线客服",
                          style: TextStyle(color: AppColors.primaryTextColor, fontSize: Dimens.pt12),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimens.pt10),

                ],
              ),
            ),
          ],
        )
      : Stack(
          alignment: Alignment.center,
          children: <Widget>[
            state.isPayLoading ? LoadingWidget() : Container(),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff2e2e2e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.pt17),
                  topRight: Radius.circular(Dimens.pt17),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: Dimens.pt50,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 18),
                          child: GestureDetector(
                            onTap: () {
                              dispatch(PayForActionCreator.selectTickets(false));
                            },
                            child: Image.asset(
                              "assets/weibo/back_arrow.png",
                              width: Dimens.pt22,
                              height: Dimens.pt22,
                              color: Color.fromRGBO(21, 21, 21, 0.9),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Text(
                              "请选择加赠券",
                              style: TextStyle(
                                fontSize: Dimens.pt17,
                                color: Color(0xff151515),
                              ),
                            )),
                        Spacer(),
                      ],
                    ),
                  ),
                  Center(
                    child: Divider(
                      color: Color(0xffe5ded3),
                      height: 1,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: Dimens.pt21,
                        right: Dimens.pt21,
                      ),
                      child: ListView.builder(
                        itemCount: VariableConfig.goldTickets.list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: Dimens.pt88,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              top: Dimens.pt14,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/weibo/coupon_bg.png"),
                              ),
                            ),
                            width: screen.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: Dimens.pt4,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "加赠券",
                                      style: TextStyle(color: Colors.white, fontSize: Dimens.pt16),
                                    ),
                                    Text(
                                      "¥" + VariableConfig.goldTickets.list[index].price.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimens.pt22),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: Dimens.pt22,
                                ),
                                Container(
                                  // margin: EdgeInsets.only(left: Dimens.pt18),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        VariableConfig.goldTickets.list[index].name,
                                        style: TextStyle(
                                            color: AppColors.primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimens.pt23),
                                      ),
                                      Text(
                                        "有效期: " +
                                            DateTimeUtil.utc2iso(
                                              VariableConfig.goldTickets.list[index].expireTime,
                                            ),
                                        style: TextStyle(
                                            color: Color.fromRGBO(100, 94, 91, 1), fontSize: Dimens.pt12),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Dimens.pt10,
                                ),
                                Container(
                                  //margin: EdgeInsets.only(left: Dimens.pt34),
                                  child: GFCheckbox(
                                    value: VariableConfig.goldTickets.list[index].isSelected,
                                    size: 23,
                                    inactiveBgColor: Color.fromRGBO(252, 228, 202, 1),
                                    inactiveBorderColor: Color.fromRGBO(175, 175, 175, 1),
                                    type: GFCheckboxType.circle,
                                    activeBgColor: AppColors.primaryTextColor,
                                    onChanged: (value) {
                                      VariableConfig.goldTickets.list.forEach((element) {
                                        if (VariableConfig.goldTickets.list[index] == element) {
                                          if (element.isSelected) {
                                            element.setIsSelected(false);

                                            Config.goldTicketList = null;
                                          } else {
                                            element.setIsSelected(true);

                                            Config.goldTicketList = element;
                                          }
                                        } else {
                                          element.setIsSelected(false);
                                        }
                                      });

                                      dispatch(PayForActionCreator.updateUI());

                                      // states(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
}

///2.支付风控提示弹出框
void _buildPayNoticeDialog(PayForState state, Dispatch dispatch, ViewService viewService) async {
  var result = await showDialog(
      context: viewService.context,
      builder: (BuildContext context) {
        return PayNoticeDialog();
      });

  l.d("_buildPayNoticeDialog", "$result");
  if (result != null && result is String && result == "startPay") {
    l.d("_buildPayNoticeDialog", "开始支付");

    ///2.支付购买会员
    l.e("购买会员", "支付购买会员");
    if (!state.isPayLoading) {
      dispatch(PayForActionCreator.onConventional(state.payRadioType));

      //埋点统计
      try {
        GraphicsType buyType = GraphicsType.vip;
        if (state.vipItem == null) {
          buyType = GraphicsType.coin;
        }
        if (Config.videoModel != null && Config.payFromType == PayFormType.video) {
          EventTrackingManager().addVideoVipGraphicss(Config.videoModel.id, Config.videoModel.title, buyType);
          AnalyticsEvent.videoPullupPaymentOrder(Config.videoModel.id,
              (Config.videoModel.tags ?? []).map((e) => e.name).toList(), Config.videoModel.title);
        } else if (Config.payFromType == PayFormType.banner) {
          EventTrackingManager().addBannerVipGraphicss(buyType);
        } else if (Config.payFromType == PayFormType.sign) {
          EventTrackingManager().addUserVipGraphicss(buyType, eventType: "signIn");
        } else if (Config.payFromType == PayFormType.dashang) {
          EventTrackingManager().addUserVipGraphicss(buyType, eventType: "exceptional");
        } else {
          EventTrackingManager().addUserVipGraphicss(buyType);
        }
        Config.videoModel = null;
        Config.payFromType = null;
        Config.payBuyType = null;
      } catch (e) {}
    } else {
      showToast(msg: Lang.PAYING_TIP);
    }
  }
}

///金币购买会员
Widget _buildBuyVIPGoldCoinUI(PayForState state, Dispatch dispatch) {
  ///如果要展示金币购买UI，并且普通支付方式数据为空，则通知执行选中金币购买
  bool showVipGoldCoinUI = state.vipItem != null && (state?.vipItem?.isAmountPay ?? false);
  if (showVipGoldCoinUI && (state.payList ?? []).isEmpty) {
    dispatch(PayForActionCreator.updatePayRadioType(-1));
  }

  return Visibility(
    visible: showVipGoldCoinUI,
    child: GestureDetector(
      onTap: () => dispatch(PayForActionCreator.updatePayRadioType(-1)),
      child: Container(
        height: Dimens.pt45,
        margin: EdgeInsets.only(bottom: 32),
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(0, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Dimens.pt35,
                height: Dimens.pt35,
                child: svgAssets(AssetsSvg.NEW_GOLD_COIN, width: Dimens.pt35, height: Dimens.pt35),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: Dimens.pt10),
                  child: Text(
                    Lang.PAY_FOR_TIP6,
                    style: TextStyle(color: Colors.white, fontSize: Dimens.pt16),
                  ),
                ),
              ),
              Radio(
                value: -1,
                activeColor: AppColors.primaryTextColor,
                focusColor: Color(0xFF4F515A),
                onChanged: (value) {
                  l.e("payRadioType", "$value");
                  dispatch(PayForActionCreator.updatePayRadioType(-1));
                },
                groupValue: state.payRadioType,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

///创建支付类型
Widget _buildPayTypeItemUI(PayForState state, Dispatch dispatch, PayType payType, String giftStr, int index) {
  return GestureDetector(
    onTap: () => dispatch(PayForActionCreator.updatePayRadioType(index)),
    child: Container(
      height: Dimens.pt45,
      color: Color.fromRGBO(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: Dimens.pt35,
                  height: Dimens.pt35,
                  child: svgAssets(payType.localImgPath, width: Dimens.pt35, height: Dimens.pt35),
                ),
                payType.isOfficial
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: svgAssets(AssetsSvg.IC_OFFICIAL, width: Dimens.pt15, height: Dimens.pt15),
                      )
                    : Container(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimens.pt10),
                child: Row(
                  children: <Widget>[
                    Text(
                      payType.typeName,
                      style: TextStyle(color: Colors.white, fontSize: Dimens.pt16),
                    ),
                    Visibility(
                      visible: payType.isOfficial,
                      child: Padding(
                        padding: EdgeInsets.only(left: Dimens.pt5),
                        child: svgAssets(AssetsSvg.IC_RECOMMEND),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: giftStr?.isNotEmpty ?? false,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Dimens.pt3, horizontal: Dimens.pt5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 215, 215),
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.pt15)),
                ),
                child: Text(
                  giftStr,
                  style: TextStyle(color: AppColors.primaryTextColor, fontSize: Dimens.pt10),
                ),
              ),
            ),
            Radio(
              value: index,
              activeColor: AppColors.primaryTextColor,
              focusColor: Color(0xFF4F515A),
              onChanged: (value) {
                l.e("payRadioType", "$value");
                dispatch(PayForActionCreator.updatePayRadioType(value));
              },
              groupValue: state.payRadioType,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    ),
  );
}
