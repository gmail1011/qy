import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class RewardAvatarEntity with JsonConvert<RewardAvatarEntity> {
	int code;
	RewardAvatarData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class RewardAvatarData with JsonConvert<RewardAvatarData> {
	int total;
	bool hasNext;
	@JSONField(name: "list")
	List<RewardAvatarDataList> xList;
}

class RewardAvatarDataList with JsonConvert<RewardAvatarDataList> {
	int uid;
	String uPortrait;
	String uName;
	String msg;
	String title;
	String videoID;
	String videoCover;
	int reward;
	int tax;
	double publisherIncome;
	String createdAt;
}
