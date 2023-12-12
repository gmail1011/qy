import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/wallet/pay_for/model/pay_type.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/pay_notice_dialog.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PayForGameState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      state.isPayLoading ? LoadingWidget() : Container(),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.payBackgroundColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                  color: Color(0xff151515),
                ),
              )),
            ),
            Center(
              child: Divider(
                color: Color(0xffe5ded3),
                height: 1,
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomScrollView(
                controller: state.scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      PayType payType = state.payList[index];
                      String giftStr = '';
                      // if (payType.increaseAmount != null &&
                      //     payType.increaseAmount != '0') {
                      //   giftStr =
                      //       "赠送${payType.increaseAmount}${Lang.GOLD_COIN}";
                      // } else if (payType.incTax != null &&
                      //     payType.incTax != '0') {
                      //   giftStr = "赠送${payType.increaseAmount}%";
                      // }

                      return _buildPayTypeItemUI(
                          state, dispatch, payType, giftStr, index);
                    }, childCount: state.payList?.length ?? 0),
                  ),
                  // SliverToBoxAdapter(
                  //     child: _buildBuyVIPGoldCoinUI(state, dispatch)),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimens.pt26, right: Dimens.pt26, top: Dimens.pt8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "支付小贴士：",
                          style: TextStyle(
                              color: AppColors.userPumpkinOrangeColor,
                              fontSize: Dimens.pt12),
                        ),
                        SizedBox(height: Dimens.pt5),
                        Text(
                          "1、跳转后请及时付款，超时支付无法到账，要重新发起。\n2、每天发起支付不能超过5次，连续发起且未支付，账号可能被加入黑名单。",
                          style: TextStyle(
                            color: AppColors.paySubTextColor,
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
            Text(
              "支付遇到问题联系客服",
              style: TextStyle(
                  color: AppColors.userPumpkinOrangeColor,
                  fontSize: Dimens.pt12),
            ),
            SizedBox(height: Dimens.pt10),
            commonSubmitButton("立即支付", onTap: () {
              ///1.金币购买会员
              // if (state.payRadioType == -1) {
              //   l.e("购买会员", "金币购买会员");
              //
              //   ///不需要返回参数
              //   if (!(state.needBackArgs ?? false)) {
              //     safePopPage(viewService.context);
              //   }
              //   dispatch(PayForGameActionCreator.glodBuyVip());
              //   return;
              // }

              ///2.浏览器支付风险提示
              _buildPayNoticeDialog(state, dispatch, viewService);
            }),
            SizedBox(height: Dimens.pt22),
          ],
        ),
      ),
    ],
  );
}

///2.支付风控提示弹出框
void _buildPayNoticeDialog(
    PayForGameState state, Dispatch dispatch, ViewService viewService) async {
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
      dispatch(PayForGameActionCreator.onConventional(state.payRadioType));
    } else {
      showToast(msg: Lang.PAYING_TIP);
    }
  }
}

///金币购买会员
Widget _buildBuyVIPGoldCoinUI(PayForGameState state, Dispatch dispatch) {
  ///如果要展示金币购买UI，并且普通支付方式数据为空，则通知执行选中金币购买
  // bool showVipGoldCoinUI =
  //     state.vipItem != null && (state?.vipItem?.isAmountPay ?? false);
  // if (showVipGoldCoinUI && (state.payList ?? []).isEmpty) {
  //   dispatch(PayForGameActionCreator.updatePayRadioType(-1));
  // }

  return Visibility(
    visible: false,
    child: GestureDetector(
      onTap: () => dispatch(PayForGameActionCreator.updatePayRadioType(-1)),
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
                child: svgAssets(AssetsSvg.NEW_GOLD_COIN,
                    width: Dimens.pt35, height: Dimens.pt35),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: Dimens.pt10),
                  child: Text(
                    Lang.PAY_FOR_TIP6,
                    style: TextStyle(
                        color: Color(0xff1e1e1e), fontSize: Dimens.pt16),
                  ),
                ),
              ),
              Radio(
                value: -1,
                activeColor: Color(0xFFFF7F0F),
                focusColor: Color(0xFF4F515A),
                onChanged: (value) {
                  l.e("payRadioType", "$value");
                  dispatch(PayForGameActionCreator.updatePayRadioType(-1));
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
Widget _buildPayTypeItemUI(PayForGameState state, Dispatch dispatch,
    PayType payType, String giftStr, int index) {
  return GestureDetector(
    onTap: () => dispatch(PayForGameActionCreator.updatePayRadioType(index)),
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
                  child: svgAssets(payType.localImgPath,
                      width: Dimens.pt35, height: Dimens.pt35),
                ),
                payType.isOfficial
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: svgAssets(AssetsSvg.IC_OFFICIAL,
                            width: Dimens.pt15, height: Dimens.pt15),
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
                      style: TextStyle(
                          color: Color(0xff151515), fontSize: Dimens.pt16),
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
                padding: EdgeInsets.symmetric(
                    vertical: Dimens.pt3, horizontal: Dimens.pt5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 215, 215),
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.pt15)),
                ),
                child: Text(
                  giftStr,
                  style: TextStyle(
                      color: Color.fromARGB(255, 248, 0, 0),
                      fontSize: Dimens.pt10),
                ),
              ),
            ),
            Radio(
              value: index,
              activeColor: Color(0xFFFF7F0F),
              focusColor: Color(0xFF4F515A),
              onChanged: (value) {
                l.e("payRadioType", "$value");
                dispatch(PayForGameActionCreator.updatePayRadioType(value));
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
