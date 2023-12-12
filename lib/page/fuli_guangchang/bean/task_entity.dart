import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class TaskEntity with JsonConvert<TaskEntity> {
	int code;
	TaskData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class TaskData with JsonConvert<TaskData> {
	TaskDataJewelBoxDetails jewelBoxDetails;
	List<TaskDataTaskList> taskList;
}

class TaskDataJewelBoxDetails with JsonConvert<TaskDataJewelBoxDetails> {
	@JSONField(name: "list")
	List<TaskDataJewelBoxDetailsList> xList;
	int value;
	int totalValue;
}

class TaskDataJewelBoxDetailsList with JsonConvert<TaskDataJewelBoxDetailsList> {
	String id;
	String title;
	String desc;
	List<TaskDataJewelBoxDetailsListPrizes> prizes;
	int finishCondition;
	int finishValue;
	int status;
	int boonType;
}

class TaskDataJewelBoxDetailsListPrizes with JsonConvert<TaskDataJewelBoxDetailsListPrizes> {
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

class TaskDataTaskList with JsonConvert<TaskDataTaskList> {
	String id;
	String title;
	String desc;
	List<TaskDataTaskListPrizes> prizes;
	int finishCondition;
	int finishValue;
	int status;
	int boonType;
}

class TaskDataTaskListPrizes with JsonConvert<TaskDataTaskListPrizes> {
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
