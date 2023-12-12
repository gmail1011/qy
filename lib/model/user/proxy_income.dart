class ProxyIncome {
  bool hasNext = false;
  List<ListBean> list;

  static ProxyIncome fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    ProxyIncome proxyIncomeBean = ProxyIncome();
    proxyIncomeBean.hasNext = map['hasNext'] ?? false;
    proxyIncomeBean.list = List()
      ..addAll((map['list'] as List ?? []).map((o) => ListBean.fromMap(o)));
    return proxyIncomeBean;
  }

  Map toJson() => {
        "hasNext": hasNext,
        "list": list,
      };
}

class ListBean {
  String id;
  int uid;
  int performance;
  int agentLevel;
  int money;
  String rechargeID;
  int originUID;
  int vipLevel;
  String createdAt;
  double amount;
  double actualAmount;
  String desc;

  static ListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean listBean = ListBean();
    listBean.id = map['id'];
    listBean.uid = map['uid'];
    listBean.performance = map['performance'];
    listBean.agentLevel = map['agentLevel'];
    listBean.money = map['money'];
    listBean.rechargeID = map['rechargeID'];
    listBean.originUID = map['originUID'];
    listBean.vipLevel = map['vipLevel'];
    listBean.createdAt = map['createdAt'];
    listBean.amount = map['amount']?.toDouble() ?? .0;
    listBean.actualAmount = map['actualAmount']?.toDouble() ?? .0;
    listBean.desc = map['desc'];
    return listBean;
  }

  Map toJson() => {
        "id": id,
        "uid": uid,
        "performance": performance,
        "agentLevel": agentLevel,
        "money": money,
        "rechargeID": rechargeID,
        "originUID": originUID,
        "vipLevel": vipLevel,
        "createdAt": createdAt,
        "amount": amount,
        "actualAmount": actualAmount,
        "desc": desc,
      };
}
