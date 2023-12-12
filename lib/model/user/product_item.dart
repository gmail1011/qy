import '../recharge_type_list_model.dart';

class ProductItemBean {
  String productID;
  int vipLevel;
  String productName;
  String alias;
  String desc;
  int duration;
  String bgImg;
  int originalPrice;
  int discountedPrice;
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
  String updatedAt;
  String createdAt;
  String tag;
  LoufengCard loufengCard;
  List<RechargeTypeBean> rchgType;
  List<Privilege> newPrivilege;

  int giveCoin;
  int giveGameCoin;
  int louFengUnlockTimes;
  int goldVideoFreeDay;

  String details;

  int louFengDiscount;

  ProductItemBean({
    this.productID,
    this.vipLevel,
    this.productName,
    this.alias,
    this.desc,
    this.duration,
    this.bgImg,
    this.originalPrice,
    this.discountedPrice,
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
    this.updatedAt,
    this.createdAt,
    this.tag,
    this.rchgType,
    this.newPrivilege,
    this.loufengCard,
    this.giveCoin,
    this.giveGameCoin,
    this.louFengUnlockTimes,
    this.goldVideoFreeDay,
    this.details,
    this.louFengDiscount,
  });

  ProductItemBean.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    vipLevel = json['vipLevel'];
    productName = json['productName'];
    alias = json['alias'];
    desc = json['desc'];
    duration = json['duration'];
    bgImg = json['bgImg'];
    originalPrice = json['originalPrice'];
    discountedPrice = json['discountedPrice'];
    discountedPriceAnd = json['discountedPriceAnd'];
    productType = json['productType'];
    sort = json['sort'];
    status = json['status'];
    position = json['position'];
    unitPriceDisplay = json['unitPriceDisplay'];
    actionDesc = json['actionDesc'];
    privilegeDesc = json['privilegeDesc'];
    showCountdownTime = json['showCountdownTime'];
    isAmountPay = json['isAmountPay'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    tag = json['tag'];

    giveCoin = json['giveCoin'];
    giveGameCoin = json['giveGameCoin'];
    louFengUnlockTimes = json['louFengUnlockTimes'];
    goldVideoFreeDay = json['goldVideoFreeDay'];
    details = json['details'];

    louFengDiscount = json['louFengDiscount'];

    if (json['rchgType'] != null) {
      rchgType = new List<RechargeTypeBean>();
      json['rchgType'].forEach((v) {
        rchgType.add(RechargeTypeBean.fromMap(v));
      });
    }
    newPrivilege = new List<Privilege>();
    if (json['newPrivilege'] != null) {
      json['newPrivilege'].forEach((v) {
        newPrivilege.add(Privilege.fromMap(v));
      });
    }
    loufengCard = json['discountCard'] != null
        ? new LoufengCard.fromJson(json['discountCard'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productID'] = this.productID;
    data['vipLevel'] = this.vipLevel;
    data['productName'] = this.productName;
    data['alias'] = this.alias;
    data['desc'] = this.desc;
    data['duration'] = this.duration;
    data['bgImg'] = this.bgImg;
    data['originalPrice'] = this.originalPrice;
    data['discountedPrice'] = this.discountedPrice;
    data['productType'] = this.productType;
    data['sort'] = this.sort;
    data['status'] = this.status;
    data['position'] = this.position;
    data['unitPriceDisplay'] = this.unitPriceDisplay;
    data['actionDesc'] = this.actionDesc;
    data['privilegeDesc'] = this.privilegeDesc;
    data['showCountdownTime'] = this.showCountdownTime;
    data['isAmountPay'] = this.isAmountPay;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['tag'] = this.tag;

    data['giveCoin'] = this.giveCoin;
    data['giveGameCoin'] = this.giveGameCoin;
    data['louFengUnlockTimes'] = this.louFengUnlockTimes;
    data['goldVideoFreeDay'] = this.goldVideoFreeDay;
    data['details'] = this.details;
    if (this.rchgType != null) {
      data['rchgType'] = this.rchgType.map((v) => v.toJson()).toList();
    }
    if (this.newPrivilege != null) {
      data['newPrivilege'] = this.newPrivilege.map((v) => v.toJson()).toList();
    }
    if (this.loufengCard != null) {
      data['discountCard'] = this.loufengCard.toJson();
    }
    return data;
  }
}

class LoufengCard {
  bool isReceived;
  String expiration;
  String expirationTime;
  bool isBrought;

  LoufengCard(
      {this.isReceived, this.expiration, this.expirationTime, this.isBrought});

  LoufengCard.fromJson(Map<String, dynamic> json) {
    isReceived = json['isReceived'];
    expiration = json['expiration'];
    expirationTime = json['expirationTime'];
    isBrought = json['isBrought'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isReceived'] = this.isReceived;
    data['expiration'] = this.expiration;
    data['expirationTime'] = this.expirationTime;
    data['isBrought'] = this.isBrought;
    return data;
  }
}
