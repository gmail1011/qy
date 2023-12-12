import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class EntryVideoEntity with JsonConvert<EntryVideoEntity> {
	int code;
	EntryVideoData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class EntryVideoData with JsonConvert<EntryVideoData> {
	String activityId;
	String activityBackgroundImage;
	String activityEndTime;
	String activityDesc;
	List<EntryVideoDataWorkList> workList;
	bool hasNext;
}

class EntryVideoDataWorkList with JsonConvert<EntryVideoDataWorkList> {
	String id;
	String newsType;
	String title;
	List<EntryVideoDataWorkListTags> tags;
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
	EntryVideoDataWorkListPublisher publisher;
	EntryVideoDataWorkListLocation location;
	EntryVideoDataWorkListVidStatus vidStatus;
	EntryVideoDataWorkListComment comment;
	EntryVideoDataWorkListWatch watch;
}

class EntryVideoDataWorkListTags with JsonConvert<EntryVideoDataWorkListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class EntryVideoDataWorkListPublisher with JsonConvert<EntryVideoDataWorkListPublisher> {
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

class EntryVideoDataWorkListLocation with JsonConvert<EntryVideoDataWorkListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class EntryVideoDataWorkListVidStatus with JsonConvert<EntryVideoDataWorkListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class EntryVideoDataWorkListComment with JsonConvert<EntryVideoDataWorkListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class EntryVideoDataWorkListWatch with JsonConvert<EntryVideoDataWorkListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
