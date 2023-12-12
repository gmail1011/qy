/// hasNext : false
/// list : [{"productName":"金币300","orderId":"1695035335931621572","money":30000,"paymentAt":"2023-09-18T19:08:55.931+08:00","createdAt":"2023-09-18T19:08:55.814+08:00","payType":"alipay","status":3},{"productName":"金币300","orderId":"","money":30000,"paymentAt":"0001-01-01T08:05:43+08:05","createdAt":"2023-09-16T16:09:55.871+08:00","payType":"alipay","status":0},{"productName":"金币300","orderId":"1694683697850524853","money":30000,"paymentAt":"0001-01-01T08:05:43+08:05","createdAt":"2023-09-14T17:28:17.718+08:00","payType":"alipay","status":1},{"productName":"浅网月卡","orderId":"1694682894563651648","money":10000,"paymentAt":"0001-01-01T08:05:43+08:05","createdAt":"2023-09-14T17:14:53.159+08:00","payType":"alipay","status":1}]
/// total : 4

class RechargeRecordModel {
  RechargeRecordModel({
      bool hasNext, 
      List<RechargeRecordItem> list,
      num total,}){
    _hasNext = hasNext;
    _list = list;
    _total = total;
}

  RechargeRecordModel.fromJson(dynamic json) {
    _hasNext = json['hasNext'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(RechargeRecordItem.fromJson(v));
      });
    }
    _total = json['total'];
  }
  bool _hasNext;
  List<RechargeRecordItem> _list;
  num _total;
RechargeRecordModel copyWith({  bool hasNext,
  List<RechargeRecordItem> list,
  num total,
}) => RechargeRecordModel(  hasNext: hasNext ?? _hasNext,
  list: list ?? _list,
  total: total ?? _total,
);
  bool get hasNext => _hasNext;
  List<RechargeRecordItem> get list => _list;
  num get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasNext'] = _hasNext;
    if (_list != null) {
      map['list'] = _list.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    return map;
  }

}

/// productName : "金币300"
/// orderId : "1695035335931621572"
/// money : 30000
/// paymentAt : "2023-09-18T19:08:55.931+08:00"
/// createdAt : "2023-09-18T19:08:55.814+08:00"
/// payType : "alipay"
/// status : 3

class RechargeRecordItem {
  RechargeRecordItem({
      String productName, 
      String orderId, 
      num money, 
      String paymentAt, 
      String createdAt, 
      String payType, 
      num status,}){
    _productName = productName;
    _orderId = orderId;
    _money = money;
    _paymentAt = paymentAt;
    _createdAt = createdAt;
    _payType = payType;
    _status = status;
}

  RechargeRecordItem.fromJson(dynamic json) {
    _productName = json['productName'];
    _orderId = json['orderId'];
    _money = json['money'];
    _paymentAt = json['paymentAt'];
    _createdAt = json['createdAt'];
    _payType = json['payType'];
    _status = json['status'];
  }
  String _productName;
  String _orderId;
  num _money;
  String _paymentAt;
  String _createdAt;
  String _payType;
  num _status;
RechargeRecordItem copyWith({  String productName,
  String orderId,
  num money,
  String paymentAt,
  String createdAt,
  String payType,
  num status,
}) => RechargeRecordItem(  productName: productName ?? _productName,
  orderId: orderId ?? _orderId,
  money: money ?? _money,
  paymentAt: paymentAt ?? _paymentAt,
  createdAt: createdAt ?? _createdAt,
  payType: payType ?? _payType,
  status: status ?? _status,
);
  String get productName => _productName;
  String get orderId => _orderId;
  num get money => _money;
  String get paymentAt => _paymentAt;
  String get createdAt => _createdAt;
  String get payType => _payType;
  num get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productName'] = _productName;
    map['orderId'] = _orderId;
    map['money'] = _money;
    map['paymentAt'] = _paymentAt;
    map['createdAt'] = _createdAt;
    map['payType'] = _payType;
    map['status'] = _status;
    return map;
  }

}