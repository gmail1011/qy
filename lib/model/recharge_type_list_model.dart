class RechargeTypeModel {
  String id;
  int amount;
  int money;
  int firstGiveGold;
  String typeName;
  String couponDesc;
  List<RechargeTypeBean> rechargeTypeList;
  List<Privilege> privilege;
  bool hotStatus;
  static RechargeTypeModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    RechargeTypeModel rechargeTypeListModelBean = RechargeTypeModel();
    rechargeTypeListModelBean.id = map['id'];
    rechargeTypeListModelBean.amount = map['amount'];
    rechargeTypeListModelBean.money = map['money'];
    rechargeTypeListModelBean.firstGiveGold = map['firstGiveGold'];
    rechargeTypeListModelBean.typeName = map['typeName'];
    rechargeTypeListModelBean.couponDesc = map['couponDesc'];
    rechargeTypeListModelBean.hotStatus = map['hotStatus'];
    rechargeTypeListModelBean.rechargeTypeList = List()
      ..addAll((map['rchgType'] as List ?? [])
          .map((o) => RechargeTypeBean.fromMap(o)));

    rechargeTypeListModelBean.privilege = List()
      ..addAll((map['privilege'] as List ?? [])
          .map((o) => Privilege.fromMap(o)));
    return rechargeTypeListModelBean;
  }

  Map toJson() => {
        "id": id,
        "amount": amount,
        "money": money,
        "typeName": typeName,
        "rchgType": rechargeTypeList,
        "couponDesc": couponDesc,
        "privilege": privilege,
        "firstGiveGold": firstGiveGold,
        "hotStatus": hotStatus,
      };

  static List<RechargeTypeModel> toList(List<dynamic> mapList) {
    List<RechargeTypeModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }
}

///特权信息
class Privilege {
  String img;
  String privilegeName;
  String privilegeDesc;

  static Privilege fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Privilege privilege = Privilege();
    privilege.img = map['img'];
    privilege.privilegeName = map['privilegeName'];
    privilege.privilegeDesc = map['privilegeDesc'];
    return privilege;
  }

  Map toJson() => {
        "img": img,
        "privilegeName": privilegeName,
        "privilegeDesc": privilegeDesc,
      };
}

class RechargeTypeBean {
  String type;
  String typeName;
  String channel;
  String incrAmount; //增加的优惠额度
  String
      incTax; //按比率增加额外优惠额 0-1之间 ,如果 incrAmount 与 incrTax 同时存在 以 incrAmount 为准

  static RechargeTypeBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    RechargeTypeBean rechargeTypeBean = RechargeTypeBean();
    rechargeTypeBean.type = map['type'];
    rechargeTypeBean.typeName = map['typeName'];
    rechargeTypeBean.channel = map['channel'];
    rechargeTypeBean.incrAmount =
        map.containsKey('incrAmount') ? map['incrAmount'].toString() : '0';
    rechargeTypeBean.incTax =
        map.containsKey('incTax') ? map['incTax'].toString() : '0';
    return rechargeTypeBean;
  }

  Map toJson() => {
        "type": type,
        "typeName": typeName,
        "channel": channel,
        "incrAmount": incrAmount,
        "incTax": incTax,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RechargeTypeBean &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          typeName == other.typeName &&
          channel == other.channel;

  @override
  int get hashCode => type.hashCode ^ typeName.hashCode ^ channel.hashCode;
}
