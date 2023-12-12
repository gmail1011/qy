class FreezeAmount {

  FreezeAmount.fromJson(dynamic json) {
    freezeAmount = json['freezeAmount'];
  }
  int freezeAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['freezeAmount'] = freezeAmount;
    return map;
  }

}