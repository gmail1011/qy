import 'message_model.dart';

class MessageTypeModel {
  bool hasNew;
  List<MessageModel> noticePreList;
  TrendPreMapBean trendPreMap;
  String updatedAt;

  static MessageTypeModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    MessageTypeModel messageTypeModelBean = MessageTypeModel();
    messageTypeModelBean.hasNew = map['hasNew'];
    messageTypeModelBean.noticePreList = List()..addAll(
      (map['noticePreList'] as List ?? []).map((o) => MessageModel.fromJson(o))
    );
    messageTypeModelBean.trendPreMap = TrendPreMapBean.fromMap(map['trendPreMap']);
    messageTypeModelBean.updatedAt = map['updatedAt'];
    return messageTypeModelBean;
  }

  Map toJson() => {
    "hasNew": hasNew,
    "noticePreList": noticePreList,
    "trendPreMap": trendPreMap,
    "updatedAt": updatedAt,
  };
}


class TrendPreMapBean {
  CountBean comment;///评论
  CountBean fans;///粉丝
  CountBean interactive;///互动
  CountBean like;///赞

  static TrendPreMapBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TrendPreMapBean trendPreMapBean = TrendPreMapBean();
    trendPreMapBean.comment = CountBean.fromMap(map['cmet']);
    trendPreMapBean.fans = CountBean.fromMap(map['fans']);
    trendPreMapBean.interactive = CountBean.fromMap(map['itte']);
    trendPreMapBean.like = CountBean.fromMap(map['like']);
    return trendPreMapBean;
  }

  Map toJson() => {
    "cmet": comment,
    "fans": fans,
    "itte": interactive,
    "like": like,
  };
}

/// count : 0

class CountBean {
  int count;

  static CountBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CountBean countBean = CountBean();
    countBean.count = map['count'];
    return countBean;
  }

  Map toJson() => {
    "count": count,
  };
}
