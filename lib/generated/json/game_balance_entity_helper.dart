import 'package:flutter_app/page/game_page/bean/game_balance_entity.dart';

gameBalanceEntityFromJson(GameBalanceEntity data, Map<String, dynamic> json) {
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

Map<String, dynamic> gameBalanceEntityToJson(GameBalanceEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['wlBalance'] = entity.wlBalance;
	data['wlTransferable'] = entity.wlTransferable;
	data['balance'] = entity.balance;
	return data;
}