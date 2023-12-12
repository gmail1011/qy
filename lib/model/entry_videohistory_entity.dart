import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class EntryVideohistoryEntity with JsonConvert<EntryVideohistoryEntity> {
	int code;
	EntryVideohistoryData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class EntryVideohistoryData with JsonConvert<EntryVideohistoryData> {
	bool hasNext;
	List<EntryVideohistoryDataActivityList> activityList;
}

class EntryVideohistoryDataActivityList with JsonConvert<EntryVideohistoryDataActivityList> {
	String id;
	String backgroundImage;
	String endTime;
	String desc;
	int status;
	String createTime;
}
