import 'package:flutter_app/model/location_bean.dart';

class SearchVideoDetailModel {
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
  PublisherBean publisher;

  static SearchVideoDetailModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchVideoDetailModel searchVideoDetailModelBean =
        SearchVideoDetailModel();
    searchVideoDetailModelBean.id = map['id'];
    searchVideoDetailModelBean.title = map['title'];
    searchVideoDetailModelBean.tags = List()
      ..addAll((map['tags'] as List ?? []).map((o) => TagsBean.fromMap(o)));
    searchVideoDetailModelBean.sourceID = map['sourceID'];
    searchVideoDetailModelBean.sourceURL = map['sourceURL'];
    searchVideoDetailModelBean.playTime = map['playTime'];
    searchVideoDetailModelBean.cover = map['cover'];
    searchVideoDetailModelBean.coverThumb = map['coverThumb'];
    searchVideoDetailModelBean.via = map['via'];
    searchVideoDetailModelBean.playCount = map['playCount'];
    searchVideoDetailModelBean.likeCount = map['likeCount'];
    searchVideoDetailModelBean.commentCount = map['commentCount'];
    searchVideoDetailModelBean.shareCount = map['shareCount'];
    searchVideoDetailModelBean.coins = map['coins'];
    searchVideoDetailModelBean.size = map['size'];
    searchVideoDetailModelBean.status = map['status'];
    searchVideoDetailModelBean.resolution = map['resolution'];
    searchVideoDetailModelBean.ratio = map['ratio'];
    searchVideoDetailModelBean.mimeType = map['mimeType'];
    searchVideoDetailModelBean.actor = map['actor'];
    searchVideoDetailModelBean.freeTime = map['freeTime'];
    searchVideoDetailModelBean.createdAt = map['createdAt'];
    searchVideoDetailModelBean.location =
        LocationBean.fromJson(map['location']);
    searchVideoDetailModelBean.vidStatus =
        VidStatusBean.fromMap(map['vidStatus']);
    searchVideoDetailModelBean.publisher =
        PublisherBean.fromMap(map['publisher']);
    return searchVideoDetailModelBean;
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
        "publisher": publisher,
      };
}

/// uid : 104296
/// name : "水晶之人"
/// age : 21
/// gender : "female"
/// portrait : "image/8t/uf/n6/h6/699dbb7b529c49daa52f237478f90853.jpeg"
/// region : "陈旗"
/// summary : ""
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
/// city : "石家庄"
/// cityCode : ""
/// address : ""
/// cover : "image/0y/nr/uj/4g/cf7cd5df5b7841979857db8aa72ac9e7.jpg"
/// visit : 8

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
