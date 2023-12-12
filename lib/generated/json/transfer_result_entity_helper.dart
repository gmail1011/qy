import 'package:flutter_app/page/game_page/bean/transfer_result_entity.dart';

transferResultEntityFromJson(TransferResultEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = TransferResultData().fromJson(json['data']);
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

Map<String, dynamic> transferResultEntityToJson(TransferResultEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

transferResultDataFromJson(TransferResultData data, Map<String, dynamic> json) {
	if (json['wlBalance'] != null) {
		data.wlBalance = json['wlBalance'] is String
				? int.tryParse(json['wlBalance'])
				: json['wlBalance'].toInt();
	}
	if (json['wlTransferable'] != null) {
		data.wlTransferable = json['wlTransferable'] is String
				? int.tryParse(json['wlTransferable'])
				: json['wlTransferable'].toInt();
	}
	if (json['balance'] != null) {
		data.balance = json['balance'] is String
				? int.tryParse(json['balance'])
				: json['balance'].toInt();
	}
	return data;
}

Map<String, dynamic> transferResultDataToJson(TransferResultData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['wlBalance'] = entity.wlBalance;
	data['wlTransferable'] = entity.wlTransferable;
	data['balance'] = entity.balance;
	return data;
}