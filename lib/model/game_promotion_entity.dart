import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class GamePromotionEntity with JsonConvert<GamePromotionEntity> {
	int code;
	GamePromotionData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class GamePromotionData with JsonConvert<GamePromotionData> {
	int totalInvites;
	int todayInvites;
	int totalInviteAmount;
	int yesterdaylInviteAmount;
	int total;
	@JSONField(name: "list")
	List<GamePromotionDataList> xList;
	bool hasNext;
}

class GamePromotionDataList with JsonConvert<GamePromotionDataList> {
	String desc;
	int incomeAmount;
	String setDate;
}
