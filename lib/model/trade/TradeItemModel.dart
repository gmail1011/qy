import '../ads_model.dart';
import 'Publisher.dart';
import 'Medias.dart';
import 'OrderUser.dart';

class TradeItemModel {
  TradeItemModel();

  TradeItemModel.fromJson(dynamic json) {
    id = json['ID'];
    tradeType = json['tradeType'];
    typeName = json['typeName'];
    publisherUID = json['publisherUID'];
    publisher = json['publisher'] != null ? Publisher.fromJson(json['publisher']) : null;
    publisherDeposit = json['publisherDeposit'];
    cover = json['cover'];
    if (json['medias'] != null) {
      medias = [];
      json['medias'].forEach((v) {
        medias.add(Medias.fromJson(v));
      });
    }
    describe = json['describe'];
    contact = json['contact'];
    viewCount = json['viewCount'];
    verifyTime = json['verifyTime'];
    reason = json['reason'];
    orderUID = json['orderUID'];
    goodsName = json['goodsName'];
    leaveMsg = json['leaveMsg'];
    orderUser = json['orderUser'] != null ? OrderUser.fromJson(json['orderUser']) : null;
    orderDeposit = json['orderDeposit'];
    tradeStatus = json['tradeStatus'];
    viewerLimit = json['viewerLimit'];
    tradeCount = json['tradeCount'];
    publisherOperate = json['publisherOperate'];
    orderUsrOperate = json['orderUsrOperate'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }
  String id;
  String tradeType;
  String typeName;
  int publisherUID;
  Publisher publisher;
  int publisherDeposit;
  String cover;
  List<Medias> medias;
  String describe;
  String contact;
  int viewCount;
  String verifyTime;
  String reason;
  int orderUID;
  OrderUser orderUser;
  int orderDeposit;
  int tradeStatus;
  int viewerLimit;
  int tradeCount;
  int publisherOperate;
  int orderUsrOperate;
  String createAt;
  String goodsName;
  String leaveMsg;
  String updateAt;
  String type;
  AdsInfoBean advInfo;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;
    map['tradeType'] = tradeType;
    map['typeName'] = typeName;
    map['publisherUID'] = publisherUID;
    if (publisher != null) {
      map['publisher'] = publisher.toJson();
    }
    map['publisherDeposit'] = publisherDeposit;
    map['cover'] = cover;
    if (medias != null) {
      map['medias'] = medias.map((v) => v.toJson()).toList();
    }
    map['describe'] = describe;
    map['contact'] = contact;
    map['viewCount'] = viewCount;
    map['verifyTime'] = verifyTime;
    map['reason'] = reason;
    map['orderUID'] = orderUID;
    map['goodsName'] = goodsName;
    map['leaveMsg'] = leaveMsg;
    if (orderUser != null) {
      map['orderUser'] = orderUser.toJson();
    }
    map['orderDeposit'] = orderDeposit;
    map['tradeStatus'] = tradeStatus;
    map['viewerLimit'] = viewerLimit;
    map['tradeCount'] = tradeCount;
    map['publisherOperate'] = publisherOperate;
    map['orderUsrOperate'] = orderUsrOperate;
    map['createAt'] = createAt;
    map['updateAt'] = updateAt;
    return map;
  }

}