/// hasNext : false
/// list : [{"month":"2019-12","recharge":0,"withdraw":0,"list":[{"ID":"5e01ce9bc44f422e04c6a33a","uid":113214,"purchaseOrder":"5e01ce9bc44f422e04c6a339","amount":-200,"tranType":"VIP购买","desc":"购买了铂金卡(月度会员)","createdAt":"2019-12-24T16:38:51.157+08:00"},{"ID":"5e01ce95c44f422e04c6a338","uid":113214,"purchaseOrder":"5e01cd1f06f7da8d751656bc","amount":300,"tranType":"充值","desc":"充值新增了300","createdAt":"2019-12-24T16:38:45.993+08:00"}]},{"month":"2019-11","recharge":300,"withdraw":0,"list":[{"ID":"5e01ce9bc44f422e04c6a33a","uid":113214,"purchaseOrder":"5e01ce9bc44f422e04c6a339","amount":-200,"tranType":"VIP购买","desc":"购买了铂金卡(月度会员)","createdAt":"2019-12-24T16:38:51.157+08:00"},{"ID":"5e01ce95c44f422e04c6a338","uid":113214,"purchaseOrder":"5e01cd1f06f7da8d751656bc","amount":300,"tranType":"充值","desc":"充值新增了300","createdAt":"2019-12-24T16:38:45.993+08:00"}]},{"month":"2019-10","recharge":0,"withdraw":0,"list":[]}]

class MyBillModel {
  bool hasNext;
  List<ListBean> list;
  int timeline;

  static MyBillModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MyBillModel myBillModelBean = MyBillModel();
    myBillModelBean.hasNext = map['hasNext'];
    myBillModelBean.timeline = map['timeline'];
    myBillModelBean.list = List()
      ..addAll((map['list'] as List ?? []).map((o) => ListBean.fromMap(o)));
    return myBillModelBean;
  }

  Map toJson() => {"hasNext": hasNext, "list": list, "timeline": timeline};
}

/// month : "2019-12"
/// recharge : 0
/// withdraw : 0
/// list : [{"ID":"5e01ce9bc44f422e04c6a33a","uid":113214,"purchaseOrder":"5e01ce9bc44f422e04c6a339","amount":-200,"tranType":"VIP购买","desc":"购买了铂金卡(月度会员)","createdAt":"2019-12-24T16:38:51.157+08:00"},{"ID":"5e01ce95c44f422e04c6a338","uid":113214,"purchaseOrder":"5e01cd1f06f7da8d751656bc","amount":300,"tranType":"充值","desc":"充值新增了300","createdAt":"2019-12-24T16:38:45.993+08:00"}]

class ListBean {
  String month;
  String income;
  String withdraw;
  List<ListBean1> list;

  static ListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean listBean = ListBean();
    listBean.month = map['month'];
    listBean.income = map['income']?.toString();
    listBean.withdraw = map['withdraw']?.toString();
    listBean.list = List()
      ..addAll((map['list'] as List ?? []).map((o) => ListBean1.fromMap(o)));
    return listBean;
  }

  Map toJson() => {
        "month": month,
        "recharge": income,
        "withdraw": withdraw,
        "list": list,
      };
}

/// ID : "5e01ce9bc44f422e04c6a33a"
/// uid : 113214
/// purchaseOrder : "5e01ce9bc44f422e04c6a339"
/// amount : -200
/// tranType : "VIP购买"
/// desc : "购买了铂金卡(月度会员)"
/// createdAt : "2019-12-24T16:38:51.157+08:00"

class ListBean1 {
  String id;
  int uid;
  String purchaseOrder;
  int amount;
  dynamic actualAmount;
  String tranType;
  String channelType;
  int tranTypeInt;

  /// 1、充值 2、购买视频 3、提现 4、VIP购买 5、提现失败退款 6、作品收益 7、活动收益
  String desc;
  String createdAt;

  static ListBean1 fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean1 listBean = ListBean1();
    listBean.id = map['ID'];
    listBean.uid = map['uid'];
    listBean.purchaseOrder = map['purchaseOrder'];
    listBean.amount = map['amount'];
    listBean.actualAmount = map['actualAmount'];
    listBean.tranType = map['tranType'];
    listBean.channelType = map['channelType'];
    listBean.tranTypeInt = map['tranTypeInt'];
    listBean.desc = map['desc'];
    listBean.createdAt = map['createdAt'];
    return listBean;
  }

  Map toJson() => {
        "ID": id,
        "uid": uid,
        "purchaseOrder": purchaseOrder,
        "amount": amount,
        "actualAmount": actualAmount,
        "tranType": tranType,
        "channelType": channelType,
        "tranTypeInt": tranTypeInt,
        "desc": desc,
        "createdAt": createdAt,
      };
}
