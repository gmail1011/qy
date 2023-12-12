import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class LiaoBaHistoryEntity with JsonConvert<LiaoBaHistoryEntity> {
	int code;
	LiaoBaHistoryData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class LiaoBaHistoryData with JsonConvert<LiaoBaHistoryData> {
	List<LiaoBaHistoryDataWorkList> workList;
	bool hasNext;
}

class LiaoBaHistoryDataWorkList with JsonConvert<LiaoBaHistoryDataWorkList> {
	String id;
	String newsType;
	String title;
	List<LiaoBaHistoryDataWorkListTags> tags;
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
	LiaoBaHistoryDataWorkListPublisher publisher;
	LiaoBaHistoryDataWorkListLocation location;
	LiaoBaHistoryDataWorkListVidStatus vidStatus;
	LiaoBaHistoryDataWorkListComment comment;
	LiaoBaHistoryDataWorkListWatch watch;
}

class LiaoBaHistoryDataWorkListTags with JsonConvert<LiaoBaHistoryDataWorkListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class LiaoBaHistoryDataWorkListPublisher with JsonConvert<LiaoBaHistoryDataWorkListPublisher> {
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

class LiaoBaHistoryDataWorkListLocation with JsonConvert<LiaoBaHistoryDataWorkListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class LiaoBaHistoryDataWorkListVidStatus with JsonConvert<LiaoBaHistoryDataWorkListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class LiaoBaHistoryDataWorkListComment with JsonConvert<LiaoBaHistoryDataWorkListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class LiaoBaHistoryDataWorkListWatch with JsonConvert<LiaoBaHistoryDataWorkListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
