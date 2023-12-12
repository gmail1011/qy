import 'package:flutter_app/weibo_page/message/message_detail/message_detail_entity.dart';

messageDetailEntityFromJson(MessageDetailEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = MessageDetailData().fromJson(json['data']);
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

Map<String, dynamic> messageDetailEntityToJson(MessageDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

messageDetailDataFromJson(MessageDetailData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => MessageDetailDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> messageDetailDataToJson(MessageDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

messageDetailDataListFromJson(MessageDetailDataList data, Map<String, dynamic> json) {
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
	if (json['takeUid'] != null) {
		data.takeUid = json['takeUid'] is String
				? int.tryParse(json['takeUid'])
				: json['takeUid'].toInt();
	}
	if (json['takeName'] != null) {
		data.takeName = json['takeName'].toString();
	}
	if (json['takeAvatar'] != null) {
		data.takeAvatar = json['takeAvatar'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['isRead'] != null) {
		data.isRead = json['isRead'];
	}
	if (json['sessionId'] != null) {
		data.sessionId = json['sessionId'].toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> messageDetailDataListToJson(MessageDetailDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['sendUid'] = entity.sendUid;
	data['sendName'] = entity.sendName;
	data['sendAvatar'] = entity.sendAvatar;
	data['takeUid'] = entity.takeUid;
	data['takeName'] = entity.takeName;
	data['takeAvatar'] = entity.takeAvatar;
	data['content'] = entity.content;
	data['isRead'] = entity.isRead;
	data['sessionId'] = entity.sessionId;
	data['createdAt'] = entity.createdAt;
	return data;
}