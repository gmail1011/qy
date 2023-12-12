class WalletModelEntity {
  ///收益金币 毛/角
  int income;

  int uid;

  ///充值金币
  int amount;

  int performance;

  ///充值金币
  int money;
  int consumption;
  int integral;
  String id;
  int takeOut;
  int current;
  int limit;
  int maxLevel;
  String nudeChatIncome;
  int fruitCoin;
  List<PrivilegeBean> privilegeBeans;
  int proxyIncome;
  num vidIncome;
  int aiUndressFreeTimes;
  int downloadCount;

  WalletModelEntity({
    this.income,
    this.uid,
    this.amount,
    this.performance,
    this.money,
    this.consumption,
    this.id,
    this.takeOut,
    this.current,
    this.limit,
    this.nudeChatIncome,
    this.fruitCoin,
    this.privilegeBeans,
    this.proxyIncome,
    this.vidIncome,
    this.aiUndressFreeTimes,
    this.downloadCount,
  });

  WalletModelEntity.fromJson(Map<String, dynamic> json) {
    income = json['income'];
    uid = json['uid'];
    amount = json['amount'];
    performance = json['performance'];
    money = json['money'];
    integral = json['integral'];
    consumption = json['consumption'];
    id = json['id'];
    current = json['current'];
    limit = json['limit'];
    nudeChatIncome = json['nudeChatIncome'];
    fruitCoin = json['fruitCoin'];
    takeOut = json['takeOut'];
    maxLevel = json['maxLevel'];
    proxyIncome = json['proxyIncome'];
    vidIncome = json['vidIncome'];
    aiUndressFreeTimes = json['aiUndressFreeTimes'];
    downloadCount = json['downloadCount'];
    privilegeBeans = List()..addAll((json['privileges'] as List ?? []).map((o) => PrivilegeBean.fromJson(o)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['income'] = this.income;
    data['uid'] = this.uid;
    data['amount'] = this.amount;
    data['performance'] = this.performance;
    data['money'] = this.money;
    data['integral'] = this.integral;
    data['consumption'] = this.consumption;
    data['id'] = this.id;
    data['takeOut'] = this.takeOut;
    data['maxLevel'] = this.maxLevel;
    data['nudeChatIncome'] = this.nudeChatIncome;
    data['fruitCoin'] = this.fruitCoin;
    data['proxyIncome'] = this.proxyIncome;
    data['vidIncome'] = this.vidIncome;
    data['aiUndressFreeTimes'] = aiUndressFreeTimes;
    data['downloadCount'] = downloadCount;
    return data;
  }
}

class PrivilegeBean {
  String name;
  String desc;
  int icon;
  int type;
  bool enable;
  int number;

  PrivilegeBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['desc'];
    icon = json['icon'];
    type = json['type'];
    enable = json['enable'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['icon'] = this.icon;
    data['type'] = this.type;
    data['enable'] = this.enable;
    data['number'] = this.number;
    return data;
  }
}
