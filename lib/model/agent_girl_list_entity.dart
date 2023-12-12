import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class AgentGirlListEntity with JsonConvert<AgentGirlListEntity> {
	int code;
	AgentGirlListData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class AgentGirlListData with JsonConvert<AgentGirlListData> {
	@JSONField(name: "list")
	List<AgentGirlListDataList> xList;
	bool hasNext;
}

class AgentGirlListDataList with JsonConvert<AgentGirlListDataList> {
	String id;
	String title;
	int number;
	String quantity;
	String age;
	String price;
	List<String> cover;
	dynamic videos;
	dynamic coverImages;
	String businessHours;
	String serviceItems;
	String city;
	String district;
	String contact;
	int contactPrice;
	String impression;
	int envStar;
	int prettyStar;
	int serviceStar;
	bool isBought;
	bool isBooked;
	String bookTime;
	String businessDate;
	@JSONField(name: "BroughtTime")
	String broughtTime;
	bool isVerify;
	bool isCollect;
	int countPurchases;
	int countBrowse;
	int countCollect;
	int countBook;
	String loufengType;
	String topStartTime;
	String topEndTime;
	int contactPriceDiscountRate;
	int originalBookPrice;
	int bookPrice;
	String publisher;
	AgentGirlListDataListAgentInfo agentInfo;
}

class AgentGirlListDataListAgentInfo with JsonConvert<AgentGirlListDataListAgentInfo> {
	String id;
	String account;
	int status;
	String name;
	String avatar;
	bool payable;
	int deposit;
	String introduce;
	bool following;
	String createdAt;
	String updatedAt;
}
