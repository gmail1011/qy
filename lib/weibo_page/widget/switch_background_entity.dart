import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SwitchBackgroundEntity with JsonConvert<SwitchBackgroundEntity> {
	int code;
	SwitchBackgroundData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SwitchBackgroundData with JsonConvert<SwitchBackgroundData> {
	@JSONField(name: "list")
	List<SwitchBackgroundDataList> xList;
	int total;
}

class SwitchBackgroundDataList with JsonConvert<SwitchBackgroundDataList> {
	String id;
	String resource;
	String type;
	String updatedAt;
}
