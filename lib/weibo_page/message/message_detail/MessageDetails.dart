// To parse this JSON data, do
//
//     final messageDetails = messageDetailsFromJson(jsonString);

import 'dart:convert';

MessageDetails messageDetailsFromJson(String str) => MessageDetails.fromJson(json.decode(str));

String messageDetailsToJson(MessageDetails data) => json.encode(data.toJson());

class MessageDetails {
  MessageDetails({
    this.code,
    this.data,
    this.hash,
    this.msg,
    this.time,
    this.tip,
  });

  int code;
  Data data;
  bool hash;
  String msg;
  DateTime time;
  String tip;

  factory MessageDetails.fromJson(Map<String, dynamic> json) => MessageDetails(
    code: json["code"],
    data: Data.fromJson(json["data"]),
    hash: json["hash"],
    msg: json["msg"],
    time: DateTime.parse(json["time"]),
    tip: json["tip"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
    "hash": hash,
    "msg": msg,
    "time": time.toIso8601String(),
    "tip": tip,
  };
}

class Data {
  Data({
    this.hasNext,
    this.list,
  });

  bool hasNext;
  List<ListElement> list = [];

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    hasNext: json["hasNext"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "hasNext": hasNext,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListElement {
  ListElement({
    this.id,
    this.sendUid,
    this.sendName,
    this.sendAvatar,
    this.takeUid,
    this.takeName,
    this.takeAvatar,
    this.content,
    this.imgUrl,
    this.isRead,
    this.sessionId,
    this.createdAt,
    this.contentType,
    this.isShowDate,
    this.localUrl,
  });
  bool isShowDate;
  String id;
  int sendUid;
  String sendName;
  String sendAvatar;
  int takeUid;
  String takeName;
  String takeAvatar;
  String content;
  List<String> imgUrl = [];
  String localUrl;
  bool isRead;
  String sessionId;
  DateTime createdAt;
  int contentType;
  String  get messageType{
    if(contentType == 1){
      return "推广通知";
    }else if(contentType == 2){
      return "提现通知";
    }else if(contentType == 3){
      return "审核通知";
    }else if(contentType == 4){
      return "大V审核通知";
    }else if(contentType == 5){
      return "账号封禁通知";
    }else if(contentType == 6){
      return "禁止上传通知";
    }else {
      return "官方消息";
    }
  }
  DateTime _realCreateAt;
  DateTime get realCreateAt {
    if(_realCreateAt == null) {
      var offset = DateTime
          .now()
          .timeZoneOffset;
      _realCreateAt = createdAt.add(offset);
    }
    return _realCreateAt;
  }

  String get yydDate {
    return realCreateAt.year.toString() + "/" + realCreateAt.month.toString() + "/" + realCreateAt.day.toString();
  }

  String get hmTime{
    return realCreateAt.hour.toString() + ":" + realCreateAt.minute.toString();
  }

  static ListElement fromJson(Map<String, dynamic> map) {
    List<String> imgUrlTemp = [];
    if (map == null) return null;
    ListElement messageModelBean = ListElement();
    messageModelBean.id = map['id'];
    messageModelBean.sendUid = map['sendUid'];
    messageModelBean.sendName = map['sendName'];
    messageModelBean.sendAvatar = map['sendAvatar'];
    messageModelBean.takeUid = map['takeUid'];
    messageModelBean.takeName = map['takeName'];
    messageModelBean.takeAvatar = map['takeAvatar'];
    messageModelBean.content = map['content'];
    map['imgUrl']?.forEach((element1) {
      imgUrlTemp.add(element1);
      messageModelBean.imgUrl = imgUrlTemp;
    });
    messageModelBean.isRead = map['isRead'];
    messageModelBean.sessionId = map['sessionId'];
    messageModelBean.createdAt = DateTime.parse(map["createdAt"]);
    messageModelBean.contentType = map['contentType'];
    return messageModelBean;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "sendUid": sendUid,
    "sendName": sendName,
    "sendAvatar": sendAvatar,
    "takeUid": takeUid,
    "takeName": takeName,
    "takeAvatar": takeAvatar,
    "content": content,
    "imgUrl":imgUrl,
    "isRead": isRead,
    "sessionId": sessionId,
    "createdAt": createdAt.toIso8601String(),
    'contentType':contentType,
  };
}
