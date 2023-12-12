class LouFengModel {
  bool hasNext;
  List<LouFengItem> list;

  LouFengModel({this.hasNext, this.list});

  LouFengModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<LouFengItem>();
      json['list'].forEach((v) {
        list.add(new LouFengItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNext'] = this.hasNext;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LouFengItem {
  String id;
  String title;
  int number;
  String quantity;
  String age;
  String price;
  List<String> cover;
  String businessHours;
  String serviceItems;
  String city;
  String district;
  String contact;
  int contactPrice;
  String impression;
  int envStar;
  int prettyStar;
  int serviceStar;
  bool isBought;
  String businessDate;
  String broughtTime;
  bool isVerify;
  bool isCollect;
  int countPurchases;
  int countBrowse;
  int countCollect;
  String loufengType;
  String img;
  String url;
  int showTopLevel;
  int contactPriceDiscountRate;
  String details;
  int originalBookPrice;
  AgentInfo agentInfo;
  bool isBooked;

  DataDiscountCard discountCard;

  int topLevel;

  int type;

  LouFengItem(
      {this.id,
      this.title,
      this.number,
      this.quantity,
      this.age,
      this.price,
      this.cover,
      this.businessHours,
      this.serviceItems,
      this.city,
      this.district,
      this.contact,
      this.contactPrice,
      this.impression,
      this.envStar,
      this.prettyStar,
      this.serviceStar,
      this.isBought,
      this.businessDate,
      this.broughtTime,
      this.isVerify,
      this.isCollect,
      this.countPurchases,
      this.countBrowse,
      this.countCollect,
      this.loufengType,
      this.img,
      this.showTopLevel,
      this.url,
        this.agentInfo,
        this.details,
        this.originalBookPrice,
        this.discountCard,
        this.topLevel,
        this.type,
      this.contactPriceDiscountRate});

  LouFengItem.fromJson(Map<String, dynamic> json) {
    showTopLevel = json['showTopLevel'];
    id = json['id'];
    title = json['title'];
    number = json['number'];
    quantity = json['quantity'];
    age = json['age'];
    price = json['price'];
    cover = json['cover'] == null ? [] : json['cover'].cast<String>();
    businessHours = json['businessHours'];
    serviceItems = json['serviceItems'];
    city = json['city'];
    district = json['district'];
    contact = json['contact'];
    contactPrice = json['contactPrice'];
    impression = json['impression'];
    envStar = json['envStar'];
    prettyStar = json['prettyStar'];
    serviceStar = json['serviceStar'];
    isBought = json['isBought'];
    businessDate = json['businessDate'];
    broughtTime = json['BroughtTime'];
    isVerify = json['isVerify'];
    isCollect = json['isCollect'];
    countPurchases = json['countPurchases'];
    countBrowse = json['countBrowse'];
    contactPriceDiscountRate = json['contactPriceDiscountRate'] ?? 0;
    countCollect = json['countCollect'];
    loufengType = json['loufengType'];
    img = json['img'];
    url = json['url'];
    originalBookPrice = json['originalBookPrice'];
    agentInfo = AgentInfo.fromJson(json['agentInfo']);
    discountCard = json['discountCard'] == null ? new DataDiscountCard() : DataDiscountCard.fromJson(json['discountCard']);
    details = json['details'];
    isBooked = json['isBooked'];
    topLevel = json['topLevel'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['showTopLevel'] = this.showTopLevel;
    data['id'] = this.id;
    data['title'] = this.title;
    data['number'] = this.number;
    data['quantity'] = this.quantity;
    data['age'] = this.age;
    data['price'] = this.price;
    data['cover'] = this.cover;
    data['businessHours'] = this.businessHours;
    data['serviceItems'] = this.serviceItems;
    data['city'] = this.city;
    data['district'] = this.district;
    data['contact'] = this.contact;
    data['contactPrice'] = this.contactPrice;
    data['impression'] = this.impression;
    data['envStar'] = this.envStar;
    data['prettyStar'] = this.prettyStar;
    data['serviceStar'] = this.serviceStar;
    data['isBought'] = this.isBought;
    data['businessDate'] = this.businessDate;
    data['BroughtTime'] = this.broughtTime;
    data['isVerify'] = this.isVerify;
    data['isCollect'] = this.isCollect;
    data['countPurchases'] = this.countPurchases;
    data['countBrowse'] = this.countBrowse;
    data['countCollect'] = this.countCollect;
    data['loufengType'] = this.loufengType;
    data['contactPriceDiscountRate'] = this.contactPriceDiscountRate;
    data['img'] = this.img;
    data['url'] = this.url;
    data['originalBookPrice'] = this.originalBookPrice;
    data['agentInfo'] = this.agentInfo;
    data['details'] = this.details;

    return data;
  }
}



class AgentInfo {
  AgentInfo({
    this.id,
    this.account,
    this.status,
    this.name,
    this.avatar,
    this.payable,
    this.deposit,
    this.introduce,
    this.following,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String account;
  int status;
  String name;
  String avatar;
  bool payable;
  int deposit;
  String introduce;
  bool following;
  DateTime createdAt;
  DateTime updatedAt;

  factory AgentInfo.fromJson(Map<String, dynamic> json) => AgentInfo(
    id: json["id"],
    account: json["account"],
    status: json["status"],
    name: json["name"],
    avatar: json["avatar"],
    payable: json["payable"],
    deposit: json["deposit"],
    introduce: json["introduce"],
    following: json["following"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "account": account,
    "status": status,
    "name": name,
    "avatar": avatar,
    "payable": payable,
    "deposit": deposit,
    "introduce": introduce,
    "following": following,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}


class DataDiscountCard {
  DataDiscountCard({
    this.productId,
    this.vipLevel,
    this.productName,
    this.alias,
    this.desc,
    this.duration,
    this.bgImg,
    this.originalPrice,
    this.discountedPrice,
    this.discountedPriceIos,
    this.discountedPriceAnd,
    this.productType,
    this.sort,
    this.status,
    this.position,
    this.unitPriceDisplay,
    this.actionDesc,
    this.privilegeDesc,
    this.showCountdownTime,
    this.isAmountPay,
    this.timesAWeek,
    this.louFengDiscount,
    this.loufengBookDiscount,
    this.loufengBookDiscountDays,
    this.videoDiscount,
    this.privilege,
    this.giveCoin,
    this.giveFruitCoin,
    this.giveGameCoin,
    this.louFengUnlockTimes,
    this.goldVideoFreeDay,
    this.chanSplitMod,
    this.serviceTime,
    this.payVidDiscount,
    this.goldVideoCouponNum,
    this.goldVideoCouponCount,
    this.updatedAt,
    this.createdAt,
    this.discountCard,
  });

  String productId;
  int vipLevel;
  String productName;
  String alias;
  String desc;
  int duration;
  String bgImg;
  int originalPrice;
  int discountedPrice;
  int discountedPriceIos;
  int discountedPriceAnd;
  int productType;
  int sort;
  bool status;
  String position;
  bool unitPriceDisplay;
  String actionDesc;
  String privilegeDesc;
  int showCountdownTime;
  bool isAmountPay;
  int timesAWeek;
  int louFengDiscount;
  int loufengBookDiscount;
  int loufengBookDiscountDays;
  int videoDiscount;
  List<int> privilege;
  int giveCoin;
  int giveFruitCoin;
  int giveGameCoin;
  int louFengUnlockTimes;
  int goldVideoFreeDay;
  int chanSplitMod;
  int serviceTime;
  int payVidDiscount;
  int goldVideoCouponNum;
  int goldVideoCouponCount;
  DateTime updatedAt;
  DateTime createdAt;
  DiscountCardDiscountCard discountCard;

  factory DataDiscountCard.fromJson(Map<String, dynamic> json) => DataDiscountCard(
    productId: json["productID"],
    vipLevel: json["vipLevel"],
    productName: json["productName"],
    alias: json["alias"],
    desc: json["desc"],
    duration: json["duration"],
    bgImg: json["bgImg"],
    originalPrice: json["originalPrice"],
    discountedPrice: json["discountedPrice"],
    discountedPriceIos: json["discountedPriceIos"],
    discountedPriceAnd: json["discountedPriceAnd"],
    productType: json["productType"],
    sort: json["sort"],
    status: json["status"],
    position: json["position"],
    unitPriceDisplay: json["unitPriceDisplay"],
    actionDesc: json["actionDesc"],
    privilegeDesc: json["privilegeDesc"],
    showCountdownTime: json["showCountdownTime"],
    isAmountPay: json["isAmountPay"],
    timesAWeek: json["timesAWeek"],
    louFengDiscount: json["louFengDiscount"],
    loufengBookDiscount: json["loufengBookDiscount"],
    loufengBookDiscountDays: json["loufengBookDiscountDays"],
    videoDiscount: json["videoDiscount"],
    privilege: List<int>.from(json["privilege"].map((x) => x)),
    giveCoin: json["giveCoin"],
    giveFruitCoin: json["giveFruitCoin"],
    giveGameCoin: json["giveGameCoin"],
    louFengUnlockTimes: json["louFengUnlockTimes"],
    goldVideoFreeDay: json["goldVideoFreeDay"],
    chanSplitMod: json["chanSplitMod"],
    serviceTime: json["serviceTime"],
    payVidDiscount: json["payVidDiscount"],
    goldVideoCouponNum: json["goldVideoCouponNum"],
    goldVideoCouponCount: json["goldVideoCouponCount"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    discountCard: DiscountCardDiscountCard.fromJson(json["discountCard"]),
  );

  Map<String, dynamic> toJson() => {
    "productID": productId,
    "vipLevel": vipLevel,
    "productName": productName,
    "alias": alias,
    "desc": desc,
    "duration": duration,
    "bgImg": bgImg,
    "originalPrice": originalPrice,
    "discountedPrice": discountedPrice,
    "discountedPriceIos": discountedPriceIos,
    "discountedPriceAnd": discountedPriceAnd,
    "productType": productType,
    "sort": sort,
    "status": status,
    "position": position,
    "unitPriceDisplay": unitPriceDisplay,
    "actionDesc": actionDesc,
    "privilegeDesc": privilegeDesc,
    "showCountdownTime": showCountdownTime,
    "isAmountPay": isAmountPay,
    "timesAWeek": timesAWeek,
    "louFengDiscount": louFengDiscount,
    "loufengBookDiscount": loufengBookDiscount,
    "loufengBookDiscountDays": loufengBookDiscountDays,
    "videoDiscount": videoDiscount,
    "privilege": List<dynamic>.from(privilege.map((x) => x)),
    "giveCoin": giveCoin,
    "giveFruitCoin": giveFruitCoin,
    "giveGameCoin": giveGameCoin,
    "louFengUnlockTimes": louFengUnlockTimes,
    "goldVideoFreeDay": goldVideoFreeDay,
    "chanSplitMod": chanSplitMod,
    "serviceTime": serviceTime,
    "payVidDiscount": payVidDiscount,
    "goldVideoCouponNum": goldVideoCouponNum,
    "goldVideoCouponCount": goldVideoCouponCount,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "discountCard": discountCard.toJson(),
  };
}


class DiscountCardDiscountCard {
  DiscountCardDiscountCard({
    this.isReceived,
    this.expiration,
    this.expirationTime,
    this.isBrought,
  });

  bool isReceived;
  DateTime expiration;
  String expirationTime;
  bool isBrought;

  factory DiscountCardDiscountCard.fromJson(Map<String, dynamic> json) => DiscountCardDiscountCard(
    isReceived: json["isReceived"],
    expiration: DateTime.parse(json["expiration"]),
    expirationTime: json["expirationTime"],
    isBrought: json["isBrought"],
  );

  Map<String, dynamic> toJson() => {
    "isReceived": isReceived,
    "expiration": expiration.toIso8601String(),
    "expirationTime": expirationTime,
    "isBrought": isBrought,
  };
}
