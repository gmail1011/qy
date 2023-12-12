import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SearchVideoEntity with JsonConvert<SearchVideoEntity> {
	int code;
	SearchVideoData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SearchVideoData with JsonConvert<SearchVideoData> {
	@JSONField(name: "list")
	List<SearchVideoDataList> xList;
	bool hasNext;
}

class SearchVideoDataList with JsonConvert<SearchVideoDataList> {
	String id;
	String newsType;
	String title;
	List<SearchVideoDataListTags> tags;
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
	SearchVideoDataListPublisher publisher;
	SearchVideoDataListLocation location;
	SearchVideoDataListVidStatus vidStatus;
	SearchVideoDataListComment comment;
	SearchVideoDataListWatch watch;
	bool isForWard;
	int forWardUser;
	String forWardUserName;
}

class SearchVideoDataListTags with JsonConvert<SearchVideoDataListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class SearchVideoDataListPublisher with JsonConvert<SearchVideoDataListPublisher> {
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
	List<int> awards = [];
}

class SearchVideoDataListLocation with JsonConvert<SearchVideoDataListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class SearchVideoDataListVidStatus with JsonConvert<SearchVideoDataListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class SearchVideoDataListComment with JsonConvert<SearchVideoDataListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class SearchVideoDataListWatch with JsonConvert<SearchVideoDataListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
