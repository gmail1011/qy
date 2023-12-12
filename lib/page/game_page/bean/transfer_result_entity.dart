import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class TransferResultEntity with JsonConvert<TransferResultEntity> {
	int code;
	TransferResultData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class TransferResultData with JsonConvert<TransferResultData> {
	int wlBalance;
	int wlTransferable;
	int balance;
}
