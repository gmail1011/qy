import 'package:flutter_app/model/location_bean.dart';

/// id : "5db901da7d2b4ff0e8006be0"
/// title : "网约富家女爆操很多次"
/// sourceID : "5db901da7d2b4ff0e8006be0"
/// playTime : 40
/// via : "q1"
/// playCount : 28
/// likeCount : 478
/// commentCount : 0
/// shareCount : 0
/// coins : 0
/// size : 2673674
/// status : 1
/// resolution : "202*360"
/// ratio : 0.56
/// mimeType : "video/mp4"
/// actor : ""
/// freeTime : 0
/// createdAt : "2019-11-03T19:16:56.282+08:00"
/// vidStatus : {"hasLiked":false,"hasPaid":false,"hasCollected":false}
/// commentSy : {}
/// publisher : {"uid":111455,"name":"游客111455","age":22,"gender":"male","portrait":"image/gg/lu/te/1w/abe60901435a4815aba1703e48a2f85b.jpg","region":"德兴","summary":"每个人生下来都要从事某项事业，每一个活在地还应上的人都有自己生活中的义务。","vipLevel":0,"hasFollowed":false,"fansCount":1}

class SearchVideoModel {
  String id;
  String title;
  List<TagsBean> tags;
  String sourceID;
  String sourceURL;
  int playTime;
  String cover;
  String coverThumb;
  String via;
  int playCount;
  int likeCount;
  int commentCount;
  int shareCount;
  int coins;
  int size;
  int status;
  String resolution;
  double ratio;
  String mimeType;
  String actor;
  int freeTime;
  String createdAt;
  LocationBean location;
  VidStatusBean vidStatus;
  CommentSyBean commentSy;
  PublisherBean publisher;

  static SearchVideoModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchVideoModel searchVideoModelBean = SearchVideoModel();
    searchVideoModelBean.id = map['id'];
    searchVideoModelBean.title = map['title'];
    searchVideoModelBean.tags = List()
      ..addAll((map['tags'] as List ?? []).map((o) => TagsBean.fromMap(o)));
    searchVideoModelBean.sourceID = map['sourceID'];
    searchVideoModelBean.sourceURL = map['sourceURL'];
    searchVideoModelBean.playTime = map['playTime'];
    searchVideoModelBean.cover = map['cover'];
    searchVideoModelBean.coverThumb = map['coverThumb'];
    searchVideoModelBean.via = map['via'];
    searchVideoModelBean.playCount = map['playCount'];
    searchVideoModelBean.likeCount = map['likeCount'];
    searchVideoModelBean.commentCount = map['commentCount'];
    searchVideoModelBean.shareCount = map['shareCount'];
    searchVideoModelBean.coins = map['coins'];
    searchVideoModelBean.size = map['size'];
    searchVideoModelBean.status = map['status'];
    searchVideoModelBean.resolution = map['resolution'];
    searchVideoModelBean.ratio = map['ratio'];
    searchVideoModelBean.mimeType = map['mimeType'];
    searchVideoModelBean.actor = map['actor'];
    searchVideoModelBean.freeTime = map['freeTime'];
    searchVideoModelBean.createdAt = map['createdAt'];
    searchVideoModelBean.location = LocationBean.fromJson(map['location']);
    searchVideoModelBean.vidStatus = VidStatusBean.fromMap(map['vidStatus']);
    searchVideoModelBean.commentSy = CommentSyBean.fromMap(map['commentSy']);
    searchVideoModelBean.publisher = PublisherBean.fromMap(map['publisher']);
    return searchVideoModelBean;
  }

  Map toJson() => {
        "id": id,
        "title": title,
        "tags": tags,
        "sourceID": sourceID,
        "sourceURL": sourceURL,
        "playTime": playTime,
        "cover": cover,
        "coverThumb": coverThumb,
        "via": via,
        "playCount": playCount,
        "likeCount": likeCount,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "coins": coins,
        "size": size,
        "status": status,
        "resolution": resolution,
        "ratio": ratio,
        "mimeType": mimeType,
        "actor": actor,
        "freeTime": freeTime,
        "createdAt": createdAt,
        "location": location,
        "vidStatus": vidStatus,
        "commentSy": commentSy,
        "publisher": publisher,
      };
}

/// uid : 111455
/// name : "游客111455"
/// age : 22
/// gender : "male"
/// portrait : "image/gg/lu/te/1w/abe60901435a4815aba1703e48a2f85b.jpg"
/// region : "德兴"
/// summary : "每个人生下来都要从事某项事业，每一个活在地还应上的人都有自己生活中的义务。"
/// vipLevel : 0
/// hasFollowed : false
/// fansCount : 1

class PublisherBean {
  int uid;
  String name;
  int age;
  String gender;
  String portrait;
  String region;
  String summary;
  int vipLevel;
  bool hasFollowed;
  int fansCount;

  static PublisherBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PublisherBean publisherBean = PublisherBean();
    publisherBean.uid = map['uid'];
    publisherBean.name = map['name'];
    publisherBean.age = map['age'];
    publisherBean.gender = map['gender'];
    publisherBean.portrait = map['portrait'];
    publisherBean.region = map['region'];
    publisherBean.summary = map['summary'];
    publisherBean.vipLevel = map['vipLevel'];
    publisherBean.hasFollowed = map['hasFollowed'];
    publisherBean.fansCount = map['fansCount'];
    return publisherBean;
  }

  Map toJson() => {
        "uid": uid,
        "name": name,
        "age": age,
        "gender": gender,
        "portrait": portrait,
        "region": region,
        "summary": summary,
        "vipLevel": vipLevel,
        "hasFollowed": hasFollowed,
        "fansCount": fansCount,
      };
}

class CommentSyBean {
  static CommentSyBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentSyBean commentSyBean = CommentSyBean();
    return commentSyBean;
  }

  Map toJson() => {};
}

/// hasLiked : false
/// hasPaid : false
/// hasCollected : false

class VidStatusBean {
  bool hasLiked;
  bool hasPaid;
  bool hasCollected;

  static VidStatusBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    VidStatusBean vidStatusBean = VidStatusBean();
    vidStatusBean.hasLiked = map['hasLiked'];
    vidStatusBean.hasPaid = map['hasPaid'];
    vidStatusBean.hasCollected = map['hasCollected'];
    return vidStatusBean;
  }

  Map toJson() => {
        "hasLiked": hasLiked,
        "hasPaid": hasPaid,
        "hasCollected": hasCollected,
      };
}

/// longitude : ""
/// latitude : ""
/// country : ""
/// countryCode : ""
/// province : ""
/// provinceCode : ""
/// city : "南京"
/// cityCode : ""
/// address : ""
/// cover : "image/lj/2s/cw/6g/3b35907a67a0410689a538eb7af4453d.jpg"
/// visit : 4

/// name : "白白嫩嫩"
/// description : ""
/// playCount : 200
/// hasCollected : false

class TagsBean {
  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  bool hasCollected;

  static TagsBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TagsBean tagsBean = TagsBean();
    tagsBean.id = map['id'];
    tagsBean.name = map['name'];
    tagsBean.coverImg = map['coverImg'];
    tagsBean.description = map['description'];
    tagsBean.playCount = map['playCount'];
    tagsBean.hasCollected = map['hasCollected'];
    return tagsBean;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "coverImg": coverImg,
        "description": description,
        "playCount": playCount,
        "hasCollected": hasCollected,
      };
}
