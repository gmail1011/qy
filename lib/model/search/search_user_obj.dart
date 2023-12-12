
import 'search_user_model.dart';

class SearchUserObj {
  bool hasNext;
  List<SearchUserModel> list;

  SearchUserObj({this.hasNext, this.list});

  SearchUserObj.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = List<SearchUserModel>();
      json['list'].forEach((v) {
        list.add(SearchUserModel.fromJson(v));
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
