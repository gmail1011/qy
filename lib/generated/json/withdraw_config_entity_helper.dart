import 'package:flutter_app/model/wallet/withdraw_config_entity.dart';

withdrawConfigDataFromJson(WithdrawConfigData data, Map<String, dynamic> json) {
  if (json['channels'] != null) {
    data.channels = (json['channels'] as List)
        .map((v) => WithdrawConfigDataChannels().fromJson(v))
        .toList();
  }
  if (json['ID'] != null) {
    data.iD =
        json['ID'] is String ? int.tryParse(json['ID']) : json['ID'].toInt();
  }
  if (json['cashTax'] != null) {
    data.cashTax = json['cashTax'] is String
        ? int.tryParse(json['cashTax'])
        : json['cashTax'].toInt();
  }
  if (json['coinTax'] != null) {
    data.coinTax = json['coinTax'] is String
        ? int.tryParse(json['coinTax'])
        : json['coinTax'].toInt();
  }
  if (json['gameTax'] != null) {
    data.gameTax = json['gameTax'] is String
        ? int.tryParse(json['gameTax'])
        : json['gameTax'].toInt();
  }
  return data;
}

Map<String, dynamic> withdrawConfigDataToJson(WithdrawConfigData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['channels'] = entity.channels?.map((v) => v.toJson())?.toList();
  data['ID'] = entity.iD;
  data['cashTax'] = entity.cashTax;
  data['coinTax'] = entity.coinTax;
  data['gameTax'] = entity.gameTax;
  return data;
}

withdrawConfigDataChannelsFromJson(
    WithdrawConfigDataChannels data, Map<String, dynamic> json) {
  if (json['channelName'] != null) {
    data.channelName = json['channelName'].toString();
  }
  if (json['cid'] != null) {
    data.cid = json['cid'].toString();
  }
  if (json['payType'] != null) {
    data.payType = json['payType'].toString();
  }
  if (json['minMoney'] != null) {
    data.minMoney = json['minMoney'] is String
        ? int.tryParse(json['minMoney'])
        : json['minMoney'].toInt();
  }
  if (json['maxMoney'] != null) {
    data.maxMoney = json['maxMoney'] is String
        ? int.tryParse(json['maxMoney'])
        : json['maxMoney'].toInt();
  }
  if (json['qpMinMoney'] != null) {
    data.maxMoney = json['qpMinMoney'] is String
        ? int.tryParse(json['qpMinMoney'])
        : json['qpMinMoney'].toInt();
  }
  if (json['qpMaxMoney'] != null) {
    data.maxMoney = json['qpMaxMoney'] is String
        ? int.tryParse(json['qpMaxMoney'])
        : json['qpMaxMoney'].toInt();
  }
  return data;
}

Map<String, dynamic> withdrawConfigDataChannelsToJson(
    WithdrawConfigDataChannels entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['channelName'] = entity.channelName;
  data['cid'] = entity.cid;
  data['payType'] = entity.payType;
  data['minMoney'] = entity.minMoney;
  data['maxMoney'] = entity.maxMoney;
  data['qpMinMoney'] = entity.qpMinMoney;
  data['qpMaxMoney'] = entity.qpMaxMoney;
  return data;
}
