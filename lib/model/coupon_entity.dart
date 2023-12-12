import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class CouponEntity with JsonConvert<CouponEntity> {
  int code;
  CouponData data;
  bool hash;
  String msg;
  String time;
  String tip;
}

class CouponData with JsonConvert<CouponData> {
  int originalPrice;
  int discountedPrice;
  List<CouponDataCouponList> couponList;
  bool isDiscounted;
}

class CouponDataCouponList with JsonConvert<CouponDataCouponList> {
  String id;
  String name;
  int count;
  int discountedPrice;
}
