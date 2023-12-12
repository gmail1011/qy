import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

///钱包UI
Widget buildView(
    WalletState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: [
      Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //我的钱包UI
                Container(
                  width: screen.screenWidth,
                  height: Dimens.pt166,
                  margin: const EdgeInsets.only(
                      left: 16, top: 18, right: 16, bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.userWalletBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 13, top: 14),
                        child: Text(
                          "我的金币",
                          style: TextStyle(
                              color: Colors.white, fontSize: Dimens.pt12),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: _createWalletMenu(
                                "金币余额", "${state.wallet?.amount ?? 0}", "账单明细",
                                () {
                              JRouter().go(PAGE_MY_BILL);
                            }), //
                          ),
                          Expanded(
                            flex: 1,
                            child: _createWalletMenu(
                                "收益余额", "${state.wallet?.income ?? 0}", "收益中心",
                                () {
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //在线充值UI
                _createOnlineRechargeUI(),

                //充值列表
                _createRechargeUI(state, dispatch, viewService),
              ],
            ),
          )),
      Container(
        margin: EdgeInsets.only(top: 12),
        alignment: Alignment.center,
        child: commonSubmitButton("立即充值", onTap: () {
          if (state.rechargeType == null && state.dcModel == null) {
            return;
          }
          var arg = PayForArgs();
          arg.dcModel = state.dcModel;
          arg.rechargeModel = state.rechargeType[state.selectIndex];
          showPayListDialog(viewService.context, arg);
        }),
      ),
      GestureDetector(
        onTap: () => csManager.openServices(viewService.context),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "支付中如有问题，请在线联系 ",
                      style: TextStyle(
                        color: AppColors.userPayTextColor.withAlpha(59),
                        fontSize: AppFontSize.fontSize10,
                      ),
                    ),
                    TextSpan(
                      text: '联系客服',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSize.fontSize10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
    ],
  );
}

///在线充值UI
Widget _createOnlineRechargeUI() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(left: 20),
    child: Column(
      children: [
        Text(
          "在线充值",
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.pt16,
          ),
        ),
        Container(
          width: Dimens.pt64,
          height: Dimens.pt1,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.taskCenterLineColors),
            borderRadius: BorderRadius.circular(Dimens.pt2),
          ),
        ),
      ],
    ),
  );
}

///在线充值列表
Widget _createRechargeUI(
    WalletState state, Dispatch dispatch, ViewService viewService) {
  return BaseRequestView(
    controller: state.requestController,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 10,
              left: 16,
              right: 16,
              bottom: 10,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 124 / (76 + 12),
            ),
            itemCount: state.rechargeType?.length ?? 0,
            itemBuilder: (context, index) {
              double itemWidth = (screen.screenWidth - 16 * 2 - 10 * 2) / 3;
              double itemHeight = itemWidth * (76 + 12) / 124;
              RechargeTypeModel item = state.rechargeType[index];
              bool isSelect = index == state.selectIndex;

              Widget contentView = isSelect
                  ? _rechargeSelectItem(item, () {
                      dispatch(WalletActionCreator.selectCurrentIndex(index));
                    })
                  : _rechargeItem(item, () {
                      dispatch(WalletActionCreator.selectCurrentIndex(index));
                    });
              return Stack(
                children: [
                  Container(
                    width: itemWidth,
                    height: itemHeight,
                    padding: EdgeInsets.only(top: 10),
                    child: contentView,
                  ),
                  if (item.hotStatus == true)
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 20,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Color(0xffee8636),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(1),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(1),
                          ),
                        ),
                        child: Text(
                          "热卖",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );

              return contentView;
              //_rechargeItem

              /*return _rechargeItem(item, () {
                dispatch(WalletActionCreator.selectCurrentIndex(index));
              }, index == state.selectIndex);*/
            },
          ),
        ),
      ],
    ),
  );
}

///选中钱包金额item
Widget _rechargeSelectItem(RechargeTypeModel item, Function onTop) {
  bool hasSendAmountUI = (item?.firstGiveGold ?? 0) > 0; //是否有赠送UI

  return InkWell(
    onTap: onTop,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
        gradient: LinearGradient(colors: [
          Color(0xfff4d88a),
          Color(0xffd6be7e).withOpacity(0.37),
          Color(0xffc3ae76).withOpacity(0.30)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          ///背景图
          Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff3b341f),
                  Color(0xff2b2b2b),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: hasSendAmountUI ? 7 : 0),
                child: Text(
                  "¥${(item.money) ~/ 100}",
                  style: TextStyle(
                    fontSize: hasSendAmountUI ? Dimens.pt11 : Dimens.pt12,
                    color: Color(0xff958658),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  svgAssets(AssetsSvg.NEW_GOLD_COIN,
                      width: Dimens.pt14, height: Dimens.pt14),
                  const SizedBox(width: 2),
                  Text(
                    '${item.amount}',
                    style: TextStyle(
                      color: Color(0xfff1d589),
                      fontWeight: FontWeight.bold,
                      fontSize: hasSendAmountUI ? Dimens.pt16 : Dimens.pt18,
                    ),
                  ),
                ],
              ),

              ///首充送金币
              if (hasSendAmountUI) Spacer(),
              if (hasSendAmountUI)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  height: Dimens.pt19,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff494231),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.pt4),
                      bottomRight: Radius.circular(Dimens.pt4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "首充送${item.firstGiveGold}金币",
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      color: Color(0xfff1d589),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

///选中钱包金额item
Widget _rechargeItem(RechargeTypeModel item, Function onTop) {
  bool hasSendAmountUI = (item?.firstGiveGold ?? 0) > 0; //是否有赠送UI

  return InkWell(
    onTap: onTop,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
        gradient: LinearGradient(colors: [
          Color(0xff5c5c5c).withOpacity(0.24),
          Color(0xff5c5c5c).withOpacity(0.24),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          ///背景图
          Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Color(0xff1f1f1f),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: hasSendAmountUI ? 7 : 0),
                child: Text(
                  "¥${(item.money) ~/ 100}",
                  style: TextStyle(
                    fontSize: hasSendAmountUI ? Dimens.pt11 : Dimens.pt12,
                    color: Color(0xff848484),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  svgAssets(AssetsSvg.NEW_GOLD_COIN,
                      width: Dimens.pt14, height: Dimens.pt14),
                  const SizedBox(width: 2),
                  Text(
                    '${item.amount}',
                    style: TextStyle(
                      color: Color(0xff848484),
                      fontWeight: FontWeight.bold,
                      fontSize: hasSendAmountUI ? Dimens.pt16 : Dimens.pt18,
                    ),
                  ),
                ],
              ),

              ///首充送金币
              if (hasSendAmountUI) Spacer(),
              if (hasSendAmountUI)
                Container(
                  height: Dimens.pt19,
                  width: double.infinity,
                  // margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: Color(0xff3c3c3c),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.pt4),
                      bottomRight: Radius.circular(Dimens.pt4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "首充送${item.firstGiveGold}金币",
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      color: Color(0xff787878),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

///创建钱包菜单
Widget _createWalletMenu(
    String str1, String str2, String str3, Function onTapCallback) {
  return Container(
    margin: const EdgeInsets.only(top: 20, left: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str1,
          maxLines: 1,
          style: TextStyle(
              color: Colors.white.withOpacity(0.5), fontSize: Dimens.pt12),
        ),
        SizedBox(height: 5),
        Text(
          str2,
          maxLines: 1,
          style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.pt30,
              fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: onTapCallback,
          child: Container(
            alignment: Alignment.center,
            width: Dimens.pt84,
            height: Dimens.pt28,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xff3c3c3c),
            ),
            child: Text(
              str3,
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
            ),
          ),
        ),
      ],
    ),
  );
}
