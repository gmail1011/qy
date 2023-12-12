import 'package:flutter_app/model/user/task_center_entity.dart';

taskCenterDataFromJson(TaskCenterData data, Map<String, dynamic> json) {
	if (json['taskList'] != null) {
		data.taskList = (json['taskList'] as List).map((v) => TaskCenterDataTaskList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> taskCenterDataToJson(TaskCenterData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['taskList'] =  entity.taskList?.map((v) => v.toJson())?.toList();
	return data;
}

taskCenterDataTaskListFromJson(TaskCenterDataTaskList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['userAward'] != null) {
		data.userAward = (json['userAward'] as List).map((v) => v is String
				? int.tryParse(v)
				: v.toInt()).toList().cast<int>();
	}
	if (json['finishCondition'] != null) {
		data.finishCondition = json['finishCondition'] is String
				? int.tryParse(json['finishCondition'])
				: json['finishCondition'].toInt();
	}
	if (json['finishValue'] != null) {
		data.finishValue = json['finishValue'] is String
				? int.tryParse(json['finishValue'])
				: json['finishValue'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['boonType'] != null) {
		data.boonType = json['boonType'] is String
				? int.tryParse(json['boonType'])
				: json['boonType'].toInt();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	return data;
}

Map<String, dynamic> taskCenterDataTaskListToJson(TaskCenterDataTaskList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['userAward'] = entity.userAward;
	data['finishCondition'] = entity.finishCondition;
	data['finishValue'] = entity.finishValue;
	data['status'] = entity.status;
	data['boonType'] = entity.boonType;
	data['image'] = entity.image;
	return data;
}