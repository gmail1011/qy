/// token : ""

class TokenModel {
  String token;

  static TokenModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    TokenModel tokenModelBean = TokenModel();
    tokenModelBean.token = map['token'];
    return tokenModelBean;
  }

  Map toJson() => {
        "token": token,
      };
}
