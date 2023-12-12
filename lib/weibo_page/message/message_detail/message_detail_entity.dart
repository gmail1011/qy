import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class MessageDetailEntity with JsonConvert<MessageDetailEntity> {
	int code;
	MessageDetailData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class MessageDetailData with JsonConvert<MessageDetailData> {
	bool hasNext;
	@JSONField(name: "list")
	List<MessageDetailDataList> xList;
}

class MessageDetailDataList with JsonConvert<MessageDetailDataList> {
	String id;
	int sendUid;
	String sendName;
	String sendAvatar;
	int takeUid;
	String takeName;
	String takeAvatar;
	String content;
	bool isRead;
	String sessionId;
	String createdAt;
}
