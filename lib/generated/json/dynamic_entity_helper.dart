import 'package:flutter_app/weibo_page/message/dynamic_entity.dart';

dynamicEntityFromJson(DynamicEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = DynamicData().fromJson(json['data']);
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

Map<String, dynamic> dynamicEntityToJson(DynamicEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

dynamicDataFromJson(DynamicData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => DynamicDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> dynamicDataToJson(DynamicData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

dynamicDataListFromJson(DynamicDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['sendUid'] != null) {
		data.sendUid = json['sendUid'] is String
				? int.tryParse(json['sendUid'])
				: json['sendUid'].toInt();
	}
	if (json['sendName'] != null) {
		data.sendName = json['sendName'].toString();
	}
	if (json['sendAvatar'] != null) {
		data.sendAvatar = json['sendAvatar'].toString();
	}
	if (json['sendGender'] != null) {
		data.sendGender = json['sendGender'].toString();
	}
	if (json['msgType'] != null) {
		data.msgType = json['msgType'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['isRead'] != null) {
		data.isRead = json['isRead'];
	}
	if (json['objId'] != null) {
		data.objId = json['objId'].toString();
	}
	if (json['objName'] != null) {
		data.objName = json['objName'].toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> dynamicDataListToJson(DynamicDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['sendUid'] = entity.sendUid;
	data['sendName'] = entity.sendName;
	data['sendAvatar'] = entity.sendAvatar;
	data['sendGender'] = entity.sendGender;
	data['msgType'] = entity.msgType;
	data['content'] = entity.content;
	data['isRead'] = entity.isRead;
	data['objId'] = entity.objId;
	data['objName'] = entity.objName;
	data['createdAt'] = entity.createdAt;
	return data;
}