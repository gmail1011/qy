import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class MessageListEntity with JsonConvert<MessageListEntity> {
	int code;
	MessageListData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class MessageListData with JsonConvert<MessageListData> {
	bool hasNext;
	@JSONField(name: "list")
	List<MessageListDataList> xList;
	int total;
	int unread;
}

class MessageListDataList with JsonConvert<MessageListDataList> {
	String id;
	int sendUid;
	int takeUid;
	int userId;
	String userName;
	String userAvatar;
	String sessionId;
	int noReadNum;
	String preContent;
	String createdAt;
	String content;
	String title;
	int contentType;
	bool isRead;
}
