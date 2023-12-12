import 'package:flutter_app/weibo_page/widget/reward_avatar_entity.dart';

rewardAvatarEntityFromJson(RewardAvatarEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = RewardAvatarData().fromJson(json['data']);
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

Map<String, dynamic> rewardAvatarEntityToJson(RewardAvatarEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

rewardAvatarDataFromJson(RewardAvatarData data, Map<String, dynamic> json) {
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => RewardAvatarDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> rewardAvatarDataToJson(RewardAvatarData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['total'] = entity.total;
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

rewardAvatarDataListFromJson(RewardAvatarDataList data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['uPortrait'] != null) {
		data.uPortrait = json['uPortrait'].toString();
	}
	if (json['uName'] != null) {
		data.uName = json['uName'].toString();
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['videoID'] != null) {
		data.videoID = json['videoID'].toString();
	}
	if (json['videoCover'] != null) {
		data.videoCover = json['videoCover'].toString();
	}
	if (json['reward'] != null) {
		data.reward = json['reward'] is String
				? int.tryParse(json['reward'])
				: json['reward'].toInt();
	}
	if (json['tax'] != null) {
		data.tax = json['tax'] is String
				? int.tryParse(json['tax'])
				: json['tax'].toInt();
	}
	if (json['publisherIncome'] != null) {
		data.publisherIncome = json['publisherIncome'] is String
				? double.tryParse(json['publisherIncome'])
				: json['publisherIncome'].toDouble();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> rewardAvatarDataListToJson(RewardAvatarDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['uPortrait'] = entity.uPortrait;
	data['uName'] = entity.uName;
	data['msg'] = entity.msg;
	data['title'] = entity.title;
	data['videoID'] = entity.videoID;
	data['videoCover'] = entity.videoCover;
	data['reward'] = entity.reward;
	data['tax'] = entity.tax;
	data['publisherIncome'] = entity.publisherIncome;
	data['createdAt'] = entity.createdAt;
	return data;
}