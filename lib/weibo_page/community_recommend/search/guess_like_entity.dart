import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';
import 'package:flutter_app/model/awards_model.dart';

class GuessLikeEntity with JsonConvert<GuessLikeEntity> {
  int code;
  GuessLikeData data;
  bool hash;
  String msg;
  String time;
  String tip;
}

class GuessLikeData with JsonConvert<GuessLikeData> {
  @JSONField(name: "list")
  List<GuessLikeDataList> xList;
  bool hasNext;
}

class GuessLikeDataList with JsonConvert<GuessLikeDataList> {
  int uid;
  String name;
  String gender;
  String upTag;
  String portrait;
  String summary;
  bool hasLocked;
  bool hasBanned;
  bool hasFollow;
  bool isVip;
  int follow;
  int fans;
  int collectionCount;
  bool superUser;
  int merchantUser;
  List<int> awards = [];
  List<String> awardsImage = [];
  List<AwardsExpire> awardsExpire = [];
  List<GuessLikeDataListVInfos> vInfos;
}

class GuessLikeDataListVInfos with JsonConvert<GuessLikeDataListVInfos> {
  String id;
  String newsType;
  String title;
  List<GuessLikeDataListVInfosTags> tags;
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
  GuessLikeDataListVInfosPublisher publisher;
  GuessLikeDataListVInfosLocation location;
  GuessLikeDataListVInfosVidStatus vidStatus;
  GuessLikeDataListVInfosComment comment;
  GuessLikeDataListVInfosWatch watch;
  bool isForWard;
  int forWardUser;
  String forWardUserName;
}

class GuessLikeDataListVInfosTags
    with JsonConvert<GuessLikeDataListVInfosTags> {
  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  bool hasCollected;
}

class GuessLikeDataListVInfosPublisher
    with JsonConvert<GuessLikeDataListVInfosPublisher> {
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

class GuessLikeDataListVInfosLocation
    with JsonConvert<GuessLikeDataListVInfosLocation> {
  String id;
  String city;
  String cover;
  int visit;
  String createdAt;
}

class GuessLikeDataListVInfosVidStatus
    with JsonConvert<GuessLikeDataListVInfosVidStatus> {
  bool hasLiked;
  bool hasPaid;
  bool hasCollected;
  int todayRank;
  int todayPlayCnt;
}

class GuessLikeDataListVInfosComment
    with JsonConvert<GuessLikeDataListVInfosComment> {
  int uid;
  String name;
  String portrait;
  String cid;
  String content;
  int likeCount;
  bool isAuthor;
  String createdAt;
}

class GuessLikeDataListVInfosWatch
    with JsonConvert<GuessLikeDataListVInfosWatch> {
  int watchCount;
  bool isWatch;
  bool isFreeWatch;
}
