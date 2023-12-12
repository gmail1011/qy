import 'package:flutter_app/model/tabs_tag_entity.dart';

tabsTagEntityFromJson(TabsTagEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => TabsTagData().fromJson(v)).toList();
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

Map<String, dynamic> tabsTagEntityToJson(TabsTagEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] =  entity.data?.map((v) => v.toJson())?.toList();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

tabsTagDataFromJson(TabsTagData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['moduleName'] != null) {
		data.moduleName = json['moduleName'].toString();
	}
	if (json['subModuleName'] != null) {
		data.subModuleName = json['subModuleName'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['sectionLimit'] != null) {
		data.sectionLimit = json['sectionLimit'] is String
				? int.tryParse(json['sectionLimit'])
				: json['sectionLimit'].toInt();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt'].toString();
	}
	if (json['deletedAt'] != null) {
		data.deletedAt = json['deletedAt'];
	}
	return data;
}

Map<String, dynamic> tabsTagDataToJson(TabsTagData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['moduleName'] = entity.moduleName;
	data['subModuleName'] = entity.subModuleName;
	data['status'] = entity.status;
	data['sectionLimit'] = entity.sectionLimit;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['deletedAt'] = entity.deletedAt;
	return data;
}