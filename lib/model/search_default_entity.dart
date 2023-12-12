import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SearchDefaultEntity with JsonConvert<SearchDefaultEntity> {
	int code;
	SearchDefaultData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SearchDefaultData with JsonConvert<SearchDefaultData> {
	@JSONField(name: "list")
	List<SearchDefaultDataList> xList;
}

class SearchDefaultDataList with JsonConvert<SearchDefaultDataList> {
	String id;
	String newsType;
	String title;
	List<SearchDefaultDataListTags> tags;
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
	SearchDefaultDataListPublisher publisher;
	SearchDefaultDataListLocation location;
	SearchDefaultDataListVidStatus vidStatus;
	SearchDefaultDataListComment comment;
	SearchDefaultDataListWatch watch;
	String linkUrl;
}

class SearchDefaultDataListTags with JsonConvert<SearchDefaultDataListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class SearchDefaultDataListPublisher with JsonConvert<SearchDefaultDataListPublisher> {
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
	String summary;
	bool hasFollowed;
}

class SearchDefaultDataListLocation with JsonConvert<SearchDefaultDataListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class SearchDefaultDataListVidStatus with JsonConvert<SearchDefaultDataListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class SearchDefaultDataListComment with JsonConvert<SearchDefaultDataListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class SearchDefaultDataListWatch with JsonConvert<SearchDefaultDataListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
