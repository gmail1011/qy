import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class NakeChatBillDetailEntity with JsonConvert<NakeChatBillDetailEntity> {
	int code;
	NakeChatBillDetailData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class NakeChatBillDetailData with JsonConvert<NakeChatBillDetailData> {
	@JSONField(name: "list")
	List<NakeChatBillDetailDataList> xList;
}

class NakeChatBillDetailDataList with JsonConvert<NakeChatBillDetailDataList> {
	String id;
	int uid;
	String purchaseOrder;
	String productID;
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
	String wlRealAmount;
	int fruitCoin;
	int fruitCoinBalance;
	String districtCode;
	String promSeqe;
	bool isDirect;
	@JSONField(name: "DiscBindAt")
	String discBindAt;
}
