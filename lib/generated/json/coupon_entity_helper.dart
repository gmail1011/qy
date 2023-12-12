import 'package:flutter_app/model/coupon_entity.dart';

couponEntityFromJson(CouponEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = CouponData().fromJson(json['data']);
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

Map<String, dynamic> couponEntityToJson(CouponEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

couponDataFromJson(CouponData data, Map<String, dynamic> json) {
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
		data.couponList = (json['couponList'] as List).map((v) => CouponDataCouponList().fromJson(v)).toList();
	}
	if (json['isDiscounted'] != null) {
		data.isDiscounted = json['isDiscounted'];
	}
	return data;
}

Map<String, dynamic> couponDataToJson(CouponData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['originalPrice'] = entity.originalPrice;
	data['discountedPrice'] = entity.discountedPrice;
	data['couponList'] =  entity.couponList?.map((v) => v.toJson())?.toList();
	data['isDiscounted'] = entity.isDiscounted;
	return data;
}

couponDataCouponListFromJson(CouponDataCouponList data, Map<String, dynamic> json) {
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

Map<String, dynamic> couponDataCouponListToJson(CouponDataCouponList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['count'] = entity.count;
	data['discountedPrice'] = entity.discountedPrice;
	return data;
}