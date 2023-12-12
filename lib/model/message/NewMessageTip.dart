class NewMessageTip {
  NewMessageTip({
      this.newsTip,});

  NewMessageTip.fromJson(dynamic json) {
    newsTip = json['newsTip'];
  }
  bool newsTip;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['newsTip'] = newsTip;
    return map;
  }

}