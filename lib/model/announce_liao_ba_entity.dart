import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class AnnounceLiaoBaEntity with JsonConvert<AnnounceLiaoBaEntity> {
	int code;
	AnnounceLiaoBaData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class AnnounceLiaoBaData with JsonConvert<AnnounceLiaoBaData> {
	List<AnnouncementData> announcement;
}

class AnnouncementData with JsonConvert<AnnouncementData> {
	String id;
	String content;
	int position;
	String positionDesc;
	String createdAt;
}
