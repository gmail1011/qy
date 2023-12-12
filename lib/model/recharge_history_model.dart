
class RechargeHistoryModel {
  String id;
  int uid;
  String devID;
  String oid;
  String userIP;
  String name;
  String tel;
  String payAct;
  String devType;
  int amount;
  int money;
  int payMoney;
  String rechargeType;
  String productID;
  String vipID;
  String channel;
  int status;
  String statusDesc;
  String paymentAt;
  String createdAt;
  String updatedAt;

  static RechargeHistoryModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    RechargeHistoryModel rechargeHistoryModelBean = RechargeHistoryModel();
    rechargeHistoryModelBean.id = map['id'];
    rechargeHistoryModelBean.uid = map['uid'];
    rechargeHistoryModelBean.devID = map['devID'];
    rechargeHistoryModelBean.oid = map['oid'];
    rechargeHistoryModelBean.userIP = map['userIP'];
    rechargeHistoryModelBean.name = map['name'];
    rechargeHistoryModelBean.tel = map['tel'];
    rechargeHistoryModelBean.payAct = map['payAct'];
    rechargeHistoryModelBean.devType = map['devType'];
    rechargeHistoryModelBean.amount = map['amount'];
    rechargeHistoryModelBean.money = map['money'];
    rechargeHistoryModelBean.payMoney = map['payMoney'];
    rechargeHistoryModelBean.rechargeType = map['rechargeType'];
    rechargeHistoryModelBean.productID = map['productID'];
    rechargeHistoryModelBean.vipID = map['vipID'];
    rechargeHistoryModelBean.channel = map['channel'];
    rechargeHistoryModelBean.status = map['status'];
    rechargeHistoryModelBean.statusDesc = map['statusDesc'];
    rechargeHistoryModelBean.paymentAt = map['paymentAt'];
    rechargeHistoryModelBean.createdAt = map['createdAt'];
    rechargeHistoryModelBean.updatedAt = map['updatedAt'];
    return rechargeHistoryModelBean;
  }

  static List<RechargeHistoryModel> toList(List<dynamic> mapList) {
    List<RechargeHistoryModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }

  Map toJson() => {
    "id": id,
    "uid": uid,
    "devID": devID,
    "oid": oid,
    "userIP": userIP,
    "name": name,
    "tel": tel,
    "payAct": payAct,
    "devType": devType,
    "amount": amount,
    "money": money,
    "payMoney": payMoney,
    "rechargeType": rechargeType,
    "productID": productID,
    "vipID": vipID,
    "channel": channel,
    "status": status,
    "statusDesc": statusDesc,
    "paymentAt": paymentAt,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}