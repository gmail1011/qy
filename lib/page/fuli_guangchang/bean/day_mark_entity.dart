import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class DayMarkEntity with JsonConvert<DayMarkEntity> {
	int code;
	DayMarkData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class DayMarkData with JsonConvert<DayMarkData> {
	@JSONField(name: "list")
	List<DayMarkDataList> xList;
	int value;
}

class DayMarkDataList with JsonConvert<DayMarkDataList> {
	String id;
	String title;
	String desc;
	List<DayMarkDataListPrizes> prizes;
	int finishCondition;
	int finishValue;
	int status;
}

class DayMarkDataListPrizes with JsonConvert<DayMarkDataListPrizes> {
	String id;
	String name;
	int type;
	int value;
	int count;
	bool status;
	int validityTime;
	String updateTime;
	String createTimt;
}
