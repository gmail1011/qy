/// hasNext : true

class WithdrawDetailsModel {
  bool hasNext;
  List<ListBean> list;
  List<ResultBean> result;
  int total;

  static WithdrawDetailsModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    WithdrawDetailsModel withdrawDetailsModel = WithdrawDetailsModel();
    withdrawDetailsModel.hasNext = map['hasNext'];
    withdrawDetailsModel.list = List()
      ..addAll((map['list'] as List ?? []).map((o) => ListBean.fromMap(o)));
    withdrawDetailsModel.result = List()
      ..addAll((map['result'] as List ?? []).map((o) => ResultBean.fromMap(o)));
    withdrawDetailsModel.total = map['total'];
    return withdrawDetailsModel;
  }

  Map toJson() => {
        "hasNext": hasNext,
        "list": list,
        "result": result,
        "total": total,
      };
}

/// id : "5dd7b45e5843776b2105ce74"
/// uid : 113014
/// name : "游客1573443356"
/// amount : 0
/// oid : ""
/// money : 10000
/// payMoney : 9500
/// withdrawType : 0
/// actName : "奋斗"
/// act : "15244445555"
/// userIp : ""
/// deviceType : ""
/// devID : "77D29CBF-C188-44C2-B19A-4D54881666D7"
/// status : 5
/// statusDesc : ""
/// checkedAt : "0001-01-01T00:00:00Z"
/// progressAt : "0001-01-01T00:00:00Z"
/// failureAt : "0001-01-01T00:00:00Z"
/// successAt : "0001-01-01T00:00:00Z"
/// updatedAt : "0001-01-01T08:05:43+08:05"
/// createdAt : "2019-11-11T15:29:45.797+08:00"
/// receivedAt : "0001-01-01T08:05:43+08:05"

class ResultBean {
  String id;
  int uid;
  String name;
  int amount;
  String oid;
  int money;
  int payMoney;
  String payType;
  int withdrawType;
  String actName;
  String act;
  String userIp;
  String deviceType;
  String devID;
  int status;
  String statusDesc;
  String checkedAt;
  String progressAt;
  String failureAt;
  String successAt;
  String updatedAt;
  String createdAt;
  String receivedAt;

  static ResultBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ResultBean resultBean = ResultBean();
    resultBean.id = map['id'];
    resultBean.uid = map['uid'];
    resultBean.name = map['name'];
    resultBean.amount = map['amount'];
    resultBean.oid = map['oid'];
    resultBean.money = map['money'];
    resultBean.payMoney = map['payMoney'];
    resultBean.payType = map['payType'];
    resultBean.withdrawType = map['withdrawType'];
    resultBean.actName = map['actName'];
    resultBean.act = map['act'];
    resultBean.userIp = map['userIp'];
    resultBean.deviceType = map['deviceType'];
    resultBean.devID = map['devID'];
    resultBean.status = map['status'];
    resultBean.statusDesc = map['statusDesc'];
    resultBean.checkedAt = map['checkedAt'];
    resultBean.progressAt = map['progressAt'];
    resultBean.failureAt = map['failureAt'];
    resultBean.successAt = map['successAt'];
    resultBean.updatedAt = map['updatedAt'];
    resultBean.createdAt = map['createdAt'];
    resultBean.receivedAt = map['receivedAt'];
    return resultBean;
  }

  Map toJson() => {
        "id": id,
        "uid": uid,
        "name": name,
        "amount": amount,
        "oid": oid,
        "money": money,
        "payMoney": payMoney,
        "payType": payType,
        "withdrawType": withdrawType,
        "actName": actName,
        "act": act,
        "userIp": userIp,
        "deviceType": deviceType,
        "devID": devID,
        "status": status,
        "statusDesc": statusDesc,
        "checkedAt": checkedAt,
        "progressAt": progressAt,
        "failureAt": failureAt,
        "successAt": successAt,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "receivedAt": receivedAt,
      };
}

/// id : "5dd7b45e5843776b2105ce74"
/// uid : 113014
/// name : "游客1573443356"
/// amount : 0
/// oid : ""
/// money : 10000
/// payMoney : 9500
/// withdrawType : 0
/// actName : "奋斗"
/// act : "15244445555"
/// userIp : ""
/// deviceType : ""
/// devID : "77D29CBF-C188-44C2-B19A-4D54881666D7"
/// status : 5
/// statusDesc : ""
/// checkedAt : "0001-01-01T00:00:00Z"
/// progressAt : "0001-01-01T00:00:00Z"
/// failureAt : "0001-01-01T00:00:00Z"
/// successAt : "0001-01-01T00:00:00Z"
/// updatedAt : "0001-01-01T08:05:43+08:05"
/// createdAt : "2019-11-11T15:29:45.797+08:00"
/// receivedAt : "0001-01-01T08:05:43+08:05"

class ListBean {
  String id;
  int uid;
  String name;
  int amount;
  String oid;
  int money;
  int payMoney;
  String payType;
  int withdrawType;
  String actName;
  String act;
  String userIp;
  String deviceType;
  String devID;
  int status;
  String statusDesc;
  String checkedAt;
  String progressAt;
  String failureAt;
  String successAt;
  String updatedAt;
  String createdAt;
  String desc;
  String receivedAt;
  double actualAmount;

  static ListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean listBean = ListBean();
    listBean.id = map['id'];
    listBean.uid = map['uid'];
    listBean.name = map['name'];
    listBean.amount = map['amount'];
    listBean.oid = map['oid'];
    listBean.money = map['money'];
    listBean.payMoney = map['payMoney'];
    listBean.payType = map['payType'];
    listBean.withdrawType = map['withdrawType'];
    listBean.actName = map['actName'];
    listBean.act = map['act'];
    listBean.userIp = map['userIp'];
    listBean.deviceType = map['deviceType'];
    listBean.devID = map['devID'];
    listBean.status = map['status'];
    listBean.statusDesc = map['statusDesc'];
    listBean.checkedAt = map['checkedAt'];
    listBean.progressAt = map['progressAt'];
    listBean.failureAt = map['failureAt'];
    listBean.successAt = map['successAt'];
    listBean.updatedAt = map['updatedAt'];
    listBean.createdAt = map['createdAt'];
    listBean.receivedAt = map['receivedAt'];
    listBean.desc = map['desc'];
    listBean.actualAmount = map['actualAmount']?.toDouble() ?? .0;
    return listBean;
  }

  Map toJson() => {
        "id": id,
        "uid": uid,
        "name": name,
        "amount": amount,
        "oid": oid,
        "money": money,
        "payMoney": payMoney,
        "payType": payType,
        "withdrawType": withdrawType,
        "actName": actName,
        "act": act,
        "userIp": userIp,
        "deviceType": deviceType,
        "devID": devID,
        "status": status,
        "statusDesc": statusDesc,
        "checkedAt": checkedAt,
        "progressAt": progressAt,
        "failureAt": failureAt,
        "successAt": successAt,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
        "receivedAt": receivedAt,
        "desc": desc,
        "actualAmount": actualAmount,
      };
}
