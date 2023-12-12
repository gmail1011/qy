import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/flutter_base.dart';

import 'ads_model.dart';
import 'awards_model.dart';
import 'location_bean.dart';

/// code : 200
/// msg : "success"

// 帖子类型
const NEWSTYPE_VIDEO = 'SP';
// 图片帖子
const NEWSTYPE_IMG = 'COVER';
// 广告
const NEWSTYPE_AD_VIDEO = 'AD_SP';
// 广告
const NEWSTYPE_AD_IMG = 'AD_COVER';
//换一换
const NEWSTYPE_CHANGE_FUNC = 'CHANGE_FUC';

/* type
1  { label: "会员中心页面", value: "yinseinner://memberCentre" },
2  { label: "分享推广页面", value: "yinseinner://sharePromote" },
3  { label: "收益中心", value: "yinseinner://incomeCenter" },
4  { label: "任务中心", value: "yinseinner://taskHall" },
5  { label: "任务详情", value: "yinseinner://taskDetails?id=" },
6  { label: "心愿工单", value: "yinseinner://wishList" },
7  { label: "创作中心", value: "yinseinner://creationCenter" },
8  { label: "我的认证", value: "yinseinner://myCertification" },
9  { label: "公告主界面", value: "yinseinner://announcement" },
10 { label: "在线客服页面", value: "yinseinner://kefu" },
11 { label: "跳转视频详情", value: "yinseinner://horizontalVideo?id=" },
12 { label: "跳转UP主详情", value: "yinseinner://userHomePage?uid=" },
13 { label: "游戏钱包", value: "yinseinner://gameWallet" }
14 短视频帖子详情
15 图文帖子详情
*/
class PostTitle {
  String originTitle;
  String linkurl;
  bool isRich;
  int  type;
  String first;
  String last;
  String txt;
  String jsonTxt;
  String id;
  PostTitle({this.originTitle, this.linkurl});
  int get length {
    if(isRich == true){
      return first.length + txt.length + last.length;
    }
    return originTitle?.length ?? 0;
  }
  String get linkUrl{
    String innerUrl = "";
    if(type == 1){
      innerUrl = "yinseinner://memberCentre";
    }else if(type == 2){
      innerUrl = "yinseinner://sharePromote";
    }else if(type == 3){
      innerUrl = "yinseinner://incomeCenter";
    }else if(type == 4){
      innerUrl = "yinseinner://taskHall";
    }else if(type == 5){
      innerUrl = "yinseinner://taskDetails?id=$id";
    }else if(type == 6){
      innerUrl = "yinseinner://wishList";
    }else if(type == 7){
      innerUrl = "yinseinner://creationCenter";
    }else if(type == 8){
      innerUrl = "yinseinner://myCertification";
    }else if(type == 9){
      innerUrl = "yinseinner://announcement";
    }else if(type == 10){
      innerUrl = "yinseinner://kefu";
    }else if(type == 11){ // 长视频
      innerUrl = "yinseinner://horizontalVideo?id=$id";
    }else if(type == 12){
      innerUrl = "yinseinner://userHomePage?uid=$id";
    }else if(type == 13){
      innerUrl = "yinseinner://gameWallet";
    }else if(type == 14){ // 短视频
      innerUrl = "";
    }else if(type == 15){// 帖子
      innerUrl = "";
    }else if(type == 16){// 会员
      innerUrl = "yinseinner://memberLongVideo";
    }
    return innerUrl;
  }
}

class VideoModel {
  get portrait => null;
  bool isReportFinish = false; // true 埋点上报过一次了
  static List<VideoModel> toList(List<dynamic> mapList) {
    List<VideoModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }
  PostTitle postTitle;
  String linkStr; // 富文本
  GlobalKey key = GlobalKey();
  int promotionDays;
  int coins;
  int originCoins;
  int commentCount;
  String rewarded;
  String cover;
  String coverThumb;
  String createdAt;
  String reviewAt;
  int freeTime;
  String id;
  String superId;
  bool isHideLocation;
  int likeCount;
  LocationBean location;
  String mimeType;
  int playCount;
  int purchaseCount;
  int payCount;
  int playTime;
  bool publisherTop;
  bool publisherPopStatus;
  String reason; //审核拒绝理由
  ///是否免费观看
  bool freeArea;
  PublisherBean publisher;
  var ratio;
  String resolution;
  int seeList;
  int shareCount;
  int size;
  String sourceID;
  String sourceURL;


  //0 未审核 1通过 2审核失败 3视为免费 5、已下架
  int status;
  List<TagsBean> tags;
  String title;
  String content;
  String via;
  CommentBean comment;
  VidStatusBean vidStatus;
  int playStatus = 0; //0：暂停  1：加载   2：播放
  bool isNeedBuyVip = false;
  bool isWantDel = false;
  List<String> seriesCover;
  WatchBean watch;

  //帖子类型 SP 视频帖子 COVER 图集帖子
  /// AD_SP 视频广告  AD_COVER 图片广告
  String newsType;
  int newsTypeIndex;
  AdsInfoBean randomAdsInfo; // 随机广告

  ///videoModel是否随机广告
  bool isRandomAd() {
    return randomAdsInfo != null;
  }
  bool isCoinVideo() {
    if((coins ?? 0) > 0 || (originCoins ?? 0) > 0){
      return true;
    }
    return false;
  }

  //视频金币价格，原价originCoins，折扣价coins
  int videoCoin(){
    if(GlobalStore.isVIP()){
      return coins;
    }
    return originCoins;
  }
  ///是否转发
  bool isForWard;

  ///转发人id
  int forWardUser;
  String forWardUserName;

  int forwardCount;

  double resolutionWidth() {
    if (TextUtil.isNotEmpty(resolution)) {
      var arr;
      if (resolution.contains("x")) {
        arr = resolution.split("x");
      } else {
        arr = resolution.split("*");
      }

      if (ArrayUtil.isNotEmpty(arr)) {
        return double.parse(arr[0] ?? "0");
      }
    }
    return .0;
  }

  double resolutionHeight() {
    if (TextUtil.isNotEmpty(resolution)) {
      var arr;
      if (resolution.contains("x")) {
        arr = resolution.split("x");
      } else {
        arr = resolution.split("*");
      }

      if (ArrayUtil.isNotEmpty(arr) && arr.length > 1) {
        return double.parse(arr[1] ?? "0");
      }
    }
    return .0;
  }

  /// 广告链接
  String linkUrl;
  bool isTopping; // 置顶
  bool isRecommend; // 力荐
  bool isChoosen; // 置精

  bool chosen;
  bool selected;
  int type; // 作品管理 type
  String get playCountDesc {
    if (playCount == null) return "";
    return "观看"+((playCount > 10000) ? (playCount / 10000).toStringAsFixed(1) + "万" : playCount.toString())+"人";
  }

  String get playCountDescTwo {
    if (playCount == null) return "";
    return ((playCount > 10000) ? (playCount / 10000).toStringAsFixed(1) + "万" : playCount.toString())+"播放";
  }

  String get playCountDescThree {
    if (playCount == null) return "";
    return ((playCount > 10000) ? (playCount / 10000).toStringAsFixed(1) + "万" : playCount.toString())+"浏览";
  }

  String get playCountDescFour {
    if (playCount == null) return "";
    return ((playCount > 10000) ? (playCount / 10000).toStringAsFixed(1) + "万" : playCount.toString())+"次播放";
  }

  static VideoModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    VideoModel dataBean = VideoModel();
    dataBean.type = map['type'];
    dataBean.coins = map['coins'];
    dataBean.originCoins = map['originCoins'];
    dataBean.commentCount = map['commentCount'];
    dataBean.cover = map['cover'];
    dataBean.coverThumb = map['coverThumb'];
    dataBean.createdAt = (!map.containsKey('reviewAt') || map['reviewAt'] == 0)
        ? map['createdAt']
        : map['reviewAt'];
    dataBean.reviewAt = map['reviewAt'];
    dataBean.freeTime = map['freeTime'];
    dataBean.id =  map['id'];
    dataBean.newsType = map['newsType'];
    dataBean.title = map['title'];
    dataBean.content = map['content'];
    dataBean.superId = map['id'];
    if(map['name'] != null && map['publisher'] == null){
      dataBean.publisher = PublisherBean()..name = map['name'];
    }else {
      dataBean.publisher = PublisherBean.fromMap(map['publisher']);
    }
    dataBean.promotionDays = map['promotionDays'];

    dataBean.isHideLocation = map['isHideLocation'];
    dataBean.likeCount = map['likeCount'];
    if(map['location'] is Map) {
      dataBean.location = LocationBean.fromJson(map['location']);
    }
    dataBean.mimeType = map['mimeType'];
    dataBean.playCount = map['playCount'];
    dataBean.purchaseCount = map['purchaseCount'];
    dataBean.payCount = map['payCount'] ?? 0;
    dataBean.playTime = map['playTime'];
    dataBean.publisherTop = map['publisherTop'];
    dataBean.publisherPopStatus = map['publisherPopStatus'];
    dataBean.ratio = map['ratio'];
    dataBean.resolution = map['resolution'];
    dataBean.seeList = map['seeList'];
    dataBean.shareCount = map['shareCount'];
    dataBean.size = map['size'];
    dataBean.sourceID = map['sourceID'];
    dataBean.sourceURL = map['sourceURL'];
    dataBean.status = map['status'];
    dataBean.freeArea = map['freeArea'];
    if(map['tags'] is List){
      if((map['tags'] as List).isNotEmpty == true){
        if(map['tags'][0] is Map){
          dataBean.tags = List()
            ..addAll((map['tags'] as List ?? []).map((o) => TagsBean.fromMap(o)));
        }
      }
    }
    dataBean.via = map['via'];
    dataBean.comment =
        map.containsKey("comment") ? CommentBean.fromMap(map['comment']) : null;
    dataBean.watch =
        map.containsKey("watch") ? WatchBean.fromMap(map['watch']) : null;
    dataBean.vidStatus = VidStatusBean.fromMap(map['vidStatus']);
    List<String> covers = List()
      ..addAll((map['seriesCover'] as List ?? []).map((o) => o));
    /*if (covers.length > 9) {
      dataBean.seriesCover = covers.sublist(0, 9);
    } else {
      dataBean.seriesCover = covers;
    }*/

    dataBean.seriesCover = covers;
    dataBean.isTopping = map['isTopping'];
    dataBean.isRecommend = map['isRecommend'];
    dataBean.isChoosen = map['isChoosen'];
    dataBean.chosen = map['chosen'];
    dataBean.reason = map['reason'];
    dataBean.linkUrl = map['linkUrl'];
    dataBean.rewarded = map['rewarded'];

    dataBean.isForWard = map['isForWard'];
    dataBean.forWardUser = map['forWardUser'];
    dataBean.forWardUserName = map['forWardUserName'];
    dataBean.forwardCount = map['forwardCount'];
    dataBean.linkStr = map['linkStr'];
    return dataBean;
  }

  Map toJson() => {
        "coins": coins,
        "originCoins": originCoins,
        "commentCount": commentCount,
        "cover": cover,
        "coverThumb": coverThumb,
        "createdAt": createdAt,
        "freeTime": freeTime,
        "id": id,
        "isHideLocation": isHideLocation,
        "likeCount": likeCount,
        "location": location,
        "mimeType": mimeType,
        "playCount": playCount,
        "purchaseCount": purchaseCount,
        "playTime": playTime,
        "publisherTop": publisherTop,
        "publisherPopStatus": publisherPopStatus,
        "publisher": publisher,
        "ratio": ratio,
        "resolution": resolution,
        "seeList": seeList,
        "shareCount": shareCount,
        "size": size,
        "sourceID": sourceID,
        "sourceURL": sourceURL,
        "status": status,
        "tags": tags,
        "watch": watch,
        "title": title,
        "via": via,
        "vidStatus": vidStatus,
        "comment": comment,
        "playStatus": playStatus,
        "isNeedBuyVip": isNeedBuyVip,
        "isWantDel": isWantDel,
        "freeArea": freeArea,
        "seriesCover": seriesCover,
        "newsType": newsType,
        "isTopping": isTopping,
        "isRecommend": isRecommend,
        "isChoosen": isChoosen,
        "chosen": chosen,
        'reason': reason,
        'linkUrl': linkUrl,
        'isForWard': isForWard,
        'forWardUser': forWardUser,
        'forWardUserName': forWardUserName,
        'forwardCount': forwardCount,
      'linkStr': linkStr,
      };

  ///videoModel是否是视频
  bool isVideo() {
    return newsType?.contains(NEWSTYPE_VIDEO) ?? true;
  }

  ///videoModel是否是图片
  bool isImg() {
    return newsType?.contains(NEWSTYPE_IMG) ?? false;
  }

  ///videoModel是否是广告
  bool isAd() {
    return newsType?.contains("AD") ?? false;
  }
}

/// coins : 0
/// commentCount : 0
/// createdAt : "2019-11-03T19:18:10.997+08:00"
/// freeTime : 0
/// id : "5db90e4d7d2b4ff0e8007306"
/// isHideLocation : false
/// likeCount : 502
/// mimeType : "video/mp4"
/// playCount : 5
/// playTime : "80"
/// publisher : {"age":28,"gender":"female","hasFollowed":false,"name":"场控，","portrait":"image/gv/r4/7n/i2/69351ea1bc1a47c7afdc91df358b531d.jpeg","uid":100368}
/// ratio : 1.78
/// resolution : "640*360"
/// seeList : 0
/// shareCount : 0
/// size : 26148447
/// sourceID : "5db90e4d7d2b4ff0e8007306"
/// status : 1
/// title : "桐城市95年骚逼江扬"
/// via : "q1"
/// vidStatus : {"hasCollected":false,"hasLiked":false,"hasPaid":false,"todayPlayCnt":0,"todayRank":0}

/// hasCollected : false
/// hasLiked : false
/// hasPaid : false
/// todayPlayCnt : 0
/// todayRank : 0

class VidStatusBean {
  bool hasCollected;
  bool hasLiked;
  bool hasPaid;
  int todayPlayCnt;
  int todayRank;

  static VidStatusBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    VidStatusBean vidStatusBean = VidStatusBean();
    vidStatusBean.hasCollected = map['hasCollected'];
    vidStatusBean.hasLiked = map['hasLiked'];
    vidStatusBean.hasPaid = map['hasPaid'];
    vidStatusBean.todayPlayCnt = map['todayPlayCnt'];
    vidStatusBean.todayRank = map['todayRank'];
    return vidStatusBean;
  }

  Map toJson() => {
        "hasCollected": hasCollected,
        "hasLiked": hasLiked,
        "hasPaid": hasPaid,
        "todayPlayCnt": todayPlayCnt,
        "todayRank": todayRank,
      };
}

/// coverImg : "sp/xa/e6/fw/347ce1719fe24d5bb31c5ac2e831e6c9-1.jpg"
/// description : ""
/// hasCollected : false
/// name : "呻吟骚话"
/// playCount : 726

class TagsBean {
  String coverImg;
  String description;
  bool hasCollected;
  String id;
  String name;
  int playCount;

  static TagsBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TagsBean tagsBean = TagsBean();
    tagsBean.coverImg = map['coverImg'];
    tagsBean.description = map['description'];
    tagsBean.hasCollected = map['hasCollected'];
    tagsBean.id = map['id'];
    tagsBean.name = map['name'];
    tagsBean.playCount = map['playCount'];
    return tagsBean;
  }

  Map toJson() => {
        "coverImg": coverImg,
        "description": description,
        "hasCollected": hasCollected,
        "id": id,
        "name": name,
        "playCount": playCount,
      };
}

/// isFreeWatch: true
/// isWatch: false
/// watchCount: 0
class WatchBean {
  bool isFreeWatch;
  bool isWatch;
  int watchCount;

  static WatchBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    WatchBean watchBean = WatchBean();
    watchBean.isFreeWatch = map['isFreeWatch'];
    watchBean.isWatch = map['isWatch'];
    watchBean.watchCount = map['watchCount'];
    return watchBean;
  }

  Map toJson() => {
        "isFreeWatch": isFreeWatch,
        "isWatch": isWatch,
        "watchCount": watchCount,
      };
}

/// age : 28
/// gender : "female"
/// hasFollowed : false
/// name : "场控，"
/// portrait : "image/gv/r4/7n/i2/69351ea1bc1a47c7afdc91df358b531d.jpeg"
/// uid : 100368

class PublisherBean {
  int age;
  String gender;
  bool hasFollowed;
  String name;
  String portrait;
  String upTag;
  int uid;
  int vipLevel; //月卡 季卡 年卡
  String vipName;
  bool isVip;
  bool superUser; //大v
  int activeValue; //活跃值
  bool officialCert; //官方认证
  int rechargeLevel; //vip等级 vip1-vip8
  int merchantUser; //认证商户

  List<int> awards = [];
  List<String> awardsImage = [];
  List<AwardsExpire> awardsExpire = [];

  static PublisherBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PublisherBean publisherBean = PublisherBean();
    publisherBean.age = map['age'];
    publisherBean.gender = map['gender'];
    publisherBean.hasFollowed = map['hasFollowed'];
    publisherBean.name = map['name'];
    publisherBean.upTag = map['upTag'];
    publisherBean.portrait = map['portrait'];
    publisherBean.vipName = map['vipName'];
    publisherBean.uid = map['uid'];
    publisherBean.vipLevel = map['vipLevel'];
    publisherBean.isVip = map['isVip'];
    publisherBean.superUser = map['superUser'];
    publisherBean.activeValue = map['activeValue'];
    publisherBean.officialCert = map['officialCert'];
    publisherBean.rechargeLevel = map['rechargeLevel'];
    publisherBean.merchantUser = map['merchantUser'];

    publisherBean.awards = List()
      ..addAll((map['awards'] as List ?? []).map((o) => o));

    publisherBean.awardsExpire = map["awardsExpire"] == null
        ? []
        : List<AwardsExpire>.from(
            map["awardsExpire"].map((x) => AwardsExpire.fromJson(x)));

    publisherBean.awards.forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element == element1.number) {
          publisherBean.awardsImage.add(element1.imgUrl);
        }
      });
    });

    (publisherBean?.awardsExpire ?? []).forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element.number == element1.number) {
          element.imageUrl = element1.imgUrl;
        }
      });
    });

    return publisherBean;
  }

  Map toJson() => {
        "age": age,
        "gender": gender,
        "hasFollowed": hasFollowed,
        "name": name,
        "upTag": upTag,
        "portrait": portrait,
        "vipName":vipName,
        "uid": uid,
        "vipLevel": vipLevel,
        "isVip": isVip,
        "superUser": superUser,
        "activeValue": activeValue,
        "officialCert": officialCert,
        "awards": awards,
        "awardsImage": awardsImage,
        "awardsExpire": awardsExpire,
        "merchantUser": merchantUser,
      };
}

class CommentBean {
  int uid;
  String name;
  String portrait;
  String cid;
  String content;
  int likeCount;
  bool isAuthor;
  String createdAt;

  static CommentBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentBean commentBean = CommentBean();
    commentBean.uid = map['uid'];
    commentBean.name = map['name'];
    commentBean.portrait = map['portrait'];
    commentBean.cid = map['cid'];
    commentBean.content = map['content'];
    commentBean.likeCount = map['likeCount'];
    commentBean.isAuthor = map['isAuthor'];
    commentBean.createdAt = map['createdAt'];
    return commentBean;
  }

  Map toJson() => {
        "uid": uid,
        "name": name,
        "portrait": portrait,
        "cid": cid,
        "content": content,
        "likeCount": likeCount,
        "isAuthor": isAuthor,
        "createdAt": createdAt,
      };
}

// class AwardsExpire {
//   AwardsExpire({
//     this.number,
//     this.isExpire,
//     this.imageUrl,
//   });
//
//   int number;
//   bool isExpire;
//   String imageUrl;
//
//   factory AwardsExpire.fromJson(Map<String, dynamic> json) => AwardsExpire(
//         number: json["number"] == null ? null : json["number"],
//         isExpire: json["isExpire"] == null ? null : json["isExpire"],
//         imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "number": number == null ? null : number,
//         "isExpire": isExpire == null ? null : isExpire,
//         "imgUrl": imageUrl == null ? null : imageUrl,
//       };
// }
