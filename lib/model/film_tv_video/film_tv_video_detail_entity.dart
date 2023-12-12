import 'package:flutter_app/generated/json/base/json_convert_content.dart';

class FilmTvVideoDetailEntity with JsonConvert<FilmTvVideoDetailEntity> {
	String id;
	String newsType;
	String title;
	List<FilmTvVideoDetailTags> tags;
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
	FilmTvVideoDetailPublisher publisher;
	FilmTvVideoDetailLocation location;
	FilmTvVideoDetailVidStatus vidStatus;
	FilmTvVideoDetailComment comment;
	FilmTvVideoDetailWatch watch;
	bool isForWard;
	int forWardUser;
	String forWardUserName;
}

class FilmTvVideoDetailTags with JsonConvert<FilmTvVideoDetailTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class FilmTvVideoDetailPublisher with JsonConvert<FilmTvVideoDetailPublisher> {
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

class FilmTvVideoDetailLocation with JsonConvert<FilmTvVideoDetailLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class FilmTvVideoDetailVidStatus with JsonConvert<FilmTvVideoDetailVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class FilmTvVideoDetailComment with JsonConvert<FilmTvVideoDetailComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class FilmTvVideoDetailWatch with JsonConvert<FilmTvVideoDetailWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
