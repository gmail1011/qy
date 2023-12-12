import 'search_talk_model.dart';

class SearchTalkObj {
  bool hasNext;
  List<SearchTalkModel> list;

  SearchTalkObj({this.hasNext, this.list});

  SearchTalkObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<SearchTalkModel>();
      json['list'].forEach((v) {
        list.add(SearchTalkModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasNext'] = this.hasNext;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
