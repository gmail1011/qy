import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';

import 'integral_product_item.dart';

/// list : [{"productID":"5dce1d9250300dd6f3aa5e1f","vipLevel":1,"productName":"铂金卡(月度会员)","alias":"","desc":"30天\n","duration":30,"bgImg":"","originalPrice":300,"discountedPrice":200,"productType":0,"sort":1,"status":true,"updatedAt":"0001-01-01T08:05:43+08:05","createdAt":"2019-11-15T11:37:54.009+08:00"}]

class NewProductList {
  DCModel daichong;
  List<TabVipItem> list;
  List<IntegralProductItem> integralList;
  bool isNewUser;

  static NewProductList fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    NewProductList productListBean = NewProductList();
    productListBean.daichong = DCModel.fromJson(map['daichong']);
    productListBean.isNewUser = map["isNewUser"];

    productListBean.list = List()
      ..addAll((map['list'] as List ?? []).map((o) => TabVipItem.fromJson(o)));

    productListBean.integralList = List()
      ..addAll((map['integralList'] as List ?? []).map((o) => IntegralProductItem.fromJson(o)));

    return productListBean;
  }

  Map toJson() => {
        "list": list,
        "integralList": integralList,
        "isNewUser": isNewUser,
        "daichong": daichong.toString(),
      };
}

class TabVipItem {
  String position;
  int showType;
  List<ProductItemBean> vips;
  String positionID;

  TabVipItem.fromJson(Map<String, dynamic> json) {
    this.position = json["position"];
    this.showType = json["showType"];
    this.positionID = json["positionID"];

    this.vips = List<ProductItemBean>();
    if (null != json["list"]) {
      json["list"].forEach((it) {
        vips.add(ProductItemBean.fromJson(it));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["position"] = position;
    if (this.vips != null) {
      data['list'] = this.vips.map((v) => v.toJson()).toList();
    }
    data["showType"] = showType;
    data["positionID"] = positionID;
    return data;
  }
}



