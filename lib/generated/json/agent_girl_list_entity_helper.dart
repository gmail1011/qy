import 'package:flutter_app/model/agent_girl_list_entity.dart';

agentGirlListEntityFromJson(AgentGirlListEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = AgentGirlListData().fromJson(json['data']);
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

Map<String, dynamic> agentGirlListEntityToJson(AgentGirlListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

agentGirlListDataFromJson(AgentGirlListData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => AgentGirlListDataList().fromJson(v)).toList();
	}
	if (json['hasNext'] != null) {
		data.hasNext = json['hasNext'];
	}
	return data;
}

Map<String, dynamic> agentGirlListDataToJson(AgentGirlListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	data['hasNext'] = entity.hasNext;
	return data;
}

agentGirlListDataListFromJson(AgentGirlListDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['number'] != null) {
		data.number = json['number'] is String
				? int.tryParse(json['number'])
				: json['number'].toInt();
	}
	if (json['quantity'] != null) {
		data.quantity = json['quantity'].toString();
	}
	if (json['age'] != null) {
		data.age = json['age'].toString();
	}
	if (json['price'] != null) {
		data.price = json['price'].toString();
	}
	if (json['cover'] != null) {
		data.cover = (json['cover'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	if (json['videos'] != null) {
		data.videos = json['videos'];
	}
	if (json['coverImages'] != null) {
		data.coverImages = json['coverImages'];
	}
	if (json['businessHours'] != null) {
		data.businessHours = json['businessHours'].toString();
	}
	if (json['serviceItems'] != null) {
		data.serviceItems = json['serviceItems'].toString();
	}
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['district'] != null) {
		data.district = json['district'].toString();
	}
	if (json['contact'] != null) {
		data.contact = json['contact'].toString();
	}
	if (json['contactPrice'] != null) {
		data.contactPrice = json['contactPrice'] is String
				? int.tryParse(json['contactPrice'])
				: json['contactPrice'].toInt();
	}
	if (json['impression'] != null) {
		data.impression = json['impression'].toString();
	}
	if (json['envStar'] != null) {
		data.envStar = json['envStar'] is String
				? int.tryParse(json['envStar'])
				: json['envStar'].toInt();
	}
	if (json['prettyStar'] != null) {
		data.prettyStar = json['prettyStar'] is String
				? int.tryParse(json['prettyStar'])
				: json['prettyStar'].toInt();
	}
	if (json['serviceStar'] != null) {
		data.serviceStar = json['serviceStar'] is String
				? int.tryParse(json['serviceStar'])
				: json['serviceStar'].toInt();
	}
	if (json['isBought'] != null) {
		data.isBought = json['isBought'];
	}
	if (json['isBooked'] != null) {
		data.isBooked = json['isBooked'];
	}
	if (json['bookTime'] != null) {
		data.bookTime = json['bookTime'].toString();
	}
	if (json['businessDate'] != null) {
		data.businessDate = json['businessDate'].toString();
	}
	if (json['BroughtTime'] != null) {
		data.broughtTime = json['BroughtTime'].toString();
	}
	if (json['isVerify'] != null) {
		data.isVerify = json['isVerify'];
	}
	if (json['isCollect'] != null) {
		data.isCollect = json['isCollect'];
	}
	if (json['countPurchases'] != null) {
		data.countPurchases = json['countPurchases'] is String
				? int.tryParse(json['countPurchases'])
				: json['countPurchases'].toInt();
	}
	if (json['countBrowse'] != null) {
		data.countBrowse = json['countBrowse'] is String
				? int.tryParse(json['countBrowse'])
				: json['countBrowse'].toInt();
	}
	if (json['countCollect'] != null) {
		data.countCollect = json['countCollect'] is String
				? int.tryParse(json['countCollect'])
				: json['countCollect'].toInt();
	}
	if (json['countBook'] != null) {
		data.countBook = json['countBook'] is String
				? int.tryParse(json['countBook'])
				: json['countBook'].toInt();
	}
	if (json['loufengType'] != null) {
		data.loufengType = json['loufengType'].toString();
	}
	if (json['topStartTime'] != null) {
		data.topStartTime = json['topStartTime'].toString();
	}
	if (json['topEndTime'] != null) {
		data.topEndTime = json['topEndTime'].toString();
	}
	if (json['contactPriceDiscountRate'] != null) {
		data.contactPriceDiscountRate = json['contactPriceDiscountRate'] is String
				? int.tryParse(json['contactPriceDiscountRate'])
				: json['contactPriceDiscountRate'].toInt();
	}
	if (json['originalBookPrice'] != null) {
		data.originalBookPrice = json['originalBookPrice'] is String
				? int.tryParse(json['originalBookPrice'])
				: json['originalBookPrice'].toInt();
	}
	if (json['bookPrice'] != null) {
		data.bookPrice = json['bookPrice'] is String
				? int.tryParse(json['bookPrice'])
				: json['bookPrice'].toInt();
	}
	if (json['publisher'] != null) {
		data.publisher = json['publisher'].toString();
	}
	if (json['agentInfo'] != null) {
		data.agentInfo = AgentGirlListDataListAgentInfo().fromJson(json['agentInfo']);
	}
	return data;
}

Map<String, dynamic> agentGirlListDataListToJson(AgentGirlListDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['number'] = entity.number;
	data['quantity'] = entity.quantity;
	data['age'] = entity.age;
	data['price'] = entity.price;
	data['cover'] = entity.cover;
	data['videos'] = entity.videos;
	data['coverImages'] = entity.coverImages;
	data['businessHours'] = entity.businessHours;
	data['serviceItems'] = entity.serviceItems;
	data['city'] = entity.city;
	data['district'] = entity.district;
	data['contact'] = entity.contact;
	data['contactPrice'] = entity.contactPrice;
	data['impression'] = entity.impression;
	data['envStar'] = entity.envStar;
	data['prettyStar'] = entity.prettyStar;
	data['serviceStar'] = entity.serviceStar;
	data['isBought'] = entity.isBought;
	data['isBooked'] = entity.isBooked;
	data['bookTime'] = entity.bookTime;
	data['businessDate'] = entity.businessDate;
	data['BroughtTime'] = entity.broughtTime;
	data['isVerify'] = entity.isVerify;
	data['isCollect'] = entity.isCollect;
	data['countPurchases'] = entity.countPurchases;
	data['countBrowse'] = entity.countBrowse;
	data['countCollect'] = entity.countCollect;
	data['countBook'] = entity.countBook;
	data['loufengType'] = entity.loufengType;
	data['topStartTime'] = entity.topStartTime;
	data['topEndTime'] = entity.topEndTime;
	data['contactPriceDiscountRate'] = entity.contactPriceDiscountRate;
	data['originalBookPrice'] = entity.originalBookPrice;
	data['bookPrice'] = entity.bookPrice;
	data['publisher'] = entity.publisher;
	data['agentInfo'] = entity.agentInfo?.toJson();
	return data;
}

agentGirlListDataListAgentInfoFromJson(AgentGirlListDataListAgentInfo data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['account'] != null) {
		data.account = json['account'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['payable'] != null) {
		data.payable = json['payable'];
	}
	if (json['deposit'] != null) {
		data.deposit = json['deposit'] is String
				? int.tryParse(json['deposit'])
				: json['deposit'].toInt();
	}
	if (json['introduce'] != null) {
		data.introduce = json['introduce'].toString();
	}
	if (json['following'] != null) {
		data.following = json['following'];
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt'].toString();
	}
	return data;
}

Map<String, dynamic> agentGirlListDataListAgentInfoToJson(AgentGirlListDataListAgentInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['account'] = entity.account;
	data['status'] = entity.status;
	data['name'] = entity.name;
	data['avatar'] = entity.avatar;
	data['payable'] = entity.payable;
	data['deposit'] = entity.deposit;
	data['introduce'] = entity.introduce;
	data['following'] = entity.following;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}