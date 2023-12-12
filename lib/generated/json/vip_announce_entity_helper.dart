import 'package:flutter_app/model/vip_announce_entity.dart';

vipAnnounceEntityFromJson(VipAnnounceEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => VipAnnounceData().fromJson(v)).toList();
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

Map<String, dynamic> vipAnnounceEntityToJson(VipAnnounceEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] =  entity.data?.map((v) => v.toJson())?.toList();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

vipAnnounceDataFromJson(VipAnnounceData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['url'] != null) {
		data.url = json['url'].toString();
	}
	if (json['active'] != null) {
		data.active = json['active'];
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt'].toString();
	}
	return data;
}

Map<String, dynamic> vipAnnounceDataToJson(VipAnnounceData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['content'] = entity.content;
	data['url'] = entity.url;
	data['active'] = entity.active;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}