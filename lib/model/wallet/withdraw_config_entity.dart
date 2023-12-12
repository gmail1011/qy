import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class WithdrawConfigData with JsonConvert<WithdrawConfigData> {
  List<WithdrawConfigDataChannels> channels;
  @JSONField(name: "ID")
  int iD;
  int cashTax;
  int coinTax;
  int gameTax;
}

class WithdrawConfigDataChannels with JsonConvert<WithdrawConfigDataChannels> {
  String channelName;
  String cid;
  String payType;
  int minMoney;
  int maxMoney;
  int qpMinMoney;
  int qpMaxMoney;
}
