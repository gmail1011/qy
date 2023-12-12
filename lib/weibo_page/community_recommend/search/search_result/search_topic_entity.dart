import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SearchTopicEntity with JsonConvert<SearchTopicEntity> {
	int code;
	SearchTopicData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SearchTopicData with JsonConvert<SearchTopicData> {
	bool hasNext;
	@JSONField(name: "list")
	List<SearchTopicDataList> xList;
}

class SearchTopicDataList with JsonConvert<SearchTopicDataList> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;

	bool isSelected = false;
}
