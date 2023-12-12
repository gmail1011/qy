import 'package:flutter_app/model/announce_liao_ba_entity.dart';

announceLiaoBaEntityFromJson(AnnounceLiaoBaEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = AnnounceLiaoBaData().fromJson(json['data']);
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

Map<String, dynamic> announceLiaoBaEntityToJson(AnnounceLiaoBaEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

announceLiaoBaDataFromJson(AnnounceLiaoBaData data, Map<String, dynamic> json) {
	if (json['announcement'] != null) {
		data.announcement = (json['announcement'] as List).map((v) => AnnouncementData().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> announceLiaoBaDataToJson(AnnounceLiaoBaData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['announcement'] =  entity.announcement?.map((v) => v.toJson())?.toList();
	return data;
}

announcementDataFromJson(AnnouncementData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['position'] != null) {
		data.position = json['position'] is String
				? int.tryParse(json['position'])
				: json['position'].toInt();
	}
	if (json['positionDesc'] != null) {
		data.positionDesc = json['positionDesc'].toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> announcementDataToJson(AnnouncementData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['content'] = entity.content;
	data['position'] = entity.position;
	data['positionDesc'] = entity.positionDesc;
	data['createdAt'] = entity.createdAt;
	return data;
}