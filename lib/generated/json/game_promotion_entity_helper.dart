import 'package:flutter_app/model/game_promotion_entity.dart';

gamePromotionEntityFromJson(GamePromotionEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = GamePromotionData().fromJson(json['data']);
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

Map<String, dynamic> gamePromotionEntityToJson(GamePromotionEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

gamePromotionDataFromJson(GamePromotionData data, Map<String, dynamic> json) {
	if (json['totalInvites'] != null) {
		data.totalInvites = json['totalInvites'] is String
				? int.tryParse(json['totalInvites'])
				: json['totalInvites'].toInt();
	}
	if (json['todayInvites'] != null) {
		data.todayInvites = json['todayInvites'] is String
				? int.tryParse(json['todayInvites'])
				: json['todayInvites'].toInt();
	}
	if (json['totalInviteAmount'] != null) {
		data.totalInviteAmount = json['totalInviteAmount'] is String
				? int.tryParse(json['totalInviteAmount'])
				: json['totalInviteAmount'].toInt();
	}
	if (json['yesterdaylInviteAmount'] != null) {
		data.yesterdaylInviteAmount = json['yesterdaylInviteAmount'] is String
				? int.tryParse(json['yesterdaylInviteAmount'])
				: json['yesterdaylInviteAmount'].toInt();
	}
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => GamePromotionDataList().fromJson(v)).toList();
	}
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	return data;
}

Map<String, dynamic> gamePromotionDataToJson(GamePromotionData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['totalInvites'] = entity.totalInvites;
	data['todayInvites'] = entity.todayInvites;
	data['totalInviteAmount'] = entity.totalInviteAmount;
	data['yesterdaylInviteAmount'] = entity.yesterdaylInviteAmount;
	data['total'] = entity.total;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['hasNext'] = entity.hasNext;
	return data;
}

gamePromotionDataListFromJson(GamePromotionDataList data, Map<String, dynamic> json) {
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['incomeAmount'] != null) {
		data.incomeAmount = json['incomeAmount'] is String
				? int.tryParse(json['incomeAmount'])
				: json['incomeAmount'].toInt();
	}
	if (json['setDate'] != null) {
		data.setDate = json['setDate'].toString();
	}
	return data;
}

Map<String, dynamic> gamePromotionDataListToJson(GamePromotionDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['desc'] = entity.desc;
	data['incomeAmount'] = entity.incomeAmount;
	data['setDate'] = entity.setDate;
	return data;
}