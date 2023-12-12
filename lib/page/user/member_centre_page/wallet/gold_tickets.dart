/// list : [{"id":"63c149ab52b01af6f7d155ac","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":80,"value":0,"used":false,"expireTime":"2023-01-23T20:08:11.138+08:00","createTime":"2023-01-13T20:08:11.138+08:00"},{"id":"63c149a552b01af6f7d155ab","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":30,"value":0,"used":false,"expireTime":"2023-01-23T20:08:05.702+08:00","createTime":"2023-01-13T20:08:05.702+08:00"},{"id":"63c1499f52b01af6f7d155aa","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":300,"value":0,"used":false,"expireTime":"2023-01-23T20:07:59.411+08:00","createTime":"2023-01-13T20:07:59.411+08:00"},{"id":"63c1499c52b01af6f7d155a9","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":200,"value":0,"used":false,"expireTime":"2023-01-23T20:07:56.254+08:00","createTime":"2023-01-13T20:07:56.254+08:00"},{"id":"63c1495452b01af6f7d155a8","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":100,"value":0,"used":false,"expireTime":"2023-02-02T20:06:44.881+08:00","createTime":"2023-01-13T20:06:44.881+08:00"},{"id":"63c1494a52b01af6f7d155a7","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":50,"value":0,"used":false,"expireTime":"2023-01-23T20:06:34.613+08:00","createTime":"2023-01-13T20:06:34.613+08:00"},{"id":"63c1485c16192c0b2a11f3f6","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":50,"value":0,"used":false,"expireTime":"2023-01-13T20:02:36.965+08:00","createTime":"2023-01-13T20:02:36.965+08:00"},{"id":"63c1483616192c0b2a11f3f5","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":50,"value":0,"used":true,"expireTime":"2023-01-13T20:01:58.602+08:00","createTime":"2023-01-13T20:01:58.602+08:00"},{"id":"63c14781f28dc790f369a943","cId":"63c0db07321bbdf07fce08ca","name":"四等奖","type":2,"count":17,"price":50,"value":0,"used":false,"expireTime":"2023-01-13T19:58:57.448+08:00","createTime":"2023-01-13T19:58:57.448+08:00"}]
/// total : 9

class GoldTickets {
  GoldTickets({
      List<GoldTicketList> list,
      int total,}){
    _list = list;
    _total = total;
}

  GoldTickets.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(GoldTicketList.fromJson(v));
      });
    }
    _total = json['total'];
  }
  List<GoldTicketList> _list;
  int _total;

  List<GoldTicketList> get list => _list;
  int get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_list != null) {
      map['list'] = _list.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    return map;
  }

}

/// id : "63c149ab52b01af6f7d155ac"
/// cId : "63c0db07321bbdf07fce08ca"
/// name : "四等奖"
/// type : 2
/// count : 17
/// price : 80
/// value : 0
/// used : false
/// expireTime : "2023-01-23T20:08:11.138+08:00"
/// createTime : "2023-01-13T20:08:11.138+08:00"

class GoldTicketList {
  GoldTicketList({
      String id, 
      String cId, 
      String name, 
      int type, 
      int count, 
      int price, 
      int value, 
      bool used, 
      String expireTime, 
      String createTime,}){
    _id = id;
    _cId = cId;
    _name = name;
    _type = type;
    _count = count;
    _price = price;
    _value = value;
    _used = used;
    _expireTime = expireTime;
    _createTime = createTime;
}

  GoldTicketList.fromJson(dynamic json) {
    _id = json['id'];
    _cId = json['cId'];
    _name = json['name'];
    _type = json['type'];
    _count = json['count'];
    _price = json['price'];
    _value = json['value'];
    _used = json['used'];
    _expireTime = json['expireTime'];
    _createTime = json['createTime'];
  }
  String _id;
  String _cId;
  String _name;
  int _type;
  int _count;
  int _price;
  int _value;
  bool _used;
  String _expireTime;
  String _createTime;

  bool isSelected = false;

  String get id => _id;
  String get cId => _cId;
  String get name => _name;
  int get type => _type;
  int get count => _count;
  int get price => _price;
  int get value => _value;
  bool get used => _used;
  String get expireTime => _expireTime;
  String get createTime => _createTime;

  setIsSelected(bool value){
    isSelected = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['cId'] = _cId;
    map['name'] = _name;
    map['type'] = _type;
    map['count'] = _count;
    map['price'] = _price;
    map['value'] = _value;
    map['used'] = _used;
    map['expireTime'] = _expireTime;
    map['createTime'] = _createTime;
    return map;
  }

}