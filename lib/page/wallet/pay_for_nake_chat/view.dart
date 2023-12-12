import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/page/wallet/pay_for/action.dart';
import 'package:flutter_app/page/wallet/pay_for/model/pay_type.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'state.dart';

Widget buildView(
    PayForNakeChatState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      state.isPayLoading ? LoadingWidget() : Container(),
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: Dimens.pt10, bottom: Dimens.pt10),
            child: Center(
                child: Text(
              Lang.PAY_FOR_TIP0,
              style: TextStyle(
                  fontSize: Dimens.pt16,
                  color: Color(0xff1e1e1e),
                  fontWeight: FontWeight.bold),
            )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Dimens.pt10),
            child: Center(
                child: Text(
              "${state.payMoney / 10}${Lang.GOLD_COIN}",
              style: TextStyle(fontSize: Dimens.pt12, color: Color(0xffbdbdbd)),
            )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Dimens.pt15),
            child: Center(
                child: Text.rich(TextSpan(children: [
              TextSpan(
                text: '¥',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: Dimens.pt16,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: "${state.payMoney ~/ 100}",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: Dimens.pt30,
                    fontWeight: FontWeight.bold),
              ),
            ]))),
          ),
          Center(
            child: Divider(
              color: Color(0xffdddddd),
              height: 1,
            ),
          ),
          Visibility(
            visible:
                state.vipItem != null && (state?.vipItem?.isAmountPay ?? false),
            child: GestureDetector(
              onTap: () {
                dispatch(PayForActionCreator.glodBuyVip());
              },
              child: Column(
                children: [
                  Container(
                    color: Color.fromRGBO(0, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: Dimens.pt30,
                            height: Dimens.pt30,
                            child: svgAssets(AssetsSvg.IC_GOLD,
                                width: Dimens.pt30, height: Dimens.pt30),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimens.pt10),
                              child: Text(
                                Lang.PAY_FOR_TIP6,
                                style: TextStyle(
                                    color: Color(0xff1e1e1e),
                                    fontSize: Dimens.pt16),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Color(0xFF999999),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Color(0xffdddddd),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  color: Color(0xffdddddd),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                PayType payType = state.payList[index];
                String giftStr = '';
                if (payType.increaseAmount != null &&
                    payType.increaseAmount != '0') {
                  giftStr = "赠送${payType.increaseAmount}${Lang.GOLD_COIN}";
                } else if (payType.incTax != null && payType.incTax != '0') {
                  giftStr = "赠送${payType.increaseAmount}%";
                }
                return GestureDetector(
                  onTap: () {
                    if (!state.isPayLoading) {
                      dispatch(PayForActionCreator.onConventional(index));
                    } else {
                      showToast(msg: Lang.PAYING_TIP);
                    }
                  },
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: Dimens.pt30,
                                height: Dimens.pt30,
                                child: svgAssets(payType.localImgPath,
                                    width: Dimens.pt30, height: Dimens.pt30),
                              ),
                              payType.isOfficial
                                  ? Positioned(
                                      top: 0,
                                      left: 0,
                                      child: svgAssets(AssetsSvg.IC_OFFICIAL,
                                          width: Dimens.pt15,
                                          height: Dimens.pt15),
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
                                        color: Color(0xff1e1e1e),
                                        fontSize: Dimens.pt16),
                                  ),
                                  Visibility(
                                    visible: payType.isOfficial,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: Dimens.pt5),
                                      child: svgAssets(AssetsSvg.IC_RECOMMEND),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: giftStr.isNotEmpty,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimens.pt3, horizontal: Dimens.pt5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 215, 215),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt15)),
                              ),
                              child: Text(
                                giftStr,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 248, 0, 0),
                                    fontSize: Dimens.pt10),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Color(0xFF999999),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: state.payList.length,
            ),
          ),
        ],
      ),
    ],
  );
}
