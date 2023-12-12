/// channelName : "金鱼"
/// cid : "goldfish"
/// payType : "bankcard"
/// minMoney : 10000
/// maxMoney : 1000000
/// weight : 1
/// active : false
/// createdAt : "2019-11-04T12:56:18.911+08:00"
/// updatedAt : "2019-11-04T12:56:18.911+08:00"
/// ID : 1
/// cashTax : 5
/// coinTax : 1

class WithdrawFeeModel {
  String id;
  String channelName;
  String cid;
  String payType;

  /// 分/角
  int minMoney;
  // 分/角
  int maxMoney;
  int weight;
  bool active;
  String createdAt;
  String updatedAt;
  int cashTax;
  int coinTax;

  int gameTax;

  int qpMinMoney;

  static WithdrawFeeModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    WithdrawFeeModel withdrawFeeModelBean = WithdrawFeeModel();
    withdrawFeeModelBean.id = map['id'];
    withdrawFeeModelBean.channelName = map['channelName'];
    withdrawFeeModelBean.cid = map['cid'];
    withdrawFeeModelBean.payType = map['payType'];
    withdrawFeeModelBean.minMoney = map['minMoney'];
    withdrawFeeModelBean.maxMoney = map['maxMoney'];
    withdrawFeeModelBean.weight = map['weight'];
    withdrawFeeModelBean.active = map['active'];
    withdrawFeeModelBean.createdAt = map['createdAt'];
    withdrawFeeModelBean.updatedAt = map['updatedAt'];
    withdrawFeeModelBean.cashTax = map['cashTax'];
    withdrawFeeModelBean.coinTax = map['coinTax'];
    withdrawFeeModelBean.gameTax = map['gameTax'];
    withdrawFeeModelBean.qpMinMoney = map['qpMinMoney'];
    return withdrawFeeModelBean;
  }

  Map toJson() => {
        "id": id,
        "channelName": channelName,
        "cid": cid,
        "payType": payType,
        "minMoney": minMoney,
        "maxMoney": maxMoney,
        "weight": weight,
        "active": active,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "cashTax": cashTax,
        "coinTax": coinTax,
        "gameTax": gameTax,
        "qpMinMoney": qpMinMoney,
      };
}
