import 'package:flutter_app/generated/json/base/json_convert_content.dart';

import 'ads_model.dart';

class TagsDetailEntity with JsonConvert<TagsDetailEntity> {
  int code;
  TagsDetailData data;
  bool hash;
  String msg;
  String time;
  String tip;
}

class TagsDetailData with JsonConvert<TagsDetailData> {
  List<TagsDetailDataSections> sections;
  bool hasNext;
}

class TagsDetailDataSections with JsonConvert<TagsDetailDataSections> {
  String sectionID;
  String sectionName;
  List<TagsDetailDataSectionsVideoInfo> videoInfo;
  TagsDetailDataSectionsOriginalBloggerInfo originalBloggerInfo;
  bool hasFollowed;
  AdsInfoBean randomAdsInfo; // 随机广告
  int sortType;

  bool isRandomAd() {
    return randomAdsInfo != null;
  }
}

class TagsDetailDataSectionsVideoInfo
    with JsonConvert<TagsDetailDataSectionsVideoInfo> {
  String id;
  String newsType;
  String title;
  List<TagsDetailDataSectionsVideoInfoTags> tags;
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
  TagsDetailDataSectionsVideoInfoPublisher publisher;
  TagsDetailDataSectionsVideoInfoLocation location;
  TagsDetailDataSectionsVideoInfoVidStatus vidStatus;
  TagsDetailDataSectionsVideoInfoComment comment;
  TagsDetailDataSectionsVideoInfoWatch watch;

  String get playCountDesc {
    if (playCount == null) return "0";
    return playCount > 10000
        ? (playCount / 10000).toStringAsFixed(1) + "w"
        : playCount.toString();
  }
}

class TagsDetailDataSectionsVideoInfoTags
    with JsonConvert<TagsDetailDataSectionsVideoInfoTags> {
  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  bool hasCollected;
}

class TagsDetailDataSectionsVideoInfoPublisher
    with JsonConvert<TagsDetailDataSectionsVideoInfoPublisher> {
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

class TagsDetailDataSectionsVideoInfoLocation
    with JsonConvert<TagsDetailDataSectionsVideoInfoLocation> {
  String id;
  String city;
  String cover;
  int visit;
  String createdAt;
}

class TagsDetailDataSectionsVideoInfoVidStatus
    with JsonConvert<TagsDetailDataSectionsVideoInfoVidStatus> {
  bool hasLiked;
  bool hasPaid;
  bool hasCollected;
  int todayRank;
  int todayPlayCnt;
}

class TagsDetailDataSectionsVideoInfoComment
    with JsonConvert<TagsDetailDataSectionsVideoInfoComment> {
  int uid;
  String name;
  String portrait;
  String cid;
  String content;
  int likeCount;
  bool isAuthor;
  String createdAt;
}

class TagsDetailDataSectionsVideoInfoWatch
    with JsonConvert<TagsDetailDataSectionsVideoInfoWatch> {
  int watchCount;
  bool isWatch;
  bool isFreeWatch;
}

class TagsDetailDataSectionsOriginalBloggerInfo
    with JsonConvert<TagsDetailDataSectionsOriginalBloggerInfo> {
  int uid;
  String name;
  String portrait;
  bool officialCert;
  String summary;
}
