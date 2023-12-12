import 'package:flutter_app/model/publish_detail_entity.dart';

publishDetailEntityFromJson(PublishDetailEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = PublishDetailData().fromJson(json['data']);
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

Map<String, dynamic> publishDetailEntityToJson(PublishDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

publishDetailDataFromJson(PublishDetailData data, Map<String, dynamic> json) {
	if (json['isFirst'] != null) {
		data.isFirst = json['isFirst'];
	}
	if (json['workTotal'] != null) {
		data.workTotal = json['workTotal'] is String
				? int.tryParse(json['workTotal'])
				: json['workTotal'].toInt();
	}
	if (json['pendingReviewWorkCount'] != null) {
		data.pendingReviewWorkCount = json['pendingReviewWorkCount'] is String
				? int.tryParse(json['pendingReviewWorkCount'])
				: json['pendingReviewWorkCount'].toInt();
	}
	if (json['passWorkCount'] != null) {
		data.passWorkCount = json['passWorkCount'] is String
				? int.tryParse(json['passWorkCount'])
				: json['passWorkCount'].toInt();
	}
	if (json['workCreateCount'] != null) {
		data.workCreateCount = json['workCreateCount'] is String
				? int.tryParse(json['workCreateCount'])
				: json['workCreateCount'].toInt();
	}
	if (json['noPassCount'] != null) {
		data.noPassCount = json['noPassCount'] is String
				? int.tryParse(json['noPassCount'])
				: json['noPassCount'].toInt();
	}
	if (json['activityDetails'] != null) {
		data.activityDetails = PublishDetailDataActivityDetails().fromJson(json['activityDetails']);
	}
	if (json['leaderboards'] != null) {
		data.leaderboards = (json['leaderboards'] as List).map((v) => PublishDetailDataLeaderboards().fromJson(v)).toList();
	}








	if (json['freeTotalCount'] != null) {
		data.freeTotalCount = json['freeTotalCount'] is String
				? int.tryParse(json['freeTotalCount'])
				: json['freeTotalCount'].toInt();
	}


	if (json['notFreeTotalCount'] != null) {
		data.notFreeTotalCount = json['notFreeTotalCount'] is String
				? int.tryParse(json['notFreeTotalCount'])
				: json['notFreeTotalCount'].toInt();
	}








	return data;
}

Map<String, dynamic> publishDetailDataToJson(PublishDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['isFirst'] = entity.isFirst;
	data['workTotal'] = entity.workTotal;
	data['pendingReviewWorkCount'] = entity.pendingReviewWorkCount;
	data['passWorkCount'] = entity.passWorkCount;
	data['workCreateCount'] = entity.workCreateCount;
	data['noPassCount'] = entity.noPassCount;
	data['activityDetails'] = entity.activityDetails?.toJson();
	data['leaderboards'] =  entity.leaderboards?.map((v) => v.toJson())?.toList();


	data['freeTotalCount'] = entity.freeTotalCount;
	data['notFreeTotalCount'] = entity.notFreeTotalCount;

	return data;
}

publishDetailDataActivityDetailsFromJson(PublishDetailDataActivityDetails data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['backgroundImage'] != null) {
		data.backgroundImage = json['backgroundImage'].toString();
	}
	if (json['endTime'] != null) {
		data.endTime = json['endTime'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	return data;
}

Map<String, dynamic> publishDetailDataActivityDetailsToJson(PublishDetailDataActivityDetails entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['backgroundImage'] = entity.backgroundImage;
	data['endTime'] = entity.endTime;
	data['desc'] = entity.desc;
	return data;
}

publishDetailDataLeaderboardsFromJson(PublishDetailDataLeaderboards data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['members'] != null) {
		data.members = (json['members'] as List).map((v) => PublishDetailDataLeaderboardsMembers().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> publishDetailDataLeaderboardsToJson(PublishDetailDataLeaderboards entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['members'] =  entity.members?.map((v) => v.toJson())?.toList();
	return data;
}

publishDetailDataLeaderboardsMembersFromJson(PublishDetailDataLeaderboardsMembers data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['value'] != null) {
		data.value = json['value'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	return data;
}

Map<String, dynamic> publishDetailDataLeaderboardsMembersToJson(PublishDetailDataLeaderboardsMembers entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['avatar'] = entity.avatar;
	data['value'] = entity.value;
	data['id'] = entity.id;
	return data;
}