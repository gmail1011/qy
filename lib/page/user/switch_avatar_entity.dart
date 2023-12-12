import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SwitchAvatarEntity with JsonConvert<SwitchAvatarEntity> {
	int code;
	SwitchAvatarData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SwitchAvatarData with JsonConvert<SwitchAvatarData> {
	@JSONField(name: "list")
	List<SwitchAvatarDataList> xList;
	int total;
}

class SwitchAvatarDataList with JsonConvert<SwitchAvatarDataList> {
	String id;
	String resource;
	String type;
	String updatedAt;
}
