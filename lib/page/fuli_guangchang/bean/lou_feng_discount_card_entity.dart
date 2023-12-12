import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class LouFengDiscountCardEntity with JsonConvert<LouFengDiscountCardEntity> {
	int code;
	LouFengDiscountCardData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class LouFengDiscountCardData with JsonConvert<LouFengDiscountCardData> {
	int originalPrice;
	int discountedPrice;
	List<LouFengDiscountCardDataCouponList> couponList;
	bool isDiscounted;
	bool isHaveCoupon;
}

class LouFengDiscountCardDataCouponList with JsonConvert<LouFengDiscountCardDataCouponList> {
	String id;
	String name;
	int count;
	int discountedPrice;
}
