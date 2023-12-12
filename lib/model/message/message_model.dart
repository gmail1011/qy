/// newsCount : 1
/// sendAt : "2019-12-27T12:25:55.176+08:00"
/// sender : "SYSTEM"
/// title : "定时通知_05秒_测试0"
/// content : "在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒.在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒.在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒.在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒.在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒.在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒.在开始时间和结束时间内，根据指定的时间单位周期性通知,周期:05秒."

class MessageModel {
  int newsCount;
  String sendAt;
  String sender;
  String title;
  String content;
  String icon;

  static MessageModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    MessageModel listBean = MessageModel();
    listBean.newsCount = map['newsCount'];
    listBean.sendAt = map['sendAt'];
    listBean.sender = map['sender'];
    listBean.title = map['title'];
    listBean.content = map['content'];
    return listBean;
  }

  Map toJson() => {
        "newsCount": newsCount,
        "sendAt": sendAt,
        "sender": sender,
        "title": title,
        "content": content,
      };

  static List<MessageModel> toList(List<dynamic> mapList) {
    List<MessageModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }
}
