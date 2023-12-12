import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class AddUserEntity with JsonConvert<AddUserEntity> {
  int code;
  AddUserData data;
  bool hash;
  String msg;
  String time;
  String tip;
}

class AddUserData with JsonConvert<AddUserData> {
  @JSONField(name: "list")
  List<AddUserDataList> xList;
  bool hasNext;
}

class AddUserDataList with JsonConvert<AddUserDataList> {
  int uid;
  String name;
  String gender;
  String portrait;
  bool hasLocked;
  bool hasBanned;
  bool hasFollow;
  bool isVip;
  int follow;
  int fans;
  bool superUser;
  int vipLevel;
  int collectionCount;
  List<AddUserDataListVInfos> vInfos;
}

class AddUserDataListVInfos with JsonConvert<AddUserDataListVInfos> {
  String id;
  String newsType;
  String title;
  List<AddUserDataListVInfosTags> tags;
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
  AddUserDataListVInfosPublisher publisher;
  AddUserDataListVInfosLocation location;
  AddUserDataListVInfosVidStatus vidStatus;
  AddUserDataListVInfosComment comment;
  AddUserDataListVInfosWatch watch;
  bool isForWard;
  int forWardUser;
  String forWardUserName;
}

class AddUserDataListVInfosTags with JsonConvert<AddUserDataListVInfosTags> {
  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  bool hasCollected;
}

class AddUserDataListVInfosPublisher
    with JsonConvert<AddUserDataListVInfosPublisher> {
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

class AddUserDataListVInfosLocation
    with JsonConvert<AddUserDataListVInfosLocation> {
  String id;
  String city;
  String cover;
  int visit;
  String createdAt;
}

class AddUserDataListVInfosVidStatus
    with JsonConvert<AddUserDataListVInfosVidStatus> {
  bool hasLiked;
  bool hasPaid;
  bool hasCollected;
  int todayRank;
  int todayPlayCnt;
}

class AddUserDataListVInfosComment
    with JsonConvert<AddUserDataListVInfosComment> {
  int uid;
  String name;
  String portrait;
  String cid;
  String content;
  int likeCount;
  bool isAuthor;
  String createdAt;
}

class AddUserDataListVInfosWatch with JsonConvert<AddUserDataListVInfosWatch> {
  int watchCount;
  bool isWatch;
  bool isFreeWatch;
}
