import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class TabsTagEntity with JsonConvert<TabsTagEntity> {
	int code;
	List<TabsTagData> data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class TabsTagData with JsonConvert<TabsTagData> {
	String id;
	String moduleName;
	String subModuleName;
	int status;
	int sectionLimit;
	String createdAt;
	String updatedAt;
	dynamic deletedAt;
}
