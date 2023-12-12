import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class HotRecommendEntity with JsonConvert<HotRecommendEntity> {
	int code;
	HotRecommendData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class HotRecommendData with JsonConvert<HotRecommendData> {
	@JSONField(name: "list")
	List<HotRecommendDataList> xList;
}

class HotRecommendDataList with JsonConvert<HotRecommendDataList> {
	String id;
	String newsType;
	String title;
	List<HotRecommendDataListTags> tags;
	String sourceURL;
	int playTime;
	String cover;
	String coverThumb;
	List<String> seriesCover;
	int playCount;
	int purchaseCount;
	int likeCount;
	int commentCount;
	int shareCount;
	int forwardCount;
	int coins;
	int size;
	String resolution;
	double ratio;
	int status;
	String reason;
	int freeTime;
	bool isHideLocation;
	bool freeArea;
	String createdAt;
	String reviewAt;
	bool isTopping;
	bool isRecommend;
	bool isChoosen;
	String rewarded;
	int originCoins;
	HotRecommendDataListPublisher publisher;
	HotRecommendDataListLocation location;
	HotRecommendDataListVidStatus vidStatus;
	HotRecommendDataListComment comment;
	HotRecommendDataListWatch watch;
	bool isForWard;
	int forWardUser;
	String forWardUserName;
}

class HotRecommendDataListTags with JsonConvert<HotRecommendDataListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class HotRecommendDataListPublisher with JsonConvert<HotRecommendDataListPublisher> {
	int uid;
	String name;
	String gender;
	String portrait;
	bool hasLocked;
	bool hasBanned;
	int vipLevel;
	bool isVip;
	int rechargeLevel;
	bool superUser;
	int activeValue;
	bool officialCert;
	int age;
	int follows;
	int fans;
	bool hasFollowed;
}

class HotRecommendDataListLocation with JsonConvert<HotRecommendDataListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class HotRecommendDataListVidStatus with JsonConvert<HotRecommendDataListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class HotRecommendDataListComment with JsonConvert<HotRecommendDataListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class HotRecommendDataListWatch with JsonConvert<HotRecommendDataListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
