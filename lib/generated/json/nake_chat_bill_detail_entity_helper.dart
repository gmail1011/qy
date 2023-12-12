import 'package:flutter_app/page/wallet/pay_for_nake_chat/model/nake_chat_bill_detail_entity.dart';

nakeChatBillDetailEntityFromJson(NakeChatBillDetailEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = NakeChatBillDetailData().fromJson(json['data']);
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

Map<String, dynamic> nakeChatBillDetailEntityToJson(NakeChatBillDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

nakeChatBillDetailDataFromJson(NakeChatBillDetailData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => NakeChatBillDetailDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> nakeChatBillDetailDataToJson(NakeChatBillDetailData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

nakeChatBillDetailDataListFromJson(NakeChatBillDetailDataList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['purchaseOrder'] != null) {
		data.purchaseOrder = json['purchaseOrder'].toString();
	}
	if (json['productID'] != null) {
		data.productID = json['productID'].toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount'] is String
				? int.tryParse(json['amount'])
				: json['amount'].toInt();
	}
	if (json['actualAmount'] != null) {
		data.actualAmount = json['actualAmount'] is String
				? int.tryParse(json['actualAmount'])
				: json['actualAmount'].toInt();
	}
	if (json['tax'] != null) {
		data.tax = json['tax'] is String
				? int.tryParse(json['tax'])
				: json['tax'].toInt();
	}
	if (json['taxAmount'] != null) {
		data.taxAmount = json['taxAmount'] is String
				? int.tryParse(json['taxAmount'])
				: json['taxAmount'].toInt();
	}
	if (json['channelType'] != null) {
		data.channelType = json['channelType'].toString();
	}
	if (json['tranType'] != null) {
		data.tranType = json['tranType'].toString();
	}
	if (json['tranTypeInt'] != null) {
		data.tranTypeInt = json['tranTypeInt'] is String
				? int.tryParse(json['tranTypeInt'])
				: json['tranTypeInt'].toInt();
	}
	if (json['performance'] != null) {
		data.performance = json['performance'] is String
				? int.tryParse(json['performance'])
				: json['performance'].toInt();
	}
	if (json['rechargeId'] != null) {
		data.rechargeId = json['rechargeId'] is String
				? int.tryParse(json['rechargeId'])
				: json['rechargeId'].toInt();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['sysType'] != null) {
		data.sysType = json['sysType'].toString();
	}
	if (json['agentLevel'] != null) {
		data.agentLevel = json['agentLevel'] is String
				? int.tryParse(json['agentLevel'])
				: json['agentLevel'].toInt();
	}
	if (json['vipLevel'] != null) {
		data.vipLevel = json['vipLevel'] is String
				? int.tryParse(json['vipLevel'])
				: json['vipLevel'].toInt();
	}
	if (json['realAmount'] != null) {
		data.realAmount = json['realAmount'].toString();
	}
	if (json['money'] != null) {
		data.money = json['money'].toString();
	}
	if (json['wlRealAmount'] != null) {
		data.wlRealAmount = json['wlRealAmount'].toString();
	}
	if (json['fruitCoin'] != null) {
		data.fruitCoin = json['fruitCoin'] is String
				? int.tryParse(json['fruitCoin'])
				: json['fruitCoin'].toInt();
	}
	if (json['fruitCoinBalance'] != null) {
		data.fruitCoinBalance = json['fruitCoinBalance'] is String
				? int.tryParse(json['fruitCoinBalance'])
				: json['fruitCoinBalance'].toInt();
	}
	if (json['districtCode'] != null) {
		data.districtCode = json['districtCode'].toString();
	}
	if (json['promSeqe'] != null) {
		data.promSeqe = json['promSeqe'].toString();
	}
	if (json['isDirect'] != null) {
		data.isDirect = json['isDirect'];
	}
	if (json['DiscBindAt'] != null) {
		data.discBindAt = json['DiscBindAt'].toString();
	}
	return data;
}

Map<String, dynamic> nakeChatBillDetailDataListToJson(NakeChatBillDetailDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['uid'] = entity.uid;
	data['purchaseOrder'] = entity.purchaseOrder;
	data['productID'] = entity.productID;
	data['amount'] = entity.amount;
	data['actualAmount'] = entity.actualAmount;
	data['tax'] = entity.tax;
	data['taxAmount'] = entity.taxAmount;
	data['channelType'] = entity.channelType;
	data['tranType'] = entity.tranType;
	data['tranTypeInt'] = entity.tranTypeInt;
	data['performance'] = entity.performance;
	data['rechargeId'] = entity.rechargeId;
	data['desc'] = entity.desc;
	data['createdAt'] = entity.createdAt;
	data['sysType'] = entity.sysType;
	data['agentLevel'] = entity.agentLevel;
	data['vipLevel'] = entity.vipLevel;
	data['realAmount'] = entity.realAmount;
	data['money'] = entity.money;
	data['wlRealAmount'] = entity.wlRealAmount;
	data['fruitCoin'] = entity.fruitCoin;
	data['fruitCoinBalance'] = entity.fruitCoinBalance;
	data['districtCode'] = entity.districtCode;
	data['promSeqe'] = entity.promSeqe;
	data['isDirect'] = entity.isDirect;
	data['DiscBindAt'] = entity.discBindAt;
	return data;
}