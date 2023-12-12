class ServicesModel {
  String faq;
  String sign;
  String check;
  bool isVoiceActive;

  ServicesModel({this.faq, this.sign, this.check});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    faq = json['faq'];
    sign = json['sign'];
    check = json['check'];
    isVoiceActive = json['isVoiceActive'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faq'] = this.faq;
    data['sign'] = this.sign;
    data['check'] = this.check;
    data['isVoiceActive'] = this.isVoiceActive;
    return data;
  }
}
