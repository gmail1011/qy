/// list : [{"keyWord":"单男","count":4},{"keyWord":"自拍","count":3},{"keyWord":"呵呵","count":2},{"keyWord":"嘿嘿","count":2},{"keyWord":"美女","count":2},{"keyWord":"学生","count":2},{"keyWord":"学生偷拍","count":2},{"keyWord":"偷拍","count":2},{"keyWord":"少妇","count":2},{"keyWord":"自慰","count":2},{"keyWord":"车","count":2},{"keyWord":"多汁","count":2},{"keyWord":"啪啪啪","count":2},{"keyWord":"啦啦啦啦啦啦","count":2},{"keyWord":"多汁啦啦啦","count":2},{"keyWord":"靓仔","count":1}]
/// count : 30
/// updatedAt : "2019-11-29 17:41"

class SearchHotRankModel {
  List<ListBean> list = [];
  int count = 0;
  String updatedAt = "";
  bool hasNext = false;

  static SearchHotRankModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchHotRankModel searchHotRankModelBean = SearchHotRankModel();
    searchHotRankModelBean.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => ListBean.fromMap(o))
    );
    searchHotRankModelBean.count = map['count'];
    searchHotRankModelBean.updatedAt = map['updatedAt'];
    searchHotRankModelBean.hasNext = map['hasNext'] ?? false;
    return searchHotRankModelBean;
  }

  Map toJson() => {
    "list": list,
    "count": count,
    "updatedAt": updatedAt,
    "hasNext" : hasNext,
  };
}

/// keyWord : "单男"
/// count : 4

class ListBean {
  String keyWord;
  int count;

  static ListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ListBean listBean = ListBean();
    listBean.keyWord = map['keyWord'];
    listBean.count = map['count'];
    return listBean;
  }

  Map toJson() => {
    "keyWord": keyWord,
    "count": count,
  };
}