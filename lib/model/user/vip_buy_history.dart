/// hasNext : false
/// list : [{"id":"5df76072b9ce8e4d01878ed4","uid":113014,"productID":"5dce1d9250300dd6f3aa5e1f","name":"铂金卡(月度会员)","amount":200,"income":0,"productType":0,"updatedAt":"2019-12-16T18:46:10.599+08:00","createdAt":"2019-12-16T18:46:10.599+08:00"}]

class VipBuyHistory {
  bool hasNext;
  List<ListBean> list = [];

  static VipBuyHistory fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    VipBuyHistory vipBuyHistoryBean = VipBuyHistory();
    vipBuyHistoryBean.hasNext = map['hasNext'];
    vipBuyHistoryBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => ListBean.fromMap(o))
    );
    return vipBuyHistoryBean;
  }

  Map toJson() => {
    "hasNext": hasNext,
    "list": list,
  };
}

/// id : "5df76072b9ce8e4d01878ed4"
/// uid : 113014
/// productID : "5dce1d9250300dd6f3aa5e1f"
/// name : "铂金卡(月度会员)"
/// amount : 200
/// income : 0
/// productType : 0
/// updatedAt : "2019-12-16T18:46:10.599+08:00"
/// createdAt : "2019-12-16T18:46:10.599+08:00"

class ListBean {
  String id;
  int uid;
  String productID;
  String name;
  int amount;
  int income;
  int productType;
  String updatedAt;
  String createdAt;

  static ListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean listBean = ListBean();
    listBean.id = map['id'];
    listBean.uid = map['uid'];
    listBean.productID = map['productID'];
    listBean.name = map['name'];
    listBean.amount = map['amount'];
    listBean.income = map['income'];
    listBean.productType = map['productType'];
    listBean.updatedAt = map['updatedAt'];
    listBean.createdAt = map['createdAt'];
    return listBean;
  }

  Map toJson() => {
    "id": id,
    "uid": uid,
    "productID": productID,
    "name": name,
    "amount": amount,
    "income": income,
    "productType": productType,
    "updatedAt": updatedAt,
    "createdAt": createdAt,
  };
}