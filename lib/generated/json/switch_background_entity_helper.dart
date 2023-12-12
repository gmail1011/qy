import 'package:flutter_app/weibo_page/widget/switch_background_entity.dart';

switchBackgroundEntityFromJson(SwitchBackgroundEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = SwitchBackgroundData().fromJson(json['data']);
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

Map<String, dynamic> switchBackgroundEntityToJson(SwitchBackgroundEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

switchBackgroundDataFromJson(SwitchBackgroundData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => SwitchBackgroundDataList().fromJson(v)).toList();
	}
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	return data;
}

Map<String, dynamic> switchBackgroundDataToJson(SwitchBackgroundData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['total'] = entity.total;
	return data;
}

switchBackgroundDataListFromJson(SwitchBackgroundDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['resource'] != null) {
		data.resource = json['resource'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt'].toString();
	}
	return data;
}

Map<String, dynamic> switchBackgroundDataListToJson(SwitchBackgroundDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['resource'] = entity.resource;
	data['type'] = entity.type;
	data['updatedAt'] = entity.updatedAt;
	return data;
}