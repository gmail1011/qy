import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';

import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/user/new_product_list_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_base/utils/array_util.dart';

import 'model/pay_type.dart';

class PayForState with EagleHelper implements Cloneable<PayForState> {
  ScrollController scrollController = ScrollController();

  List<PayType> payList = [];
  int payMoney = 0;

  ///产品数据
  RechargeTypeModel rechargeModel;

  ///tab数据
  TabVipItem curTabVipItem;

  ///vip model
  ProductItemBean vipItem;

  ///代充的数据
  DCModel dcModel;

  bool isPayLoading;

  bool isDialog = true;

  int payRadioType = 0;

  bool needBackArgs = false;


  bool selectTickets = false;

  PayForState({PayForArgs args}) {
    if (args != null) {
      ///代充信息
      dcModel = args?.dcModel;

      curTabVipItem = args?.curTabVipItem;

      ///vip
      vipItem = args?.vipitem;

      ///是否已弹窗方式显示
      isDialog = args?.isDialog;
      isPayLoading = false;

      ///是否需要返回参数值
      needBackArgs = args?.needBackArgs;
      ///产品信息
      rechargeModel = args.rechargeModel;
      if (args.rechargeModel != null) {
        payMoney = args.rechargeModel.money;
      } else if (args.vipitem != null) {
        ///这是x10 是因为discountedPrice 单位是金币
        payMoney = (args.vipitem.discountedPrice ?? 0) * 10;
      } else {
        payMoney = 0;
      }

      var rechargeTypeList = <RechargeTypeBean>[];
      if (rechargeModel != null) {
        rechargeTypeList = rechargeModel.rechargeTypeList;
      } else if (vipItem != null) {
        rechargeTypeList = vipItem.rchgType;
      } else {
        return;
      }
      List<String> svgPayIconList = [
        AssetsSvg.SVG_PAY_ICON101,
        AssetsSvg.SVG_PAY_ICON102,
        AssetsSvg.SVG_PAY_ICON103,
        AssetsSvg.SVG_PAY_ICON104,
      ];

      ///有支付方式
      if (ArrayUtil.isNotEmpty(rechargeTypeList)) {
        for (var rechargeTypeBean in rechargeTypeList) {
          if (rechargeTypeBean.type == 'daichong') {
            if (dcModel?.traders?.isNotEmpty ?? false) {
              PayForModel payForModel = dcModel.traders[0];
              if (payForModel?.payInfos?.isNotEmpty ?? false) {
                for (PayInfoModel payInfoModel in payForModel.payInfos) {
                  var payType = PayType();
                  payType.isOfficial = true;
                  payType.channel = rechargeTypeBean.channel;
                  payType.payMethod = payInfoModel.payMethod;
                  payType.increaseAmount = rechargeTypeBean.incrAmount;
                  payType.incTax = rechargeTypeBean.incTax;
                  if (payInfoModel.payMethod == 101) {
                    payType.type = 'alipy';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[0];
                    payType.localImgPath = svgPayIconList[0];
                  } else if (payInfoModel.payMethod == 102) {
                    payType.type = 'wechat';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[1];
                    payType.localImgPath = svgPayIconList[1];
                  } else if (payInfoModel.payMethod == 103) {
                    payType.type = 'union';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[2];
                    payType.localImgPath = svgPayIconList[2];
                  } else if (payInfoModel.payMethod == 104) {
                    payType.type = 'credit';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[3];
                    payType.localImgPath = svgPayIconList[3];
                  } else if (payInfoModel.payMethod == 105) {
                    payType.type = 'huabei';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[4];
                    payType.localImgPath = svgPayIconList[3];
                  } else if (payInfoModel.payMethod == 106) {
                    payType.type = 'yunSanPay';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[5];
                    payType.localImgPath = svgPayIconList[3];
                  } else if (payInfoModel.payMethod == 107) {
                    payType.type = 'qqWallet';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[6];
                    payType.localImgPath = svgPayIconList[3];
                  } else if (payInfoModel.payMethod == 108) {
                    payType.type = 'jindongPay';
                    payType.typeName = Lang.PAY_FOR_ICON_NAMES[7];
                    payType.localImgPath = svgPayIconList[3];
                  }
                  payList.add(payType);
                }
              }
            }
          } else {
            var payType = PayType();
            payType.isOfficial = false;
            payType.type = rechargeTypeBean.type;
            payType.typeName = rechargeTypeBean.typeName;
            payType.channel = rechargeTypeBean.channel;
            payType.increaseAmount = rechargeTypeBean.incrAmount;
            payType.incTax = rechargeTypeBean.incTax;
            if (payType.type == 'alipay') {
              payType.localImgPath = svgPayIconList[0];
            } else if (payType.type == 'wechat') {
              payType.localImgPath = svgPayIconList[1];
            } else if (payType.type == 'union') {
              payType.localImgPath = svgPayIconList[2];
            } else {
              payType.localImgPath = svgPayIconList[3];
            }
            payList.add(payType);
          }
        }
      }
    }
  }

  @override
  PayForState clone() {
    return PayForState()
      ..rechargeModel = rechargeModel
      ..payList = payList
      ..dcModel = dcModel
      ..payMoney = payMoney
      ..isPayLoading = isPayLoading
      ..isDialog = isDialog
      ..vipItem = vipItem
      ..curTabVipItem = curTabVipItem
      ..payRadioType = payRadioType
      ..scrollController = scrollController
      ..selectTickets = selectTickets
      ..needBackArgs = needBackArgs;
  }
}

PayForState initState(PayForArgs args) {
  PayForState newState = PayForState(args: args);
  return newState;
}

class PayForArgs {
  DCModel dcModel;
  RechargeTypeModel rechargeModel;
  ProductItemBean vipitem;
  bool isDialog = true;
  TabVipItem curTabVipItem;
  bool needBackArgs = false;

  PayForArgs(
      {this.dcModel,
      this.rechargeModel,
      this.vipitem,
      this.isDialog = true,
      this.curTabVipItem,
      this.needBackArgs = false});
}
