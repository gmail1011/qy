/// code : 200
/// data : [{"img":"bf211222/image/22r/qp/dy/pl/681a15b77f31eb36a121065815f083c8.png","name":"示例图1","desc":"测试示例图"}]
/// hash : false
/// msg : "success"
/// time : "2022-12-13T12:23:31.846Z"
/// tip : ""

class ExampleDialogBean {
  ExampleDialogBean({
      int code, 
      List<ExampleDialog> data,
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

  ExampleDialogBean.fromJson(dynamic json) {
    _code = json['code'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(ExampleDialog.fromJson(v));
      });
    }
    _hash = json['hash'];
    _msg = json['msg'];
    _time = json['time'];
    _tip = json['tip'];
  }
  int _code;
  List<ExampleDialog> _data;
  bool _hash;
  String _msg;
  String _time;
  String _tip;

  int get code => _code;
  List<ExampleDialog> get data => _data;
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

/// img : "bf211222/image/22r/qp/dy/pl/681a15b77f31eb36a121065815f083c8.png"
/// name : "示例图1"
/// desc : "测试示例图"

class ExampleDialog {
  ExampleDialog({
      String img, 
      String name, 
      String desc,}){
    _img = img;
    _name = name;
    _desc = desc;
}

  ExampleDialog.fromJson(dynamic json) {
    _img = json['img'];
    _name = json['name'];
    _desc = json['desc'];
  }
  String _img;
  String _name;
  String _desc;

  String get img => _img;
  String get name => _name;
  String get desc => _desc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img'] = _img;
    map['name'] = _name;
    map['desc'] = _desc;
    return map;
  }

}