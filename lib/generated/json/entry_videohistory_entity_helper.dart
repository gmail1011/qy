import 'package:flutter_app/model/entry_videohistory_entity.dart';

entryVideohistoryEntityFromJson(EntryVideohistoryEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = EntryVideohistoryData().fromJson(json['data']);
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

Map<String, dynamic> entryVideohistoryEntityToJson(EntryVideohistoryEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

entryVideohistoryDataFromJson(EntryVideohistoryData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['activityList'] != null) {
		data.activityList = (json['activityList'] as List).map((v) => EntryVideohistoryDataActivityList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> entryVideohistoryDataToJson(EntryVideohistoryData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['activityList'] =  entity.activityList?.map((v) => v.toJson())?.toList();
	return data;
}

entryVideohistoryDataActivityListFromJson(EntryVideohistoryDataActivityList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['backgroundImage'] != null) {
		data.backgroundImage = json['backgroundImage'].toString();
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['createTime'] != null) {
		data.createTime = json['createTime'].toString();
	}
	return data;
}

Map<String, dynamic> entryVideohistoryDataActivityListToJson(EntryVideohistoryDataActivityList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['backgroundImage'] = entity.backgroundImage;
	data['endTime'] = entity.endTime;
	data['desc'] = entity.desc;
	data['status'] = entity.status;
	data['createTime'] = entity.createTime;
	return data;
}