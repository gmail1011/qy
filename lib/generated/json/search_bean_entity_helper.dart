import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';

searchBeanEntityFromJson(SearchBeanEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = SearchBeanData().fromJson(json['data']);
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

Map<String, dynamic> searchBeanEntityToJson(SearchBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

searchBeanDataFromJson(SearchBeanData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => SearchBeanDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> searchBeanDataToJson(SearchBeanData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

searchBeanDataListFromJson(SearchBeanDataList data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['age'] != null) {
		data.age = json['age'] is String
				? int.tryParse(json['age'])
				: json['age'].toInt();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'].toString();
	}
	if (json['portrait'] != null) {
		data.portrait = json['portrait'].toString();
	}
	if (json['region'] != null) {
		data.region = json['region'].toString();
	}
	if (json['summary'] != null) {
		data.summary = json['summary'].toString();
	}
	if (json['vipLevel'] != null) {
		data.vipLevel = json['vipLevel'] is String
				? int.tryParse(json['vipLevel'])
				: json['vipLevel'].toInt();
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
	if (json['isVip'] != null) {
		data.isVip = json['isVip'];
	}
	if (json['hasFollowed'] != null) {
		data.hasFollowed = json['hasFollowed'];
	}
	if (json['fansCount'] != null) {
		data.fansCount = json['fansCount'] is String
				? int.tryParse(json['fansCount'])
				: json['fansCount'].toInt();
	}
	return data;
}

Map<String, dynamic> searchBeanDataListToJson(SearchBeanDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['age'] = entity.age;
	data['gender'] = entity.gender;
	data['portrait'] = entity.portrait;
	data['region'] = entity.region;
	data['summary'] = entity.summary;
	data['vipLevel'] = entity.vipLevel;
	data['rechargeLevel'] = entity.rechargeLevel;
	data['superUser'] = entity.superUser;
	data['activeValue'] = entity.activeValue;
	data['officialCert'] = entity.officialCert;
	data['isVip'] = entity.isVip;
	data['hasFollowed'] = entity.hasFollowed;
	data['fansCount'] = entity.fansCount;
	return data;
}