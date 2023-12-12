import 'package:flutter_app/page/fuli_guangchang/bean/lou_feng_discount_card_entity.dart';

louFengDiscountCardEntityFromJson(LouFengDiscountCardEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = LouFengDiscountCardData().fromJson(json['data']);
	}
	if (json['hash'] != null) {
		data.hash = json['hash'];
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['time'] != null) {
		data.time = json['time'].toString();
	}
	if (json['tip'] != null) {
		data.tip = json['tip'].toString();
	}
	return data;
}

Map<String, dynamic> louFengDiscountCardEntityToJson(LouFengDiscountCardEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

louFengDiscountCardDataFromJson(LouFengDiscountCardData data, Map<String, dynamic> json) {
	if (json['originalPrice'] != null) {
		data.originalPrice = json['originalPrice'] is String
				? int.tryParse(json['originalPrice'])
				: json['originalPrice'].toInt();
	}
	if (json['discountedPrice'] != null) {
		data.discountedPrice = json['discountedPrice'] is String
				? int.tryParse(json['discountedPrice'])
				: json['discountedPrice'].toInt();
	}
	if (json['couponList'] != null) {
		data.couponList = (json['couponList'] as List).map((v) => LouFengDiscountCardDataCouponList().fromJson(v)).toList();
	}
	if (json['isDiscounted'] != null) {
		data.isDiscounted = json['isDiscounted'];
	}
	if (json['isHaveCoupon'] != null) {
		data.isHaveCoupon = json['isHaveCoupon'];
	}
	return data;
}

Map<String, dynamic> louFengDiscountCardDataToJson(LouFengDiscountCardData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['originalPrice'] = entity.originalPrice;
	data['discountedPrice'] = entity.discountedPrice;
	data['couponList'] =  entity.couponList?.map((v) => v.toJson())?.toList();
	data['isDiscounted'] = entity.isDiscounted;
	data['isHaveCoupon'] = entity.isHaveCoupon;
	return data;
}

louFengDiscountCardDataCouponListFromJson(LouFengDiscountCardDataCouponList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['discountedPrice'] != null) {
		data.discountedPrice = json['discountedPrice'] is String
				? int.tryParse(json['discountedPrice'])
				: json['discountedPrice'].toInt();
	}
	return data;
}

Map<String, dynamic> louFengDiscountCardDataCouponListToJson(LouFengDiscountCardDataCouponList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['count'] = entity.count;
	data['discountedPrice'] = entity.discountedPrice;
	return data;
}