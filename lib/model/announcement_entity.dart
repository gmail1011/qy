import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class AnnouncementEntity with JsonConvert<AnnouncementEntity> {
	String id;
	int type;
	int location;
	String content;
	bool isActive;
	String createdAt;
	String updatedAt;
}
