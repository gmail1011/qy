/// code : 200
/// data : [{"content":"用户ID102540 小西瓜提现2000元 8分钟前","position":0,"positionDesc":"用户ID102540 小西瓜提现2000元 8分钟前"},{"content":"用户ID102540 小西瓜提现2000元 8分钟前","position":1,"positionDesc":"用户ID102540 小西瓜提现2000元 8分钟前"}]
/// hash : false
/// msg : "success"
/// time : "2022-12-13T02:10:18.279Z"
/// tip : ""

class ExchangeMarquee {
  ExchangeMarquee({
      int code, 
      List<Data> data, 
      bool hash, 
      String msg, 
      String time, 
      String tip,}){
    _code = code;
    _data = data;
    _hash = hash;
    _msg = msg;
    _time = time;
    _tip = tip;
}

  ExchangeMarquee.fromJson(dynamic json) {
    _code = json['code'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
    _hash = json['hash'];
    _msg = json['msg'];
    _time = json['time'];
    _tip = json['tip'];
  }
  int _code;
  List<Data> _data;
  bool _hash;
  String _msg;
  String _time;
  String _tip;

  int get code => _code;
  List<Data> get data => _data;
  bool get hash => _hash;
  String get msg => _msg;
  String get time => _time;
  String get tip => _tip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    map['hash'] = _hash;
    map['msg'] = _msg;
    map['time'] = _time;
    map['tip'] = _tip;
    return map;
  }

}

/// content : "用户ID102540 小西瓜提现2000元 8分钟前"
/// position : 0
/// positionDesc : "用户ID102540 小西瓜提现2000元 8分钟前"

class Data {
  Data({
      String content, 
      int position, 
      String positionDesc,}){
    _content = content;
    _position = position;
    _positionDesc = positionDesc;
}

  Data.fromJson(dynamic json) {
    _content = json['content'];
    _position = json['position'];
    _positionDesc = json['positionDesc'];
  }
  String _content;
  int _position;
  String _positionDesc;

  String get content => _content;
  int get position => _position;
  String get positionDesc => _positionDesc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = _content;
    map['position'] = _position;
    map['positionDesc'] = _positionDesc;
    return map;
  }

}