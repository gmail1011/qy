class UpGradeVipInfo {
  int vipUpCheapPrice;
  int vipUpPrice;

  UpGradeVipInfo({this.vipUpCheapPrice, this.vipUpPrice});

  UpGradeVipInfo.fromJson(Map<String, dynamic> json) {
    vipUpCheapPrice = json['vipUpCheapPrice'];
    vipUpPrice = json['vipUpPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vipUpCheapPrice'] = this.vipUpCheapPrice;
    data['vipUpPrice'] = this.vipUpPrice;
    return data;
  }
}