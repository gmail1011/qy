
/// hasNext : false
/// list : [{"id":"650a6ea8f317316b6fa0f041","uid":300738,"purchaseOrder":"650a6e33f317316b6fa0f026","productID":null,"amount":310,"integral":0,"realIntegral":"0","actualIntegral":0,"actualAmount":310,"tax":0,"taxAmount":0,"channelType":"alipay","tranType":"官方充值","tranTypeInt":12,"performance":0,"rechargeId":0,"rechargeUser":{"uid":0,"name":"","portrait":""},"desc":"官方充值-到账310金币","createdAt":"2023-09-20T12:01:44.308+08:00","sysType":"android","agentLevel":0,"vipLevel":0,"realAmount":"310","money":"0","wlRealAmount":"0","fruitCoin":0,"fruitCoinBalance":0,"districtCode":"","promSeqe":"","isDirect":true,"DiscBindAt":"2023-09-18T21:05:29.037+08:00"}]

class InComeEntityModel {
  InComeEntityModel({
    bool hasNext,
    List<InComeEntity> list,}){
    _hasNext = hasNext;
    _list = list;
  }

  InComeEntityModel.fromJson(dynamic json) {
    _hasNext = json['hasNext'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(InComeEntity.fromJson(v));
      });
    }
  }
  bool _hasNext;
  List<InComeEntity> _list;
  InComeEntityModel copyWith({  bool hasNext,
    List<InComeEntity> list,
  }) => InComeEntityModel(  hasNext: hasNext ?? _hasNext,
    list: list ?? _list,
  );
  bool get hasNext => _hasNext;
  List<InComeEntity> get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasNext'] = _hasNext;
    if (_list != null) {
      map['list'] = _list.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "650a6ea8f317316b6fa0f041"
/// uid : 300738
/// purchaseOrder : "650a6e33f317316b6fa0f026"
/// productID : null
/// amount : 310
/// integral : 0
/// realIntegral : "0"
/// actualIntegral : 0
/// actualAmount : 310
/// tax : 0
/// taxAmount : 0
/// channelType : "alipay"
/// tranType : "官方充值"
/// tranTypeInt : 12
/// performance : 0
/// rechargeId : 0
/// rechargeUser : {"uid":0,"name":"","portrait":""}
/// desc : "官方充值-到账310金币"
/// createdAt : "2023-09-20T12:01:44.308+08:00"
/// sysType : "android"
/// agentLevel : 0
/// vipLevel : 0
/// realAmount : "310"
/// money : "0"
/// wlRealAmount : "0"
/// fruitCoin : 0
/// fruitCoinBalance : 0
/// districtCode : ""
/// promSeqe : ""
/// isDirect : true
/// DiscBindAt : "2023-09-18T21:05:29.037+08:00"

class InComeEntity {
  InComeEntity({
    String id,
    num uid,
    String purchaseOrder,
    dynamic productID,
    num amount,
    num integral,
    String realIntegral,
    num actualIntegral,
    num actualAmount,
    num tax,
    num taxAmount,
    String channelType,
    String tranType,
    num tranTypeInt,
    num performance,
    num rechargeId,
    RechargeUser rechargeUser,
    String desc,
    String createdAt,
    String sysType,
    num agentLevel,
    num vipLevel,
    String realAmount,
    String money,
    String wlRealAmount,
    num fruitCoin,
    num fruitCoinBalance,
    String districtCode,
    String promSeqe,
    bool isDirect,
    String discBindAt,}){
    _id = id;
    _uid = uid;
    _purchaseOrder = purchaseOrder;
    _productID = productID;
    _amount = amount;
    _integral = integral;
    _realIntegral = realIntegral;
    _actualIntegral = actualIntegral;
    _actualAmount = actualAmount;
    _tax = tax;
    _taxAmount = taxAmount;
    _channelType = channelType;
    _tranType = tranType;
    _tranTypeInt = tranTypeInt;
    _performance = performance;
    _rechargeId = rechargeId;
    _rechargeUser = rechargeUser;
    _desc = desc;
    _createdAt = createdAt;
    _sysType = sysType;
    _agentLevel = agentLevel;
    _vipLevel = vipLevel;
    _realAmount = realAmount;
    _money = money;
    _wlRealAmount = wlRealAmount;
    _fruitCoin = fruitCoin;
    _fruitCoinBalance = fruitCoinBalance;
    _districtCode = districtCode;
    _promSeqe = promSeqe;
    _isDirect = isDirect;
    _discBindAt = discBindAt;
  }

  InComeEntity.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _purchaseOrder = json['purchaseOrder'];
    _productID = json['productID'];
    _amount = json['amount'];
    _integral = json['integral'];
    _realIntegral = json['realIntegral'];
    _actualIntegral = json['actualIntegral'];
    _actualAmount = json['actualAmount'];
    _tax = json['tax'];
    _taxAmount = json['taxAmount'];
    _channelType = json['channelType'];
    _tranType = json['tranType'];
    _tranTypeInt = json['tranTypeInt'];
    _performance = json['performance'];
    _rechargeId = json['rechargeId'];
    _rechargeUser = json['rechargeUser'] != null ? RechargeUser.fromJson(json['rechargeUser']) : null;
    _desc = json['desc'];
    _createdAt = json['createdAt'];
    _sysType = json['sysType'];
    _agentLevel = json['agentLevel'];
    _vipLevel = json['vipLevel'];
    _realAmount = json['realAmount'];
    _money = json['money'];
    _wlRealAmount = json['wlRealAmount'];
    _fruitCoin = json['fruitCoin'];
    _fruitCoinBalance = json['fruitCoinBalance'];
    _districtCode = json['districtCode'];
    _promSeqe = json['promSeqe'];
    _isDirect = json['isDirect'];
    _discBindAt = json['DiscBindAt'];
  }
  String _id;
  num _uid;
  String _purchaseOrder;
  dynamic _productID;
  num _amount;
  num _integral;
  String _realIntegral;
  num _actualIntegral;
  num _actualAmount;
  num _tax;
  num _taxAmount;
  String _channelType;
  String _tranType;
  num _tranTypeInt;
  num _performance;
  num _rechargeId;
  RechargeUser _rechargeUser;
  String _desc;
  String _createdAt;
  String _sysType;
  num _agentLevel;
  num _vipLevel;
  String _realAmount;
  String _money;
  String _wlRealAmount;
  num _fruitCoin;
  num _fruitCoinBalance;
  String _districtCode;
  String _promSeqe;
  bool _isDirect;
  String _discBindAt;
  InComeEntity copyWith({  String id,
    num uid,
    String purchaseOrder,
    dynamic productID,
    num amount,
    num integral,
    String realIntegral,
    num actualIntegral,
    num actualAmount,
    num tax,
    num taxAmount,
    String channelType,
    String tranType,
    num tranTypeInt,
    num performance,
    num rechargeId,
    RechargeUser rechargeUser,
    String desc,
    String createdAt,
    String sysType,
    num agentLevel,
    num vipLevel,
    String realAmount,
    String money,
    String wlRealAmount,
    num fruitCoin,
    num fruitCoinBalance,
    String districtCode,
    String promSeqe,
    bool isDirect,
    String discBindAt,
  }) => InComeEntity(  id: id ?? _id,
    uid: uid ?? _uid,
    purchaseOrder: purchaseOrder ?? _purchaseOrder,
    productID: productID ?? _productID,
    amount: amount ?? _amount,
    integral: integral ?? _integral,
    realIntegral: realIntegral ?? _realIntegral,
    actualIntegral: actualIntegral ?? _actualIntegral,
    actualAmount: actualAmount ?? _actualAmount,
    tax: tax ?? _tax,
    taxAmount: taxAmount ?? _taxAmount,
    channelType: channelType ?? _channelType,
    tranType: tranType ?? _tranType,
    tranTypeInt: tranTypeInt ?? _tranTypeInt,
    performance: performance ?? _performance,
    rechargeId: rechargeId ?? _rechargeId,
    rechargeUser: rechargeUser ?? _rechargeUser,
    desc: desc ?? _desc,
    createdAt: createdAt ?? _createdAt,
    sysType: sysType ?? _sysType,
    agentLevel: agentLevel ?? _agentLevel,
    vipLevel: vipLevel ?? _vipLevel,
    realAmount: realAmount ?? _realAmount,
    money: money ?? _money,
    wlRealAmount: wlRealAmount ?? _wlRealAmount,
    fruitCoin: fruitCoin ?? _fruitCoin,
    fruitCoinBalance: fruitCoinBalance ?? _fruitCoinBalance,
    districtCode: districtCode ?? _districtCode,
    promSeqe: promSeqe ?? _promSeqe,
    isDirect: isDirect ?? _isDirect,
    discBindAt: discBindAt ?? _discBindAt,
  );
  String get id => _id;
  num get uid => _uid;
  String get purchaseOrder => _purchaseOrder;
  dynamic get productID => _productID;
  num get amount => _amount;
  num get integral => _integral;
  String get realIntegral => _realIntegral;
  num get actualIntegral => _actualIntegral;
  num get actualAmount => _actualAmount;
  num get tax => _tax;
  num get taxAmount => _taxAmount;
  String get channelType => _channelType;
  String get tranType => _tranType;
  num get tranTypeInt => _tranTypeInt;
  num get performance => _performance;
  num get rechargeId => _rechargeId;
  RechargeUser get rechargeUser => _rechargeUser;
  String get desc => _desc;
  String get createdAt => _createdAt;
  String get sysType => _sysType;
  num get agentLevel => _agentLevel;
  num get vipLevel => _vipLevel;
  String get realAmount => _realAmount;
  String get money => _money;
  String get wlRealAmount => _wlRealAmount;
  num get fruitCoin => _fruitCoin;
  num get fruitCoinBalance => _fruitCoinBalance;
  String get districtCode => _districtCode;
  String get promSeqe => _promSeqe;
  bool get isDirect => _isDirect;
  String get discBindAt => _discBindAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['purchaseOrder'] = _purchaseOrder;
    map['productID'] = _productID;
    map['amount'] = _amount;
    map['integral'] = _integral;
    map['realIntegral'] = _realIntegral;
    map['actualIntegral'] = _actualIntegral;
    map['actualAmount'] = _actualAmount;
    map['tax'] = _tax;
    map['taxAmount'] = _taxAmount;
    map['channelType'] = _channelType;
    map['tranType'] = _tranType;
    map['tranTypeInt'] = _tranTypeInt;
    map['performance'] = _performance;
    map['rechargeId'] = _rechargeId;
    if (_rechargeUser != null) {
      map['rechargeUser'] = _rechargeUser.toJson();
    }
    map['desc'] = _desc;
    map['createdAt'] = _createdAt;
    map['sysType'] = _sysType;
    map['agentLevel'] = _agentLevel;
    map['vipLevel'] = _vipLevel;
    map['realAmount'] = _realAmount;
    map['money'] = _money;
    map['wlRealAmount'] = _wlRealAmount;
    map['fruitCoin'] = _fruitCoin;
    map['fruitCoinBalance'] = _fruitCoinBalance;
    map['districtCode'] = _districtCode;
    map['promSeqe'] = _promSeqe;
    map['isDirect'] = _isDirect;
    map['DiscBindAt'] = _discBindAt;
    return map;
  }

}

/// uid : 300788
/// name : "水喜淳"
/// portrait : "image/it/m9/nk/1a/8428292ff0dc416189e0443d3f441fe5.jpeg"

class RechargeUser {
  RechargeUser({
    num uid,
    String name,
    String portrait,}){
    _uid = uid;
    _name = name;
    _portrait = portrait;
  }

  RechargeUser.fromJson(dynamic json) {
    _uid = json['uid'];
    _name = json['name'];
    _portrait = json['portrait'];
  }
  num _uid;
  String _name;
  String _portrait;
  RechargeUser copyWith({  num uid,
    String name,
    String portrait,
  }) => RechargeUser(  uid: uid ?? _uid,
    name: name ?? _name,
    portrait: portrait ?? _portrait,
  );
  num get uid => _uid;
  String get name => _name;
  String get portrait => _portrait;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['name'] = _name;
    map['portrait'] = _portrait;
    return map;
  }

}