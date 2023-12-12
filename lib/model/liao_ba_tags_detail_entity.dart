import 'package:flutter_app/generated/json/base/json_convert_content.dart';

import 'ads_model.dart';

class LiaoBaTagsDetailEntity with JsonConvert<LiaoBaTagsDetailEntity> {
	int code;
	LiaoBaTagsDetailData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class LiaoBaTagsDetailData with JsonConvert<LiaoBaTagsDetailData> {
	List<LiaoBaTagsDetailDataVideos> videos;
	bool hasNext;
	LiaoBaTagsDetailDataOriginalBloggerInfo originalBloggerInfo;
	bool hasFollowed;
}

class LiaoBaTagsDetailDataVideos with JsonConvert<LiaoBaTagsDetailDataVideos> {

	AdsInfoBean randomAdsInfo;
	bool get isRandomAd => randomAdsInfo != null;

	String id;
	String newsType;
	String title;
	List<LiaoBaTagsDetailDataVideosTags> tags;
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
	LiaoBaTagsDetailDataVideosPublisher publisher;
	LiaoBaTagsDetailDataVideosLocation location;
	LiaoBaTagsDetailDataVideosVidStatus vidStatus;
	LiaoBaTagsDetailDataVideosComment comment;
	LiaoBaTagsDetailDataVideosWatch watch;
}

class LiaoBaTagsDetailDataVideosTags with JsonConvert<LiaoBaTagsDetailDataVideosTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class LiaoBaTagsDetailDataVideosPublisher with JsonConvert<LiaoBaTagsDetailDataVideosPublisher> {
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

class LiaoBaTagsDetailDataVideosLocation with JsonConvert<LiaoBaTagsDetailDataVideosLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class LiaoBaTagsDetailDataVideosVidStatus with JsonConvert<LiaoBaTagsDetailDataVideosVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class LiaoBaTagsDetailDataVideosComment with JsonConvert<LiaoBaTagsDetailDataVideosComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class LiaoBaTagsDetailDataVideosWatch with JsonConvert<LiaoBaTagsDetailDataVideosWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}

class LiaoBaTagsDetailDataOriginalBloggerInfo with JsonConvert<LiaoBaTagsDetailDataOriginalBloggerInfo> {
	int uid;
	String name;
	String portrait;
	bool officialCert;
	String summary;
}
