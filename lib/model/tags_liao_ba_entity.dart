import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class TagsLiaoBaEntity with JsonConvert<TagsLiaoBaEntity> {
	int code;
	TagsLiaoBaData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class TagsLiaoBaData with JsonConvert<TagsLiaoBaData> {
	List<TagsLiaoBaDataTags> tags;
}

class TagsLiaoBaDataTags with JsonConvert<TagsLiaoBaDataTags> {
	String id;
	String tagName;
}
