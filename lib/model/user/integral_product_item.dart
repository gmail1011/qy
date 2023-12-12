/// desc : "string"
/// duration : 0
/// id : "string"
/// name : "string"
/// price : 0

class IntegralProductItem {
  IntegralProductItem({
    String desc,
    int duration,
    String id,
    String name,
    int price,
  }) {
    _desc = desc;
    _duration = duration;
    _id = id;
    _name = name;
    _price = price;
  }

  IntegralProductItem.fromJson(dynamic json) {
    _desc = json['desc'];
    _duration = json['duration'];
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
  }

  String _desc;
  int _duration;
  String _id;
  String _name;
  int _price;

  IntegralProductItem copyWith({
    String desc,
    num duration,
    String id,
    String name,
    num price,
  }) =>
      IntegralProductItem(
        desc: desc ?? _desc,
        duration: duration ?? _duration,
        id: id ?? _id,
        name: name ?? _name,
        price: price ?? _price,
      );

  String get desc => _desc;

  num get duration => _duration;

  String get id => _id;

  String get name => _name;

  num get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['desc'] = _desc;
    map['duration'] = _duration;
    map['id'] = _id;
    map['name'] = _name;
    map['price'] = _price;
    return map;
  }
}
