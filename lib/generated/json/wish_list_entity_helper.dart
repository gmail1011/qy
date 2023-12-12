import 'package:flutter_app/model/user/wish_list_entity.dart';

wishListDataFromJson(WishListData data, Map<String, dynamic> json) {
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => WishListDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> wishListDataToJson(WishListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasNext'] = entity.hasNext;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

wishListDataListFromJson(WishListDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['question'] != null) {
		data.question = json['question'].toString();
	}
	if (json['images'] != null) {
		data.images = (json['images'] as List).map((v) => v).toList().cast<dynamic>();
	}
	if (json['bountyGold'] != null) {
		data.bountyGold = json['bountyGold'] is String
				? int.tryParse(json['bountyGold'])
				: json['bountyGold'].toInt();
	}
	if (json['lookCount'] != null) {
		data.lookCount = json['lookCount'] is String
				? int.tryParse(json['lookCount'])
				: json['lookCount'].toInt();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['isAdoption'] != null) {
		data.isAdoption = json['isAdoption'];
	}
	if (json['adoptionCmtId'] != null) {
		data.adoptionCmtId = json['adoptionCmtId'].toString();
	}
	return data;
}

Map<String, dynamic> wishListDataListToJson(WishListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['uid'] = entity.uid;
	data['question'] = entity.question;
	data['images'] = entity.images;
	data['bountyGold'] = entity.bountyGold;
	data['lookCount'] = entity.lookCount;
	data['createdAt'] = entity.createdAt;
	data['isAdoption'] = entity.isAdoption;
	data['adoptionCmtId'] = entity.adoptionCmtId;
	return data;
}