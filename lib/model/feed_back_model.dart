class FeedBackModel {
  int code;
  String data;
  bool hash;
  String msg;
  String time;
  String tip;

  FeedBackModel(
      {this.code, this.data, this.hash, this.msg, this.time, this.tip});

  FeedBackModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'];
    hash = json['hash'];
    msg = json['msg'];
    time = json['time'];
    tip = json['tip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['data'] = this.data;
    data['hash'] = this.hash;
    data['msg'] = this.msg;
    data['time'] = this.time;
    data['tip'] = this.tip;
    return data;
  }
}
