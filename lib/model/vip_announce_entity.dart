import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class VipAnnounceEntity with JsonConvert<VipAnnounceEntity> {
	int code;
	List<VipAnnounceData> data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class VipAnnounceData with JsonConvert<VipAnnounceData> {
	String id;
	String content;
	String url;
	bool active;
	String createdAt;
	String updatedAt;
}
