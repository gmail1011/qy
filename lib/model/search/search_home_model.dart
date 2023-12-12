import 'package:flutter_app/model/video_model.dart';

class SearchHomeModel {
  List<VideoModel> hVidList = [];
  List<VideoModel> hsVidList = [];
  List<ToneListBean> toneList = [];
  bool hasNext = false;

  static SearchHomeModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchHomeModel searchHomeModelBean = SearchHomeModel();
    searchHomeModelBean.hasNext = map['hasNext'];
    searchHomeModelBean.hVidList = List()
      ..addAll(
          (map['hVidList'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    searchHomeModelBean.hsVidList = List()
      ..addAll(
          (map['hsVidList'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    searchHomeModelBean.toneList = List()
      ..addAll(
          (map['toneList'] as List ?? []).map((o) => ToneListBean.fromMap(o)));
    return searchHomeModelBean;
  }

  Map toJson() => {
        "hVidList": hVidList,
        "hsVidList": hsVidList,
        "toneList": toneList,
      };
}

class ToneListBean {
  String id;
  String name;
  String types;
  String cover;
  int sortKey;
  bool enable;
  String createdAt;
  String updatedAt;

  static ToneListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ToneListBean toneListBean = ToneListBean();
    toneListBean.id = map['id'];
    toneListBean.name = map['name'];
    toneListBean.types = map['types'];
    toneListBean.cover = map['cover'];
    toneListBean.sortKey = map['sortKey'];
    toneListBean.enable = map['enable'];
    toneListBean.createdAt = map['createdAt'];
    toneListBean.updatedAt = map['updatedAt'];
    return toneListBean;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "types": types,
        "cover": cover,
        "sortKey": sortKey,
        "enable": enable,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

//class HsVidListBean {
//  String id;
//  String title;
//  List<TagsBean> tags;
//  String sourceID;
//  String sourceURL;
//  int playTime;
//  String cover;
//  String coverThumb;
//  String via;
//  int playCount;
//  int likeCount;
//  int commentCount;
//  int shareCount;
//  int coins;
//  int size;
//  int status;
//  String resolution;
//
////  double ratio;
//  String mimeType;
//  String actor;
//  int freeTime;
//  String createdAt;
// LocationBean location;
//  VidStatusBean vidStatus;
//  PublisherBean publisher;
//
//  static HsVidListBean fromMap(Map<String, dynamic> map) {
//    if (map == null) return null;
//    HsVidListBean hsVidListBean = HsVidListBean();
//    hsVidListBean.id = map['id'];
//    hsVidListBean.title = map['title'];
//    hsVidListBean.tags = List()..addAll((map['tags'] as List ?? []).map((o) => TagsBean.fromMap(o)));
//    hsVidListBean.sourceID = map['sourceID'];
//    hsVidListBean.sourceURL = map['sourceURL'];
//    hsVidListBean.playTime = map['playTime'];
//    hsVidListBean.cover = map['cover'];
//    hsVidListBean.coverThumb = map['coverThumb'];
//    hsVidListBean.via = map['via'];
//    hsVidListBean.playCount = map['playCount'];
//    hsVidListBean.likeCount = map['likeCount'];
//    hsVidListBean.commentCount = map['commentCount'];
//    hsVidListBean.shareCount = map['shareCount'];
//    hsVidListBean.coins = map['coins'];
//    hsVidListBean.size = map['size'];
//    hsVidListBean.status = map['status'];
//    hsVidListBean.resolution = map['resolution'];
////    hsVidListBean.ratio = map['ratio'] ? map['ratio'] : 0.0;
//    hsVidListBean.mimeType = map['mimeType'];
//    hsVidListBean.actor = map['actor'];
//    hsVidListBean.freeTime = map['freeTime'];
//    hsVidListBean.createdAt = map['createdAt'];
//    hsVidListBean.location = LocationBean.fromMap(map['location']);
//    hsVidListBean.vidStatus = VidStatusBean.fromMap(map['vidStatus']);
//    hsVidListBean.publisher = PublisherBean.fromMap(map['publisher']);
//    return hsVidListBean;
//  }
//
//  Map toJson() => {
//        "id": id,
//        "title": title,
//        "tags": tags,
//        "sourceID": sourceID,
//        "sourceURL": sourceURL,
//        "playTime": playTime,
//        "cover": cover,
//        "coverThumb": coverThumb,
//        "via": via,
//        "playCount": playCount,
//        "likeCount": likeCount,
//        "commentCount": commentCount,
//        "shareCount": shareCount,
//        "coins": coins,
//        "size": size,
//        "status": status,
//        "resolution": resolution,
////    "ratio": ratio,
//        "mimeType": mimeType,
//        "actor": actor,
//        "freeTime": freeTime,
//        "createdAt": createdAt,
//        "location": location,
//        "vidStatus": vidStatus,
//        "publisher": publisher,
//      };
//}

/// uid : 102175
/// name : "大家来看我BB"
/// age : 26
/// gender : "female"
/// region : "宝坻"
/// summary : "有些东西强求不来，比如爱情，比如信。"
/// vipLevel : 0
/// hasFollowed : false
/// fansCount : 0

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

class SearchPublisherBean {
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

/// hasLiked : false
/// hasPaid : false
/// hasCollected : false

class SearchVidStatusBean {
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

class SearchTagsBean {
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
