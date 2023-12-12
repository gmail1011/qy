class BillItemModel {
  String sId;
  int uid;
  String purchaseOrder;
  num amount;
  double actualAmount;
  int tax;
  double taxAmount;
  String channelType;
  String tranType;
  int tranTypeInt;
  int performance;
  String desc;
  String createdAt;
  String realAmount;
  String sysType;
  int agentLevel;
  int vipLevel;
  String districtCode;
  String promSeqe;
  bool isDirect;

  BillItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
    purchaseOrder = json['purchaseOrder'];
    amount = json['amount'];
    actualAmount = json['actualAmount']?.toDouble();
    tax = json['tax'];
    taxAmount = json['taxAmount']?.toDouble();
    channelType = json['channelType'];
    tranType = json['tranType'];
    tranTypeInt = json['tranTypeInt'];
    performance = json['performance'];
    desc = json['desc'];
    createdAt = json['createdAt'];
    realAmount = json['realAmount'];
    sysType = json['sysType'];
    agentLevel = json['agentLevel'];
    vipLevel = json['vipLevel'];
    districtCode = json['districtCode'];
    promSeqe = json['promSeqe'];
    isDirect = json['isDirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    data['purchaseOrder'] = this.purchaseOrder;
    data['amount'] = this.amount;
    data['actualAmount'] = this.actualAmount;
    data['tax'] = this.tax;
    data['taxAmount'] = this.taxAmount;
    data['channelType'] = this.channelType;
    data['tranType'] = this.tranType;
    data['tranTypeInt'] = this.tranTypeInt;
    data['performance'] = this.performance;
    data['desc'] = this.desc;
    data['createdAt'] = this.createdAt;
    data['realAmount'] = this.realAmount;
    data['sysType'] = this.sysType;
    data['agentLevel'] = this.agentLevel;
    data['vipLevel'] = this.vipLevel;
    data['districtCode'] = this.districtCode;
    data['promSeqe'] = this.promSeqe;
    data['isDirect'] = this.isDirect;
    return data;
  }
}
