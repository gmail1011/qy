import 'package:flutter_app/model/video_model.dart';

/// page : 31

class SpecialModel {
  List<ListBeanSp> list;
  int page;
  bool hasNext = false;

  static SpecialModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    SpecialModel specialModelBean = SpecialModel();
    specialModelBean.list = List()
      ..addAll((map['list'] as List ?? []).map((o) => ListBeanSp.fromMap(o)));
    specialModelBean.page = map['page'];
    specialModelBean.hasNext = map['hasNext'] ??= false;
    return specialModelBean;
  }

  Map toJson() => {
        "list": list,
        "page": page,
        "hasNext": hasNext,
      };
}

/// tagName : "自拍"
/// coverImg : "image/ap/by/fn/xl/7636d24bfc9b42a8975cde53140cc27b.jpg"
/// description : ""
/// tPlayCount : 19918

class ListBeanSp {
  String tagId;
  String tagName;
  String coverImg;
  String description;
  int tPlayCount;
  String tagDesc;
  List<VideoModel> vidInfo;

  static ListBeanSp fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBeanSp listBean = ListBeanSp();
    listBean.tagId = map['tagId'];
    listBean.tagName = map['tagName'];
    listBean.coverImg = map['coverImg'];
    listBean.description = map['description'];
    listBean.tPlayCount = map['tPlayCount'];
    listBean.tagDesc = map['tagDesc'];
    listBean.vidInfo = List()
      ..addAll(
          (map['VidInfo'] as List ?? []).map((o) => VideoModel.fromJson(o)));
    return listBean;
  }

  Map toJson() => {
        "tagId": tagId,
        "tagName": tagName,
        "coverImg": coverImg,
        "description": description,
        "tPlayCount": tPlayCount,
        "VidInfo": vidInfo,
        "tagDesc": tagDesc,
      };
}

/// uid : 109955
/// name : "游客109955"
/// age : 21
/// gender : "male"
/// region : "白玉"
/// summary : "云上阳光依旧，我们的爱永远。"
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

/// hasLiked : true
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
/// city : "唐山"
/// cityCode : ""
/// address : ""
/// cover : "image/lz/vi/5g/71/082ad05111d84fd5a8d7334b27e5e2b6.jpg"
/// visit : 4

/// name : "自拍"
/// coverImg : "image/ap/by/fn/xl/7636d24bfc9b42a8975cde53140cc27b.jpg"
/// description : ""
/// playCount : 19918
/// hasCollected : true

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
