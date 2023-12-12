import 'package:flutter_app/common/config/config.dart';

import 'awards_model.dart';

/// age : 0
/// like : 0
/// follow : 5
/// fans : 1
/// collectionCount : 0
/// likeCount : 35
/// favoriteCount : 0
/// isVip : true
/// isFollow : false
/// promoteURL : "https://ysappa.com/?pc=5ZZGXG"
/// city : "香港"
/// buyVidCount : 2
/// uid : 113004
/// devID : "863009043211777"
/// devType : ""
/// devToken : ""
/// registerIP : "45.120.55.181"
/// mobile : ""
/// gender : ""
/// channel : "system-an"
/// name : "游客1573189025"
/// summary : ""
/// region : ""
/// birthday : ""
/// vipLevel : 1
/// vipExpireDate : "2019-12-12T20:56:42.431+08:00"
/// createdAt : "2019-11-08T12:57:05.782+08:00"
/// updatedAt : "2019-11-15T18:24:58.835+08:00"
/// mobileBindAt : null
/// hasLocked : false
/// hasBanned : false
/// watchCount : 10

///用户信息
class UserInfoModel {
  int age;
  int like;
  int dynamics;
  int follow;
  int fans;
  int collectionCount;
  int likeCount;
  int favoriteCount;
  bool isVip;
  bool isFollow;
  String promoteURL;
  String inviterCode;
  String city;
  int buyVidCount;
  int uid;
  String devID;
  String devType;
  String devToken;
  String registerIP;
  String mobile;
  String gender;
  String channel;
  String name;
  String promotionCode;
  String portrait;
  String summary;
  String region;
  String birthday;
  int vipLevel;
  String vipName;
  String vipExpireDate;
  String createdAt;
  String updatedAt;
  int urrPortraitStatus;
  int urrBGStatus;
  String mobileBindAt;
  bool hasLocked;
  bool hasBanned;
  String token;
  int watchCount;
  String webToken;
  String role;
  bool showProxy;
  int rechargeLevel; //头像等级
  bool superUser; //大V认证
  int activeValue; //活跃值
  bool officialCert; //官方认证
  List<String> background;

  //新增字段
  int level; //当前等级
  int current; //当前进度
  int limit; //当前等级需要的总数
  ///登录类型修改  0-devID 1-token 2 mobileLogin 3-qrCodeLogin
  int loginType;
  String rewarded;
  String goldVideoFreeExpire;
  int louFengUnlockTimes;
  int louFengDiscount;
  String appStoreCode;
  String lfCheatGuide;
  List<MyCoupon> goldVideoCoupon;
  String videoDiscountExpiration;
  String videoFreeExpiration;
  int payVidDiscount;
  int happinessPlazaCount;
  int loufengBookDiscount;
  int merchantUser;
  String loufengBookDiscountExpiration;

  int beRewardCount;
  int downloadCount; //下载次数

  List<int> awards = [];

  List<String> awardsImage = [];

  List<AwardsExpire> awardsExpire = [];


  String get fansCountDesc {
    if (fans == null) return "";
    return ((fans > 10000) ? (fans / 10000).toStringAsFixed(1) + "万" : fans.toString());
  }

  static UserInfoModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserInfoModel userInfoModelBean = UserInfoModel();
    userInfoModelBean.age = map['age'];
    userInfoModelBean.like = map['like'];
    userInfoModelBean.follow = map['follow'];
    userInfoModelBean.fans = map['fans'];
    userInfoModelBean.collectionCount = map['collectionCount'];
    userInfoModelBean.likeCount = map['likeCount'];
    userInfoModelBean.dynamics = map['dynamics'];
    userInfoModelBean.favoriteCount = map['favoriteCount'];
    userInfoModelBean.isVip = map['isVip'];
    userInfoModelBean.isFollow = map['isFollow'];
    userInfoModelBean.promoteURL = map['promoteURL'];
    userInfoModelBean.inviterCode = map['inviterCode'];
    userInfoModelBean.city = map['city'];
    userInfoModelBean.buyVidCount = map['buyVidCount'];
    userInfoModelBean.uid = map['uid'];
    userInfoModelBean.devID = map['devID'];
    userInfoModelBean.devType = map['devType'];
    userInfoModelBean.devToken = map['devToken'];
    userInfoModelBean.registerIP = map['registerIP'];
    userInfoModelBean.mobile = map['mobile'];
    userInfoModelBean.gender = map['gender'];
    userInfoModelBean.channel = map['channel'];
    userInfoModelBean.name = map['name'];
    userInfoModelBean.promotionCode = map['promotionCode'];
    userInfoModelBean.portrait = map['portrait'];
    userInfoModelBean.summary = map['summary'];
    userInfoModelBean.region = map['region'];
    userInfoModelBean.birthday = map['birthday'];
    userInfoModelBean.vipLevel = map['vipLevel'];
    userInfoModelBean.vipExpireDate = map['vipExpireDate'];
    userInfoModelBean.vipName = map['vipName'];
    userInfoModelBean.createdAt = map['createdAt'];
    userInfoModelBean.urrPortraitStatus = map['urrPortraitStatus'];
    userInfoModelBean.updatedAt = map['updatedAt'];
    userInfoModelBean.mobileBindAt = map['mobileBindAt'];
    userInfoModelBean.hasLocked = map['hasLocked'];
    userInfoModelBean.hasBanned = map['hasBanned'];
    userInfoModelBean.token = map['token'];
    userInfoModelBean.showProxy = map['showProxy'];
    userInfoModelBean.watchCount = map['watchCount'];
    userInfoModelBean.rechargeLevel = map['rechargeLevel'];
    userInfoModelBean.superUser = map['superUser'];
    userInfoModelBean.activeValue = map['activeValue'];
    userInfoModelBean.officialCert = map['officialCert'];
    userInfoModelBean.rewarded = map['rewarded'];
    userInfoModelBean.loginType = map['loginType'];
    userInfoModelBean.background = List()
      ..addAll((map['background'] as List ?? []).map((o) => o));
    userInfoModelBean.goldVideoCoupon = List()
      ..addAll((map['goldVideoCoupon'] as List ?? []).map((o) {
        return MyCoupon.fromJson(o);
      }));
    userInfoModelBean.webToken =
        map.containsKey("webToken") ? map["webToken"] : "";
    userInfoModelBean.role = map.containsKey("role") ? map["role"] : "";
    userInfoModelBean.level = map['level'];
    userInfoModelBean.current = map['current'];
    userInfoModelBean.limit = map['limit'];
    userInfoModelBean.goldVideoFreeExpire = map['goldVideoFreeExpire'];
    userInfoModelBean.louFengUnlockTimes = map['louFengUnlockTimes'];
    userInfoModelBean.louFengDiscount = map['louFengDiscount'];
    userInfoModelBean.appStoreCode = map['appStoreCode'];
    userInfoModelBean.lfCheatGuide = map['lfCheatGuide'];
    userInfoModelBean.videoDiscountExpiration = map['videoDiscountExpiration'];
    userInfoModelBean.videoFreeExpiration = map['videoFreeExpiration'];
    userInfoModelBean.payVidDiscount = map['payVidDiscount'];
    userInfoModelBean.happinessPlazaCount = map['happinessPlazaCount'];

    userInfoModelBean.loufengBookDiscount = map['loufengBookDiscount'];
    userInfoModelBean.loufengBookDiscountExpiration =
        map['loufengBookDiscountExpiration'];

    userInfoModelBean.beRewardCount = map['beRewardCount'];
    userInfoModelBean.downloadCount = map['downloadCount'];
    userInfoModelBean.merchantUser = map['merchantUser'];
    userInfoModelBean.urrBGStatus = map['urrBGStatus'];
    userInfoModelBean.awards = List()
      ..addAll((map['awards'] as List ?? []).map((o) => o));

    userInfoModelBean.awards?.forEach((element) {
      Config.userAwards?.forEach((element1) {
        if (element == element1?.number) {
          userInfoModelBean.awardsImage.add(element1?.imgUrl);
        }
      });
    });

    userInfoModelBean.awardsExpire = map["awardsExpire"] == null
        ? []
        : List<AwardsExpire>.from(
            map["awardsExpire"].map((x) => AwardsExpire.fromJson(x)));

    (userInfoModelBean?.awardsExpire ?? []).forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element.number == element1.number) {
          element.imageUrl = element1.imgUrl;
        }
      });
    });

    return userInfoModelBean;
  }

  static UserInfoModel fromJson(Map<String, dynamic> map) => fromMap(map);

  Map toJson() => {
        "age": age,
        "like": like,
        "follow": follow,
        "fans": fans,
        "collectionCount": collectionCount,
        "likeCount": likeCount,
        "dynamics": dynamics,
        "favoriteCount": favoriteCount,
        "isVip": isVip,
        "isFollow": isFollow,
        "promoteURL": promoteURL,
        "inviterCode": inviterCode,
        "city": city,
        "buyVidCount": buyVidCount,
        "uid": uid,
        "devID": devID,
        "devType": devType,
        "devToken": devToken,
        "registerIP": registerIP,
        "mobile": mobile,
        "gender": gender,
        "channel": channel,
        "name": name,
        "promotionCode": promotionCode,
        "portrait": portrait,
        "summary": summary,
        "region": region,
        "birthday": birthday,
        "vipLevel": vipLevel,
        "vipExpireDate": vipExpireDate,
        "vipName": vipName,
        "createdAt": createdAt,
        "urrPortraitStatus": urrPortraitStatus,
        "updatedAt": updatedAt,
        "mobileBindAt": mobileBindAt,
        "hasLocked": hasLocked,
        "hasBanned": hasBanned,
        "token": token,
        "showProxy": showProxy,
        "watchCount": watchCount,
        "webToken": webToken,
        "rewarded": rewarded,
        "role": role,
        "rechargeLevel": rechargeLevel,
        "superUser": superUser,
        "activeValue": activeValue,
        "officialCert": officialCert,
        "background": background,
        "goldVideoCoupon": goldVideoCoupon,
        "level": level,
        "current": current,
        "limit": limit,
        "loginType": loginType,
        "goldVideoFreeExpire": goldVideoFreeExpire,
        "louFengUnlockTimes": louFengUnlockTimes,
        "louFengDiscount": louFengDiscount,
        "appStoreCode": appStoreCode,
        "lfCheatGuide": lfCheatGuide,
        "videoDiscountExpiration": videoDiscountExpiration,
        "uservideoFreeExpiration": videoFreeExpiration,
        "payVidDiscount": payVidDiscount,
        "happinessPlazaCount": happinessPlazaCount,
        "beRewardCount": beRewardCount,
        "downloadCount": downloadCount,
        "awards": awards,
        "awardsExpire": awardsExpire,
        "merchantUser": merchantUser,
      };
}

class MyCoupon {
  int gold;
  int count;

  static MyCoupon fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MyCoupon myCoupon = MyCoupon();
    myCoupon.gold = map['gold'];
    myCoupon.count = map['count'];

    return myCoupon;
  }

  static MyCoupon fromJson(Map<String, dynamic> map) => fromMap(map);
}
