import 'package:flutter_app/weibo_page/message/message_list_entity.dart';

messageListEntityFromJson(MessageListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = MessageListData().fromJson(json['data']);
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

Map<String, dynamic> messageListEntityToJson(MessageListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

messageListDataFromJson(MessageListData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['total'] != null) {
		data.total = json['total'];
	}
	if (json['unread'] != null) {
		data.unread = json['unread'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => MessageListDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> messageListDataToJson(MessageListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

messageListDataListFromJson(MessageListDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['sendUid'] != null) {
		data.sendUid = json['sendUid'] is String
				? int.tryParse(json['sendUid'])
				: json['sendUid'].toInt();
	}
	if (json['takeUid'] != null) {
		data.takeUid = json['takeUid'] is String
				? int.tryParse(json['takeUid'])
				: json['takeUid'].toInt();
	}
	if (json['userId'] != null) {
		data.userId = json['userId'] is String
				? int.tryParse(json['userId'])
				: json['userId'].toInt();
	}
	if (json['userName'] != null) {
		data.userName = json['userName'].toString();
	}
	if (json['userAvatar'] != null) {
		data.userAvatar = json['userAvatar'].toString();
	}
	if (json['sessionId'] != null) {
		data.sessionId = json['sessionId'].toString();
	}
	if (json['noReadNum'] != null) {
		data.noReadNum = json['noReadNum'] is String
				? int.tryParse(json['noReadNum'])
				: json['noReadNum'].toInt();
	}
	if (json['preContent'] != null) {
		data.preContent = json['preContent'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'];
	}
	if (json['title'] != null) {
		data.title = json['title'];
	}
	if (json['contentType'] != null) {
		data.contentType = json['contentType'];
	}
	if (json['isRead'] != null) {
		data.isRead = json['isRead'];
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> messageListDataListToJson(MessageListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['sendUid'] = entity.sendUid;
	data['takeUid'] = entity.takeUid;
	data['userId'] = entity.userId;
	data['userName'] = entity.userName;
	data['userAvatar'] = entity.userAvatar;
	data['sessionId'] = entity.sessionId;
	data['noReadNum'] = entity.noReadNum;
	data['preContent'] = entity.preContent;
	data['createdAt'] = entity.createdAt;
	return data;
}