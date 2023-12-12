import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class DynamicEntity with JsonConvert<DynamicEntity> {
	int code;
	DynamicData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class DynamicData with JsonConvert<DynamicData> {
	bool hasNext;
	@JSONField(name: "list")
	List<DynamicDataList> xList;
}

class DynamicDataList with JsonConvert<DynamicDataList> {
	String id;
	int sendUid;
	String sendName;
	String sendAvatar;
	String sendGender;
	String msgType;
	String content;
	bool isRead;
	String objId;
	String objName;
	String createdAt;
}
