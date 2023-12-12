import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_entity.dart';

aVCommentaryEntityFromJson(AVCommentaryEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = AVCommentaryData().fromJson(json['data']);
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

Map<String, dynamic> aVCommentaryEntityToJson(AVCommentaryEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

aVCommentaryDataFromJson(AVCommentaryData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => AVCommentaryDataList().fromJson(v)).toList();
	}
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	return data;
}

Map<String, dynamic> aVCommentaryDataToJson(AVCommentaryData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['total'] = entity.total;
	return data;
}

aVCommentaryDataListFromJson(AVCommentaryDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['videoInfo'] != null) {
		data.videoInfo = json['videoInfo'].toString();
	}
	if (json['period'] != null) {
		data.period = json['period'] is String
				? int.tryParse(json['period'])
				: json['period'].toInt();
	}
	if (json['cover'] != null) {
		data.cover = json['cover'].toString();
	}
	if (json['sourceID'] != null) {
		data.sourceID = json['sourceID'].toString();
	}
	if (json['sourceURL'] != null) {
		data.sourceURL = json['sourceURL'].toString();
	}
	if (json['price'] != null) {
		data.price = json['price'] is String
				? int.tryParse(json['price'])
				: json['price'].toInt();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['graphic'] != null) {
		data.graphic = json['graphic'].toString();
	}
	if (json['tags'] != null) {
		data.tags = (json['tags'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	return data;
}

Map<String, dynamic> aVCommentaryDataListToJson(AVCommentaryDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['videoInfo'] = entity.videoInfo;
	data['period'] = entity.period;
	data['cover'] = entity.cover;
	data['sourceID'] = entity.sourceID;
	data['sourceURL'] = entity.sourceURL;
	data['price'] = entity.price;
	data['createdAt'] = entity.createdAt;
	data['graphic'] = entity.graphic;
	data['tags'] = entity.tags;
	return data;
}