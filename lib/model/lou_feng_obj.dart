import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/user/product_item.dart';

class LouFengObj {
  LouFengItem loufeng;
  ProductItemBean productItemBean;
  LouFengObj({this.loufeng});

  LouFengObj.fromJson(Map<String, dynamic> json) {
    loufeng = json['loufeng'] != null
        ? new LouFengItem.fromJson(json['loufeng'])
        : null;
    productItemBean = json['discountCard'] != null
        ? new ProductItemBean.fromJson(json['discountCard'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loufeng != null) {
      data['loufeng'] = this.loufeng.toJson();
    }
    if (this.productItemBean != null) {
      data['discountCard'] = this.productItemBean.toJson();
    }
    return data;
  }
}
