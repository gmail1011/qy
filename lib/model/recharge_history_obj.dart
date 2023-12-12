import 'package:flutter_app/model/recharge_history_model.dart';

/// total : 0
/// hasNext : false

class RechargeHistoryObj {
  List<RechargeHistoryModel> list;
  int total;
  bool hasNext;

  RechargeHistoryObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    total = json['total'];
    if (json['list'] != null) {
      list = List<RechargeHistoryModel>();
      json['list'].forEach((v) {
        list.add(RechargeHistoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNext'] = this.hasNext;
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
