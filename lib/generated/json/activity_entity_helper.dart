import 'package:flutter_app/weibo_page/message/activity_entity.dart';

activityEntityFromJson(ActivityEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = ActivityData().fromJson(json['data']);
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

Map<String, dynamic> activityEntityToJson(ActivityEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

activityDataFromJson(ActivityData data, Map<String, dynamic> json) {
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => ActivityDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> activityDataToJson(ActivityData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['total'] = entity.total;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

activityDataListFromJson(ActivityDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['cover'] != null) {
		data.cover = json['cover'].toString();
	}
	if (json['href'] != null) {
		data.href = json['href'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['time'] != null) {
		data.time = json['time'].toString();
	}
	return data;
}

Map<String, dynamic> activityDataListToJson(ActivityDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['cover'] = entity.cover;
	data['href'] = entity.href;
	data['type'] = entity.type;
	data['time'] = entity.time;
	return data;
}