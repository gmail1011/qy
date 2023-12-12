/// list : [{"id":"5dbeb38be76468ea20625f92","name":"熟女"},{"id":"5dbeb23fe76468ea20625edc","name":"乱伦"},{"id":"5dbeb23be76468ea20625ed9","name":"少妇"},{"id":"5dbeb22fe76468ea20625ec4","name":"国语对白"},{"id":"5e8b128514e5e0f54d9ae2d7","name":"桃花岛工作室"},{"id":"5dbeb269e76468ea20625ef2","name":"萝莉"},{"id":"5de2f937cda257823b28453e","name":"学生"},{"id":"5dbeb2c8e76468ea20625f24","name":"偷拍"},{"id":"5dbeb22fe76468ea20625ebf","name":"原创"},{"id":"5dbeb230e76468ea20625ecb","name":"调教"},{"id":"5dbeb22fe76468ea20625ebd","name":"人妻"},{"id":"5dbeb22fe76468ea20625ebc","name":"自慰"},{"id":"5dbeb230e76468ea20625ecc","name":"学生妹"},{"id":"5dbeb230e76468ea20625eca","name":"露出"},{"id":"5dbeb22fe76468ea20625ec3","name":"后入"},{"id":"5dbeb22fe76468ea20625ec2","name":"花式做爱"},{"id":"5dbeb22fe76468ea20625ec0","name":"自拍"},{"id":"5dbeb281e76468ea20625f00","name":"国产"},{"id":"5dbeb22fe76468ea20625ec1","name":"口活"},{"id":"5dbeb23de76468ea20625edb","name":"妈妈"}]

class HotTagModel {
  HotTagModel({
    List<HotTagItem> list,
  }) {
    _list = list;
  }

  HotTagModel.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(HotTagItem.fromJson(v));
      });
    }
  }

  List<HotTagItem> _list;

  HotTagModel copyWith({
    List<HotTagItem> list,
  }) =>
      HotTagModel(
        list: HotTagItem ?? _list,
      );

  List<HotTagItem> get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_list != null) {
      map['list'] = _list.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "5dbeb38be76468ea20625f92"
/// name : "熟女"

class HotTagItem {
  HotTagItem({
    String id,
    String name,
    int hot,
  }) {
    _id = id;
    _name = name;
    _hot = hot;
  }

  HotTagItem.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _hot = json['hot'];
  }

  String _id;
  String _name;
  int _hot;
  HotTagItem copyWith({
    String id,
    String name,
    int hot,
  }) =>
      HotTagItem(
        id: id ?? _id,
        name: name ?? _name,
        hot: hot ?? _hot,
      );

  String get id => _id;

  String get name => _name;

  int get hot => _hot;

  String get hotDesc{
    if((hot ?? 0) > 10000){
      return (hot/10000).toString() + "W";
    }
    return hot.toString();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['hot'] = _hot;
    return map;
  }
}
