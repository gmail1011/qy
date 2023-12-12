import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class PublishDetailEntity with JsonConvert<PublishDetailEntity> {
	int code;
	PublishDetailData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class PublishDetailData with JsonConvert<PublishDetailData> {
	bool isFirst;
	int workTotal;
	int pendingReviewWorkCount;
	int passWorkCount;
	int workCreateCount;
	int noPassCount;


	///免费作品数
	int freeTotalCount;
	///付费作品数
	int notFreeTotalCount;

	PublishDetailDataActivityDetails activityDetails;
	List<PublishDetailDataLeaderboards> leaderboards;
}

class PublishDetailDataActivityDetails with JsonConvert<PublishDetailDataActivityDetails> {
	String id;
	String backgroundImage;
	String endTime;
	String desc;
}

class PublishDetailDataLeaderboards with JsonConvert<PublishDetailDataLeaderboards> {
	int type;
	List<PublishDetailDataLeaderboardsMembers> members;
}

class PublishDetailDataLeaderboardsMembers with JsonConvert<PublishDetailDataLeaderboardsMembers> {
	String name;
	String avatar;
	String value;
	int id;
}
