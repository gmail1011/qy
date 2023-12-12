
class ApBankListModel {
  List<AccountInfoModel> list;

  static ApBankListModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    ApBankListModel apBankListModel = ApBankListModel();
    apBankListModel.list = List()..addAll(
      (map['list'] as List ?? []).map((o) => AccountInfoModel.fromMap(o))
    );
    return apBankListModel;
  }

  Map toJson() => {
    "list": list,
  };
}

/// id : "5dfa13e1bd41f86f4d496692"
/// actName : "咯哦了"
/// act : "6225898957885558889"
/// bankCode : ""
/// cardType : ""

class AccountInfoModel {
  String id;
  String actName;
  String act;
  String bankCode;
  String cardType;

  static AccountInfoModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AccountInfoModel listBean = AccountInfoModel();
    listBean.id = map['id'];
    listBean.actName = map['actName'];
    listBean.act = map['act'];
    listBean.bankCode = map['bankCode'];
    listBean.cardType = map['cardType'];
    return listBean;
  }

  Map toJson() => {
    "id": id,
    "actName": actName,
    "act": act,
    "bankCode": bankCode,
    "cardType": cardType,
  };
}