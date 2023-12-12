class TradeTopic {

  TradeTopic(this.id,this.name);

  TradeTopic.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    bg = json['bg'];
    deposit = json['deposit'];
    viewerLimit = json['viewerLimit'];
    sort = json['sort'];
  }
  String id;
  String name;
  String bg;
  int deposit;
  int viewerLimit;
  int sort;
  bool isSelected = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['bg'] = bg;
    map['deposit'] = deposit;
    map['viewerLimit'] = viewerLimit;
    map['sort'] = sort;
    return map;
  }

}