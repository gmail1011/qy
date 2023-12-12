import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';

taskEntityFromJson(TaskEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = TaskData().fromJson(json['data']);
	}
	if (json['hash'] != null) {
		data.hash = json['hash'];
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['time'] != null) {
		data.time = json['time'].toString();
	}
	if (json['tip'] != null) {
		data.tip = json['tip'].toString();
	}
	return data;
}

Map<String, dynamic> taskEntityToJson(TaskEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

taskDataFromJson(TaskData data, Map<String, dynamic> json) {
	if (json['jewelBoxDetails'] != null) {
		data.jewelBoxDetails = TaskDataJewelBoxDetails().fromJson(json['jewelBoxDetails']);
	}
	if (json['taskList'] != null) {
		data.taskList = (json['taskList'] as List).map((v) => TaskDataTaskList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> taskDataToJson(TaskData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['jewelBoxDetails'] = entity.jewelBoxDetails?.toJson();
	data['taskList'] =  entity.taskList?.map((v) => v.toJson())?.toList();
	return data;
}

taskDataJewelBoxDetailsFromJson(TaskDataJewelBoxDetails data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => TaskDataJewelBoxDetailsList().fromJson(v)).toList();
	}
	if (json['value'] != null) {
		data.value = json['value'] is String
				? int.tryParse(json['value'])
				: json['value'].toInt();
	}
	if (json['totalValue'] != null) {
		data.totalValue = json['totalValue'] is String
				? int.tryParse(json['totalValue'])
				: json['totalValue'].toInt();
	}
	return data;
}

Map<String, dynamic> taskDataJewelBoxDetailsToJson(TaskDataJewelBoxDetails entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['value'] = entity.value;
	data['totalValue'] = entity.totalValue;
	return data;
}

taskDataJewelBoxDetailsListFromJson(TaskDataJewelBoxDetailsList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['prizes'] != null) {
		data.prizes = (json['prizes'] as List).map((v) => TaskDataJewelBoxDetailsListPrizes().fromJson(v)).toList();
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
	return data;
}

Map<String, dynamic> taskDataJewelBoxDetailsListToJson(TaskDataJewelBoxDetailsList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['prizes'] =  entity.prizes?.map((v) => v.toJson())?.toList();
	data['finishCondition'] = entity.finishCondition;
	data['finishValue'] = entity.finishValue;
	data['status'] = entity.status;
	data['boonType'] = entity.boonType;
	return data;
}

taskDataJewelBoxDetailsListPrizesFromJson(TaskDataJewelBoxDetailsListPrizes data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['value'] != null) {
		data.value = json['value'] is String
				? int.tryParse(json['value'])
				: json['value'].toInt();
	}
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'];
	}
	if (json['validityTime'] != null) {
		data.validityTime = json['validityTime'] is String
				? int.tryParse(json['validityTime'])
				: json['validityTime'].toInt();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime'].toString();
	}
	if (json['createTimt'] != null) {
		data.createTimt = json['createTimt'].toString();
	}
	return data;
}

Map<String, dynamic> taskDataJewelBoxDetailsListPrizesToJson(TaskDataJewelBoxDetailsListPrizes entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['type'] = entity.type;
	data['value'] = entity.value;
	data['count'] = entity.count;
	data['desc'] = entity.desc;
	data['status'] = entity.status;
	data['validityTime'] = entity.validityTime;
	data['updateTime'] = entity.updateTime;
	data['createTimt'] = entity.createTimt;
	return data;
}

taskDataTaskListFromJson(TaskDataTaskList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['prizes'] != null) {
		data.prizes = (json['prizes'] as List).map((v) => TaskDataTaskListPrizes().fromJson(v)).toList();
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
	return data;
}

Map<String, dynamic> taskDataTaskListToJson(TaskDataTaskList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['prizes'] =  entity.prizes?.map((v) => v.toJson())?.toList();
	data['finishCondition'] = entity.finishCondition;
	data['finishValue'] = entity.finishValue;
	data['status'] = entity.status;
	data['boonType'] = entity.boonType;
	return data;
}

taskDataTaskListPrizesFromJson(TaskDataTaskListPrizes data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['value'] != null) {
		data.value = json['value'] is String
				? int.tryParse(json['value'])
				: json['value'].toInt();
	}
	if (json['count'] != null) {
		data.count = json['count'] is String
				? int.tryParse(json['count'])
				: json['count'].toInt();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'];
	}
	if (json['validityTime'] != null) {
		data.validityTime = json['validityTime'] is String
				? int.tryParse(json['validityTime'])
				: json['validityTime'].toInt();
	}
	if (json['updateTime'] != null) {
		data.updateTime = json['updateTime'].toString();
	}
	if (json['createTimt'] != null) {
		data.createTimt = json['createTimt'].toString();
	}
	return data;
}

Map<String, dynamic> taskDataTaskListPrizesToJson(TaskDataTaskListPrizes entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['type'] = entity.type;
	data['value'] = entity.value;
	data['count'] = entity.count;
	data['desc'] = entity.desc;
	data['status'] = entity.status;
	data['validityTime'] = entity.validityTime;
	data['updateTime'] = entity.updateTime;
	data['createTimt'] = entity.createTimt;
	return data;
}