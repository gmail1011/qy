
class PagedList<T> {
  List<T> list;
  int total;
  bool hasNext;

  static PagedList fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    var page = PagedList();
    //  page.list = map['list']?.cast<T>();
    page.list = map['list'];
    page.total = map['total'];
    page.hasNext = map.containsKey('hasNext') ? map['hasNext'] : false;
    return page;
  }

  Map toJson() => {
        "list": list,
        "total": total,
        "hasNext": hasNext,
      };
}
