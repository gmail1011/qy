import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class GameBillDetailEntity with JsonConvert<GameBillDetailEntity> {
	int code;
	GameBillDetailData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class GameBillDetailData with JsonConvert<GameBillDetailData> {
	@JSONField(name: "list")
	List<GameBillDetailDataList> xList;
}

class GameBillDetailDataList with JsonConvert<GameBillDetailDataList> {
	String id;
	int uid;
	String purchaseOrder;
	dynamic productID;
	int amount;
	int actualAmount;
	int tax;
	int taxAmount;
	String channelType;
	String tranType;
	int tranTypeInt;
	int performance;
	int rechargeId;
	String desc;
	String createdAt;
	String sysType;
	int agentLevel;
	int vipLevel;
	String realAmount;
	String money;
	String districtCode;
	String promSeqe;
	bool isDirect;
	@JSONField(name: "DiscBindAt")
	String discBindAt;
}
