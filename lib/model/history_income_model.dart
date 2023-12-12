
class HistoryIncomeModel {
  bool hasNext;
  List<ListBean> list;
  int totalIncome;

  static HistoryIncomeModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    HistoryIncomeModel historyIncomeModelBean = HistoryIncomeModel();
    historyIncomeModelBean.hasNext = map['hasNext'];
    historyIncomeModelBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => ListBean.fromMap(o))
    );
    historyIncomeModelBean.totalIncome = map['totalIncome'];
    return historyIncomeModelBean;
  }

  Map toJson() => {
    "hasNext": hasNext,
    "list": list,
    "totalIncome": totalIncome,
  };
}

class ListBean {
  String id;
  int uid;
  String title;
  String videoID;
  int coins;
  dynamic publisherIncome;
  int tax;
  int payMoney;
  int publisherID;
  String unique;
  String createdAt;

  static ListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean listBean = ListBean();
    listBean.id = map['id'];
    listBean.uid = map['uid'];
    listBean.title = map['title'];
    listBean.videoID = map['videoID'];
    listBean.coins = map['coins'];
    listBean.publisherIncome = map['publisherIncome'];
    listBean.tax = map['tax'];
    listBean.payMoney = map['payMoney'];
    listBean.publisherID = map['publisherID'];
    listBean.unique = map['uniq'];
    listBean.createdAt = map['createdAt'];
    return listBean;
  }

  Map toJson() => {
    "id": id,
    "uid": uid,
    "title": title,
    "videoID": videoID,
    "coins": coins,
    "publisherIncome": publisherIncome,
    "tax": tax,
    "payMoney": payMoney,
    "publisherID": publisherID,
    "uniq": unique,
    "createdAt": createdAt,
  };
}