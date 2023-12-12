import 'package:flutter_app/model/tags_liao_ba_entity.dart';

tagsLiaoBaEntityFromJson(TagsLiaoBaEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = TagsLiaoBaData().fromJson(json['data']);
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

Map<String, dynamic> tagsLiaoBaEntityToJson(TagsLiaoBaEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

tagsLiaoBaDataFromJson(TagsLiaoBaData data, Map<String, dynamic> json) {
	if (json['tags'] != null) {
		data.tags = (json['tags'] as List).map((v) => TagsLiaoBaDataTags().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> tagsLiaoBaDataToJson(TagsLiaoBaData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['tags'] =  entity.tags?.map((v) => v.toJson())?.toList();
	return data;
}

tagsLiaoBaDataTagsFromJson(TagsLiaoBaDataTags data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['tagName'] != null) {
		data.tagName = json['tagName'].toString();
	}
	return data;
}

Map<String, dynamic> tagsLiaoBaDataTagsToJson(TagsLiaoBaDataTags entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['tagName'] = entity.tagName;
	return data;
}