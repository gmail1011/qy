import 'package:flutter_app/model/bang_dan_detail_entity.dart';

bangDanDetailEntityFromJson(BangDanDetailEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = BangDanDetailData().fromJson(json['data']);
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

Map<String, dynamic> bangDanDetailEntityToJson(BangDanDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

bangDanDetailDataFromJson(BangDanDetailData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.list = (json['list'] as List).map((v) => BangDanRankType().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> bangDanDetailDataToJson(BangDanDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.list?.map((v) => v.toJson())?.toList();
	return data;
}

bangDanRankTypeFromJson(BangDanRankType data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['typeDesc'] != null) {
		data.typeDesc = json['typeDesc'].toString();
	}
	if (json['members'] != null) {
		data.members = (json['members'] as List).map((v) => BangDanDetailDataMembers().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> bangDanRankTypeToJson(BangDanRankType entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['typeDesc'] = entity.typeDesc;
	data['members'] =  entity.members?.map((v) => v.toJson())?.toList();
	return data;
}

bangDanDetailDataMembersFromJson(BangDanDetailDataMembers data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['value'] != null) {
		data.value = json['value'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['superUser'] != null) {
		data.superUser = json['superUser'] is String
				? int.tryParse(json['superUser'])
				: json['superUser'];
	}
	if (json['merchantUser'] != null) {
		data.merchantUser = json['merchantUser'] is String
				? int.tryParse(json['merchantUser'])
				: json['merchantUser'].toInt();
	}
	if (json['vipLevel'] != null) {
		data.vipLevel = json['vipLevel'] is String
				? int.tryParse(json['vipLevel'])
				: json['vipLevel'].toInt();
	}
	if (json['vipExpireDate'] != null) {
		data.vipExpireDate = json['vipExpireDate'].toString();
	}
	return data;
}

Map<String, dynamic> bangDanDetailDataMembersToJson(BangDanDetailDataMembers entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['avatar'] = entity.avatar;
	data['value'] = entity.value;
	data['id'] = entity.id;
	data['superUser'] = entity.superUser;
	data['merchantUser'] = entity.merchantUser;
	data['vipLevel'] = entity.vipLevel;
	data['vipExpireDate'] = entity.vipExpireDate;
	return data;
}