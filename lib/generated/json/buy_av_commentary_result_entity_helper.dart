import 'package:flutter_app/page/home/AVCommentary/bean/buy_av_commentary_result_entity.dart';

buyAvCommentaryResultEntityFromJson(BuyAvCommentaryResultEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = json['data'].toString();
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

Map<String, dynamic> buyAvCommentaryResultEntityToJson(BuyAvCommentaryResultEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data;
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}