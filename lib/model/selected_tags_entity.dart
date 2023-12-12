import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class SelectedTagsEntity with JsonConvert<SelectedTagsEntity> {
	int code;
	SelectedTagsData data;
	bool hash;
	String msg;
	String time;
	String tip;
}

class SelectedTagsData with JsonConvert<SelectedTagsData> {
	@JSONField(name: "list")
	List<SelectedTagsDataList> xList;
	bool hasNext;
}

class SelectedTagsDataList with JsonConvert<SelectedTagsDataList> {
	String id;
	String newsType;
	String title;
	List<SelectedTagsDataListTags> tags;
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
	SelectedTagsDataListPublisher publisher;
	SelectedTagsDataListLocation location;
	SelectedTagsDataListVidStatus vidStatus;
	SelectedTagsDataListComment comment;
	SelectedTagsDataListWatch watch;
}

class SelectedTagsDataListTags with JsonConvert<SelectedTagsDataListTags> {
	String id;
	String name;
	String coverImg;
	String description;
	int playCount;
	bool hasCollected;
}

class SelectedTagsDataListPublisher with JsonConvert<SelectedTagsDataListPublisher> {
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

class SelectedTagsDataListLocation with JsonConvert<SelectedTagsDataListLocation> {
	String id;
	String city;
	String cover;
	int visit;
	String createdAt;
}

class SelectedTagsDataListVidStatus with JsonConvert<SelectedTagsDataListVidStatus> {
	bool hasLiked;
	bool hasPaid;
	bool hasCollected;
	int todayRank;
	int todayPlayCnt;
}

class SelectedTagsDataListComment with JsonConvert<SelectedTagsDataListComment> {
	int uid;
	String name;
	String portrait;
	String cid;
	String content;
	int likeCount;
	bool isAuthor;
	String createdAt;
}

class SelectedTagsDataListWatch with JsonConvert<SelectedTagsDataListWatch> {
	int watchCount;
	bool isWatch;
	bool isFreeWatch;
}
