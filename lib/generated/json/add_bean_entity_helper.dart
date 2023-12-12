import 'package:flutter_app/weibo_page/message/add/add_bean_entity.dart';

addBeanEntityFromJson(AddBeanEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = AddBeanData().fromJson(json['data']);
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

Map<String, dynamic> addBeanEntityToJson(AddBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

addBeanDataFromJson(AddBeanData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => AddBeanDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> addBeanDataToJson(AddBeanData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

addBeanDataListFromJson(AddBeanDataList data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'].toString();
	}
	if (json['portrait'] != null) {
		data.portrait = json['portrait'].toString();
	}
	if (json['hasLocked'] != null) {
		data.hasLocked = json['hasLocked'];
	}
	if (json['hasBanned'] != null) {
		data.hasBanned = json['hasBanned'];
	}
	if (json['vipLevel'] != null) {
		data.vipLevel = json['vipLevel'] is String
				? int.tryParse(json['vipLevel'])
				: json['vipLevel'].toInt();
	}
	if (json['isVip'] != null) {
		data.isVip = json['isVip'];
	}
	if (json['rechargeLevel'] != null) {
		data.rechargeLevel = json['rechargeLevel'] is String
				? int.tryParse(json['rechargeLevel'])
				: json['rechargeLevel'].toInt();
	}
	if (json['superUser'] != null) {
		data.superUser = json['superUser'] is String
				? int.tryParse(json['superUser'])
				: json['superUser'];
	}
	if (json['activeValue'] != null) {
		data.activeValue = json['activeValue'] is String
				? int.tryParse(json['activeValue'])
				: json['activeValue'].toInt();
	}
	if (json['officialCert'] != null) {
		data.officialCert = json['officialCert'];
	}
	if (json['age'] != null) {
		data.age = json['age'] is String
				? int.tryParse(json['age'])
				: json['age'].toInt();
	}
	if (json['follows'] != null) {
		data.follows = json['follows'] is String
				? int.tryParse(json['follows'])
				: json['follows'].toInt();
	}
	if (json['fans'] != null) {
		data.fans = json['fans'] is String
				? int.tryParse(json['fans'])
				: json['fans'].toInt();
	}
	if (json['summary'] != null) {
		data.summary = json['summary'].toString();
	}
	if (json['hasFollowed'] != null) {
		data.hasFollowed = json['hasFollowed'];
	}
	return data;
}

Map<String, dynamic> addBeanDataListToJson(AddBeanDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['gender'] = entity.gender;
	data['portrait'] = entity.portrait;
	data['hasLocked'] = entity.hasLocked;
	data['hasBanned'] = entity.hasBanned;
	data['vipLevel'] = entity.vipLevel;
	data['isVip'] = entity.isVip;
	data['rechargeLevel'] = entity.rechargeLevel;
	data['superUser'] = entity.superUser;
	data['activeValue'] = entity.activeValue;
	data['officialCert'] = entity.officialCert;
	data['age'] = entity.age;
	data['follows'] = entity.follows;
	data['fans'] = entity.fans;
	data['summary'] = entity.summary;
	data['hasFollowed'] = entity.hasFollowed;
	return data;
}