/*
 * @Author: your name
 * @Date: 2020-04-27 15:53:28
 * @LastEditTime: 2020-05-21 21:03:41
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter-client-yh/lib/page/user/vip_member_page/state.dart
 */
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/user/new_product_list_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_base/utils/page_intro_helper.dart';
import 'package:flutter_base/utils/text_util.dart';

class MemberCentreState extends GlobalBaseState
    with EagleHelper, PageIntroHelper
    implements Cloneable<MemberCentreState> {
  TabController tabBarController;

  var position = '0';
  String specifyVipCardId;
  TabVipItem curTabVipItem;
  ProductItemBean selectVipItem;
  bool paying = false; //是否处于支付中
  List<String> get privilegeList {
    if (TextUtil.isEmpty(selectVipItem.privilegeDesc)) {
      return [];
    }
    var list = selectVipItem.privilegeDesc.split('_');
    return list;
  }

  String announce;

  ///钱包
  List<RechargeTypeModel> rechargeType = [];
  BaseRequestController baseRequestController = BaseRequestController();
  int selectIndex = 0;

  ///代充
  DCModel dcModel;

  ///是否需要开启兑换会员
  bool startRedemptionMember = false;

  @override
  MemberCentreState clone() {
    return MemberCentreState()
      ..tabBarController = tabBarController
      ..paying = paying
      ..position = position
      ..specifyVipCardId = specifyVipCardId
      ..selectVipItem = selectVipItem
      ..announce = announce
      ..baseRequestController = baseRequestController
      ..rechargeType = rechargeType
      ..selectIndex = selectIndex
      ..curTabVipItem = curTabVipItem
      ..dcModel = dcModel
      ..startRedemptionMember = startRedemptionMember;
  }
}

MemberCentreState initState(Map<String, dynamic> args) {
  final MemberCentreState state = MemberCentreState();
  state.position =
      (args != null && args.containsKey("position")) ? args['position'] : "0";
  state.specifyVipCardId =
      (args != null && args.containsKey("specifyVipCardId"))
          ? args['specifyVipCardId']
          : "";
  state.startRedemptionMember =
      (args != null && args.containsKey("RedemptionMember"))
          ? args['RedemptionMember']
          : false;
  state.tabBarController = new TabController(
      initialIndex: int.parse(state.position),
      length: 2,
      vsync: ScrollableState());
  return state;
}
