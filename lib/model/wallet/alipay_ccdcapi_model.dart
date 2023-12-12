

class ApcApiModel {
  String bank;
  bool validated;
  String cardType;
  String key;
  List<dynamic> messages;
  String stat;

  static ApcApiModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ApcApiModel apcApiModel = ApcApiModel();
    apcApiModel.bank = map['bank'];
    apcApiModel.validated = map['validated'];
    apcApiModel.cardType = map['cardType'];
    apcApiModel.key = map['key'];
    apcApiModel.messages = map['messages'];
    apcApiModel.stat = map['stat'];
    return apcApiModel;
  }

  Map toJson() => {
        "bank": bank,
        "validated": validated,
        "cardType": cardType,
        "key": key,
        "messages": messages,
        "stat": stat,
      };
}
