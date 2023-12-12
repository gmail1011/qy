/// code : 200
/// data : {"hasNext":false,"list":[{"id":"64b002b6780a128ad14902e0","title":"测试一次模版","sourceURL":"bktadminup/sp/l3/n6/xn/l6/d3a48683031546749fe4e7fd4057fe09.m3u8","status":1,"playTime":30,"cover":"cf230705/image/2nf/1yd/127/2wp/1262eec0fb48567d0cfe884221958094.png","type":"video/mp4","coin":200,"vipCoin":160,"createdAt":"2023-07-13T21:57:10.459+08:00","updatedAt":"2023-07-13T21:57:10.459+08:00"}]}
/// hash : false
/// msg : "success"
/// time : "2023-07-19T10:26:02.498Z"
/// tip : ""

class AIFaceData {
  AIFaceData({
      int code,
    AiFaceData data,
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

  AIFaceData.fromJson(dynamic json) {
    _code = json['code'];
    _data = json['data'] != null ? AiFaceData.fromJson(json['data']) : null;
    _hash = json['hash'];
    _msg = json['msg'];
    _time = json['time'];
    _tip = json['tip'];
  }
  int _code;
  AiFaceData _data;
  bool _hash;
  String _msg;
  String _time;
  String _tip;

  int get code => _code;
  AiFaceData get data => _data;
  bool get hash => _hash;
  String get msg => _msg;
  String get time => _time;
  String get tip => _tip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    map['hash'] = _hash;
    map['msg'] = _msg;
    map['time'] = _time;
    map['tip'] = _tip;
    return map;
  }

}

/// hasNext : false
/// list : [{"id":"64b002b6780a128ad14902e0","title":"测试一次模版","sourceURL":"bktadminup/sp/l3/n6/xn/l6/d3a48683031546749fe4e7fd4057fe09.m3u8","status":1,"playTime":30,"cover":"cf230705/image/2nf/1yd/127/2wp/1262eec0fb48567d0cfe884221958094.png","type":"video/mp4","coin":200,"vipCoin":160,"createdAt":"2023-07-13T21:57:10.459+08:00","updatedAt":"2023-07-13T21:57:10.459+08:00"}]

class AiFaceData {
  AiFaceData({
      bool hasNext, 
      List<AiFaceList> list,}){
    _hasNext = hasNext;
    _list = list;
}

  AiFaceData.fromJson(dynamic json) {
    _hasNext = json['hasNext'];
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list.add(AiFaceList.fromJson(v));
      });
    }
  }
  bool _hasNext;
  List<AiFaceList> _list;

  bool get hasNext => _hasNext;
  List<AiFaceList> get list => _list;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasNext'] = _hasNext;
    if (_list != null) {
      map['list'] = _list.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "64b002b6780a128ad14902e0"
/// title : "测试一次模版"
/// sourceURL : "bktadminup/sp/l3/n6/xn/l6/d3a48683031546749fe4e7fd4057fe09.m3u8"
/// status : 1
/// playTime : 30
/// cover : "cf230705/image/2nf/1yd/127/2wp/1262eec0fb48567d0cfe884221958094.png"
/// type : "video/mp4"
/// coin : 200
/// vipCoin : 160
/// createdAt : "2023-07-13T21:57:10.459+08:00"
/// updatedAt : "2023-07-13T21:57:10.459+08:00"

class AiFaceList {
  AiFaceList({
      String id, 
      String title, 
      String sourceURL, 
      int status, 
      int playTime, 
      String cover, 
      String type, 
      int coin, 
      int vipCoin, 
      String createdAt, 
      String updatedAt,}){
    _id = id;
    _title = title;
    _sourceURL = sourceURL;
    _status = status;
    _playTime = playTime;
    _cover = cover;
    _type = type;
    _coin = coin;
    _vipCoin = vipCoin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  AiFaceList.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _sourceURL = json['sourceURL'];
    _status = json['status'];
    _playTime = json['playTime'];
    _cover = json['cover'];
    _type = json['type'];
    _coin = json['coin'];
    _vipCoin = json['vipCoin'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String _id;
  String _title;
  String _sourceURL;
  int _status;
  int _playTime;
  String _cover;
  String _type;
  int _coin;
  int _vipCoin;
  String _createdAt;
  String _updatedAt;

  String get id => _id;
  String get title => _title;
  String get sourceURL => _sourceURL;
  int get status => _status;
  int get playTime => _playTime;
  String get cover => _cover;
  String get type => _type;
  int get coin => _coin;
  int get vipCoin => _vipCoin;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['sourceURL'] = _sourceURL;
    map['status'] = _status;
    map['playTime'] = _playTime;
    map['cover'] = _cover;
    map['type'] = _type;
    map['coin'] = _coin;
    map['vipCoin'] = _vipCoin;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}