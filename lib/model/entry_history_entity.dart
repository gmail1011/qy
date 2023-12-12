import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class EntryHistoryEntity with JsonConvert<EntryHistoryEntity> {
	int code;
	EntryHistoryData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class EntryHistoryData with JsonConvert<EntryHistoryData> {
	bool hasNext;
	List<EntryHistoryDataActivityList> activityList;
}

class EntryHistoryDataActivityList with JsonConvert<EntryHistoryDataActivityList> {
	String id;
	String backgroundImage;
	String endTime;
	String desc;
	int status;
	String createTime;
}
