import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SearchDefaultHotBloggerEntity with JsonConvert<SearchDefaultHotBloggerEntity> {
	int code;
	SearchDefaultHotBloggerData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SearchDefaultHotBloggerData with JsonConvert<SearchDefaultHotBloggerData> {
	@JSONField(name: "list")
	List<SearchDefaultHotBloggerDataList> xList;
}

class SearchDefaultHotBloggerDataList with JsonConvert<SearchDefaultHotBloggerDataList> {
	int uid;
	String name;
	String gender;
	String portrait;
	bool hasLocked;
	bool hasBanned;
	@JSONField(name: "list")
	List<SearchDefaultHotBloggerDataListList> xList;
}

class SearchDefaultHotBloggerDataListList with JsonConvert<SearchDefaultHotBloggerDataListList> {
	String id;
	String newsType;
	String title;
	List<SearchDefaultHotBloggerDataListListTags> tags;
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
	SearchDefaultHotBloggerDataListListPublisher publisher;
	SearchDefaultHotBloggerDataListListLocation location;
	SearchDefaultHotBloggerDataListListVidStatus vidStatus;
	SearchDefaultHotBloggerDataListListComment comment;
	SearchDefaultHotBloggerDataListListWatch watch;
}

class SearchDefaultHotBloggerDataListListTags with JsonConvert<SearchDefaultHotBloggerDataListListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class SearchDefaultHotBloggerDataListListPublisher with JsonConvert<SearchDefaultHotBloggerDataListListPublisher> {
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

class SearchDefaultHotBloggerDataListListLocation with JsonConvert<SearchDefaultHotBloggerDataListListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class SearchDefaultHotBloggerDataListListVidStatus with JsonConvert<SearchDefaultHotBloggerDataListListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class SearchDefaultHotBloggerDataListListComment with JsonConvert<SearchDefaultHotBloggerDataListListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class SearchDefaultHotBloggerDataListListWatch with JsonConvert<SearchDefaultHotBloggerDataListListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
