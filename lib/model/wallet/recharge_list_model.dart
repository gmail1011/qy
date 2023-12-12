import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';

/// 可供充值的金币列表
class RechargeListModel {
  DCModel daichong;
  List<RechargeTypeModel> list;

  RechargeListModel.fromJson(Map<String, dynamic> json) {
    daichong = DCModel.fromJson(json['daichong']);
    if (json['list'] != null) {
      list = List<RechargeTypeModel>();
      json['list'].forEach((it) {
        list.add(RechargeTypeModel.fromJson(it));
      });
    }
  }
  Map toJson() => {
        "daichong": daichong,
        "list": list,
      };
}
