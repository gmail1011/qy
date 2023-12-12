import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';

searchTopicEntityFromJson(SearchTopicEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = SearchTopicData().fromJson(json['data']);
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

Map<String, dynamic> searchTopicEntityToJson(SearchTopicEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

searchTopicDataFromJson(SearchTopicData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => SearchTopicDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> searchTopicDataToJson(SearchTopicData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

searchTopicDataListFromJson(SearchTopicDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['coverImg'] != null) {
		data.coverImg = json['coverImg'].toString();
	}
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	if (json['playCount'] != null) {
		data.playCount = json['playCount'] is String
				? int.tryParse(json['playCount'])
				: json['playCount'].toInt();
	}
	if (json['hasCollected'] != null) {
		data.hasCollected = json['hasCollected'];
	}
	if (json['isSelected'] != null) {
		data.isSelected = json['isSelected'];
	}
	return data;
}

Map<String, dynamic> searchTopicDataListToJson(SearchTopicDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['coverImg'] = entity.coverImg;
	data['description'] = entity.description;
	data['playCount'] = entity.playCount;
	data['hasCollected'] = entity.hasCollected;
	data['isSelected'] = entity.isSelected;
	return data;
}