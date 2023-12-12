import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class TaskDetailEntity with JsonConvert<TaskDetailEntity> {
	int code;
	TaskDetailData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class TaskDetailData with JsonConvert<TaskDetailData> {
	List<TaskDetailDataTaskList> taskList;
	int value;
}

class TaskDetailDataTaskList with JsonConvert<TaskDetailDataTaskList> {
	String id;
	String title;
	String desc;
	List<TaskDetailDataTaskListPrizes> prizes;
	int finishCondition;
	int finishValue;
	int status;
	int boonType;
}

class TaskDetailDataTaskListPrizes with JsonConvert<TaskDetailDataTaskListPrizes> {
	String id;
	String name;
	int type;
	int value;
	int count;
	String desc;
	bool status;
	int validityTime;
	String updateTime;
	String createTimt;
}
