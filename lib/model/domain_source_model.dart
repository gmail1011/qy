import 'package:flutter_app/model/announcement_entity.dart';
import 'package:flutter_app/model/video_model.dart';

import 'ads_model.dart';

class DomainSourceModel {
  AdsBean ads;
  List<String> domain;
  List<SourceBean> source;
  List<SourceBeanList> sourceList;
  List<CheckVersionBean> ver;
  List<AnnouncementEntity> systemConfigList;
  int totalWatch;
  String louFengH5;
  List<int> rewardMoney;
  List<int> releaseMoney;
  List<UserAwards> userAwards;
  List<ProductBenefits> productBenefits;
  List<OfficeConfigList> officeConfigLists;
  List<PopsBean> pops;
  List<VideoModel> hotPush;
  List<QuickSearch> quickSearch;
  bool playGame;
  String aiUndressPrice;
  String luckyDrawH5;
  String videoCollectionPrice;
  bool followNewsStatus;
  bool messageNewsStatus;
  int sendMsgPrice;
  String get domainBuried {
    String buriedUrl = "";
    source?.forEach((element) {
        if(element.type == "DataBuried"){
          buriedUrl = element.domain;
          return;
        }
    });
    return buriedUrl;
  }

  static DomainSourceModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    DomainSourceModel domainSourceModelBean = DomainSourceModel();
    if (map.containsKey('ads')) {
      domainSourceModelBean.ads = AdsBean.fromMap(map['ads']);
    }
    if (map.containsKey('domain')) {
      domainSourceModelBean.domain = List()
        ..addAll((map['domain'] as List ?? []).map((o) => o.toString()));
    }
    if (map.containsKey('sourceList')) {
      domainSourceModelBean.sourceList = List()
        ..addAll(
            (map['sourceList'] as List ?? []).map((o) => SourceBeanList.fromMap(o)));
    }

    if (map.containsKey('source')) {
      domainSourceModelBean.source = List()
        ..addAll(
            (map['source'] as List ?? []).map((o) => SourceBean.fromMap(o)));
    }
    if (map.containsKey('ver')) {
      domainSourceModelBean.ver = List()
        ..addAll(
            (map['ver'] as List ?? []).map((o) => CheckVersionBean.fromMap(o)));
    }
    if (map.containsKey('userAwards')) {
      domainSourceModelBean.userAwards = List()
        ..addAll((map['userAwards'] as List ?? [])
            .map((o) => UserAwards.fromMap(o)));
    }

    if (map.containsKey('productBenefits')) {
      domainSourceModelBean.productBenefits = List()
        ..addAll((map['productBenefits'] as List ?? [])
            .map((o) => ProductBenefits.fromMap(o)));
    }
    if (map.containsKey('officeConfigList')) {
      domainSourceModelBean.officeConfigLists = List()
        ..addAll((map['officeConfigList'] as List ?? [])
            .map((o) => OfficeConfigList.fromMap(o)));
    }

    if (map.containsKey('pops')) {
      domainSourceModelBean.pops = List()
        ..addAll((map['pops'] as List ?? []).map((o) => PopsBean.fromMap(o)));
    }

    if (map.containsKey('systemConfigList')) {
      domainSourceModelBean.systemConfigList = List()
        ..addAll((map['systemConfigList'] as List ?? [])
            .map((o) => AnnouncementEntity().fromJson(o)));
    }
    if (map['hotPush'] is List) {
      domainSourceModelBean.hotPush = List()
        ..addAll((map['hotPush'] as List ?? [])
            .map((o) => VideoModel.fromJson(o)));
    }
    if (map['quickSearch'] is List) {
      domainSourceModelBean.quickSearch = List()
        ..addAll((map['quickSearch'] as List ?? [])
            .map((o) => QuickSearch.fromMap(o)));
    }

    if (map.containsKey('rewardMoney')) {
      domainSourceModelBean.rewardMoney = List()
        ..addAll((map['rewardMoney'] as List ?? []).map((o) => o));
    }

    if (map.containsKey('releaseMoney')) {
      domainSourceModelBean.releaseMoney = List()
        ..addAll((map['releaseMoney'] as List ?? []).map((o) => o));
    }


    if (map.containsKey('louFengH5')) {
      domainSourceModelBean.louFengH5 = map['louFengH5'];
    }

    if (map.containsKey('luckyDrawH5')) {
      domainSourceModelBean.luckyDrawH5 = map['luckyDrawH5'];
    }

    if (map.containsKey('playGame')) {
      domainSourceModelBean.playGame = map['playGame'];
    }

    domainSourceModelBean.totalWatch = map['totalWatch'];
    // domainSourceModelBean.videoCollectionPrice = map['videoCollectionPrice']?.toString();
    domainSourceModelBean.aiUndressPrice = map['aiUndressPrice']?.toString();
    // domainSourceModelBean.followNewsStatus = map['followNewsStatus'];
    // domainSourceModelBean.messageNewsStatus = map['messageNewsStatus'];
    domainSourceModelBean.sendMsgPrice = map['sendMsgPrice'];
    return domainSourceModelBean;
  }

  Map toJson() => {
        "ads": ads,
        "domain": domain,
        "source": source,
        "ver": ver,
        "userAwards": userAwards,
        "productBenefits": productBenefits,
        "pops": pops,
        "systemConfigList": systemConfigList,
        "totalWatch": totalWatch,
        "rewardMoney": rewardMoney,
        "releaseMoney": releaseMoney,
        "louFengH5": louFengH5,
        "luckyDrawH5": luckyDrawH5,
        "playGame": playGame,
        "videoCollectionPrice": videoCollectionPrice,
        'aiUndressPrice':aiUndressPrice,
      };
}

class QuickSearch {
  String id;
  String title;
  String searchKeyword;
  String videoID;
  String link;
  bool enable;
  String createdAt;
  String updatedAt;
  static QuickSearch fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    QuickSearch sourceBean = QuickSearch();
    sourceBean.id = map['id'];
    sourceBean.title = map['title'];
    sourceBean.searchKeyword = map['searchKeyword'];
    sourceBean.videoID = map['videoID'];
    sourceBean.link = map['link'];
    sourceBean.enable = map['enable'];
    sourceBean.createdAt = map['createdAt'];
    sourceBean.updatedAt = map['updatedAt'];
    return sourceBean;
  }

  Map toJson() => {
    "id": id,
    "title": title,
    "searchKeyword": searchKeyword,
    "videoID": videoID,
    "link": link,
    "enable": enable,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}


class SourceBean {
  String id;
  String domain;
  bool isActive;
  String type;

  static SourceBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SourceBean sourceBean = SourceBean();
    sourceBean.id = map['id'];
    sourceBean.domain = map['domain'];
    sourceBean.isActive = map['isActive'];
    sourceBean.type = map['type'];
    return sourceBean;
  }

  Map toJson() => {
    "id": id,
    "domain": domain,
    "isActive": isActive,
    "type": type,
  };
}


class DomainInfo {
  int  weight;
  String url;
  int  status;
  String desc;
  static DomainInfo fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    DomainInfo domainInfo = DomainInfo();
    domainInfo.weight =  map['weight'];
    domainInfo.url =  map['url'];
    domainInfo.status =  map['status'];
    domainInfo.desc = map['desc'];
    return domainInfo;
  }
}

class SourceBeanList {
  String id;
  List<DomainInfo> domain;
  bool isActive;
  String type;


  static SourceBeanList fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SourceBeanList sourceBeanList = SourceBeanList();
    sourceBeanList.id = map['id'];
    List<DomainInfo> list=[];
    map['domain'].forEach((element) {
      DomainInfo dataItem = DomainInfo.fromJson(element);
      list.add(dataItem);
    });
    sourceBeanList.domain = list;
    sourceBeanList.isActive = map['isActive'];
    sourceBeanList.type = map['type'];
    return sourceBeanList;
  }

  Map toJson() => {
    "id": id,
    "domain": domain,
    "isActive": isActive,
    "type": type,
  };
}



class UserAwards {
  int number;
  String desc;
  String imgUrl;

  static UserAwards fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserAwards sourceBean = UserAwards();
    sourceBean.number = map['number'];
    sourceBean.desc = map['desc'];
    sourceBean.imgUrl = map['imgUrl'];
    return sourceBean;
  }

  Map toJson() => {
        "number": number,
        "desc": desc,
        "imgUrl": imgUrl,
      };
}

class CheckVersionBean {
  String description;
  bool forcedUpdate;
  String platform;
  String url;
  String verName;
  int code;

  static CheckVersionBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CheckVersionBean checkVersionBean = CheckVersionBean();
    checkVersionBean.description = map['description'];
    checkVersionBean.forcedUpdate = map['forcedUpdate'];
    checkVersionBean.platform = map['platform'];
    checkVersionBean.url = map['url'];
    checkVersionBean.verName = map['verName'];
    checkVersionBean.code = map['Code'];
    return checkVersionBean;
  }

  static List<CheckVersionBean> toList(List<dynamic> mapList) {
    List<CheckVersionBean> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromMap(current));
    }
    return list;
  }

  Map toJson() => {
        "description": description,
        "forcedUpdate": forcedUpdate,
        "platform": platform,
        "url": url,
        "verName": verName,
        "Code": code,
      };
}

class AdsBean {
  List<AdsInfoBean> adsInfoList;

  List<AdsInfoBean> get adsRandomList {
    List<AdsInfoBean> ads = [];
    adsInfoList?.forEach((element) {
      if (element.position == 8){ // 10 横屏 是随机广告
        ads.add(element);
      }
    });
    return ads;
  }



  List<AdsInfoBean> get adsVerRandomList {
    List<AdsInfoBean> ads = [];
    adsInfoList?.forEach((element) {
      if (element.position == 9){ // 11 竖屏 是随机广告
        ads.add(element);
      }
    });
    return ads;
  }

  List<AdsInfoBean> get adsCommunityList {
    List<AdsInfoBean> ads = [];
    adsInfoList?.forEach((element) {
      if (element.position == 12){ // 12 社区 是随机广告
        ads.add(element);
      }
    });
    return ads;
  }

  List<AdsInfoBean> get adsVideoTabList {
    List<AdsInfoBean> ads = [];
    adsInfoList?.forEach((element) {
      if (element.position == 13){ // 12 社区 是随机广告
        ads.add(element);
      }
    });
    return ads;
  }

  // 文本公告
  List<AnnounceInfoBean> announInfo;

  ///多个公告
  List<AnnounceInfoBean> announList;

  static AdsBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AdsBean adsBean = AdsBean();
    adsBean.announInfo = List()
      ..addAll((map['announInfo'] as List ?? [])
          .map((o) => AnnounceInfoBean.fromJson(o)));
    adsBean.announList = List()
      ..addAll((map['announList'] as List ?? [])
          .map((o) => AnnounceInfoBean.fromJson(o)));
    adsBean.adsInfoList = List()
      ..addAll((map['adsInfoList'] as List ?? [])
          .map((o) => AdsInfoBean.fromMap(o)));
    return adsBean;
  }

  Map toJson() => {
        "announInfo": announInfo,
      };
}

/// id : "5dc0ed5e89b760370dc618af"
/// title : "5折优惠活动"
/// content : "1.邀请1人获得3天无限观看权限，无限叠加。可独享超棒会员片库。\n2.分享转发3个微信群、QQ群、微博、陌陌等社交平台，联系客服反馈发出截图，领取5天无限观看权限。    \n代理客服甜甜女士 QQ:2642215486"
/// cover : ""
/// href : ""
/// type : 0

class AnnounceInfoBean {
  String content;
  String cover;
  String href; //图片公告点击时跳转的地址
  int type; //0:系统公告 1：图片公告,3,活动公告
  String title;

  static AnnounceInfoBean fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    AnnounceInfoBean announceInfoBean = AnnounceInfoBean();
    announceInfoBean.content = map['content'];
    announceInfoBean.cover = map['cover'];
    announceInfoBean.href = map['href'];
    announceInfoBean.type = map['type'];
    announceInfoBean.title = map['title'];
    return announceInfoBean;
  }

  Map toJson() => {
        "content": content,
        "cover": cover,
        "href": href,
        "type": type,
        "title": title,
      };
}

class ProductBenefits {
  String id;
  String img;
  String privilegeName;
  String privilegeDesc;
  String updatedAt;
  String createdAt;

  static ProductBenefits fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ProductBenefits sourceBean = ProductBenefits();
    sourceBean.id = map['id'];
    sourceBean.img = map['img'];
    sourceBean.privilegeName = map['privilegeName'];
    sourceBean.privilegeDesc = map['privilegeDesc'];
    sourceBean.updatedAt = map['updatedAt'];
    sourceBean.createdAt = map['createdAt'];
    return sourceBean;
  }

  Map toJson() => {
        "id": id,
        "img": img,
        "privilegeName": privilegeName,
        "privilegeDesc": privilegeDesc,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
      };
}class

OfficeConfigList {
  String officialDesc;
  String officialImg;
  String officialName;
  String officialType;
  String officialUrl;

  static OfficeConfigList fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    OfficeConfigList officeConBean = OfficeConfigList();
    officeConBean.officialDesc = map['officialDesc'];
    officeConBean.officialImg = map['officialImg'];
    officeConBean.officialName = map['officialName'];
    officeConBean.officialType = map['officialType'];
    officeConBean.officialUrl = map['officialUrl'];
    return officeConBean;
  }

  Map toJson() => {
        "officialDesc": officialDesc,
        "officialImg": officialImg,
        "officialName": officialName,
        "officialType": officialType,
        "officialUrl": officialUrl,
      };
}

class PopsBean {
  String id;
  String popBackgroundImage;

  static PopsBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PopsBean popsBean = PopsBean();
    popsBean.id = map['id'];
    popsBean.popBackgroundImage = map['popBackgroundImage'];
    return popsBean;
  }

  Map toJson() => {
        "id": id,
        "popBackgroundImage": popBackgroundImage,
      };
}
