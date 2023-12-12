import 'package:flutter_app/page/setting/you_hui_juan/you_hui_juan_entity.dart';

youHuiJuanEntityFromJson(YouHuiJuanEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => YouHuiJuanData().fromJson(v)).toList();
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

Map<String, dynamic> youHuiJuanEntityToJson(YouHuiJuanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] =  entity.data?.map((v) => v.toJson())?.toList();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

youHuiJuanDataFromJson(YouHuiJuanData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['goodsName'] != null) {
		data.goodsName = json['goodsName'].toString();
	}
	if (json['goodsType'] != null) {
		data.goodsType = json['goodsType'] is String
				? int.tryParse(json['goodsType'])
				: json['goodsType'].toInt();
	}
	if (json['goodsValue'] != null) {
		data.goodsValue = json['goodsValue'] is String
				? int.tryParse(json['goodsValue'])
				: json['goodsValue'].toInt();
	}
	if (json['goodsOrigin'] != null) {
		data.goodsOrigin = json['goodsOrigin'].toString();
	}
	if (json['goodsDesc'] != null) {
		data.goodsDesc = json['goodsDesc'].toString();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['expiredTime'] != null) {
		data.expiredTime = json['expiredTime'].toString();
	}
	if (json['useTime'] != null) {
		data.useTime = json['useTime'].toString();
	}
	if (json['createTimt'] != null) {
		data.createTimt = json['createTimt'].toString();
	}
	return data;
}

Map<String, dynamic> youHuiJuanDataToJson(YouHuiJuanData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['uid'] = entity.uid;
	data['goodsName'] = entity.goodsName;
	data['goodsType'] = entity.goodsType;
	data['goodsValue'] = entity.goodsValue;
	data['goodsOrigin'] = entity.goodsOrigin;
	data['goodsDesc'] = entity.goodsDesc;
	data['status'] = entity.status;
	data['expiredTime'] = entity.expiredTime;
	data['useTime'] = entity.useTime;
	data['createTimt'] = entity.createTimt;
	return data;
}