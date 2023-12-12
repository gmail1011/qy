class LocalUserInfo {
  int uid;
  String nickName;
  String mobile;
  String portrait;

  String qr;

  ///登录类型修改  0-devID 1-token 2 mobileLogin 3-qrCodeLogin
  int loginType;

  LocalUserInfo(
      {this.uid,
      this.nickName,
      this.mobile,
      this.portrait,
      this.qr,
      this.loginType = -1});

  static LocalUserInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    LocalUserInfo localUserInfoBean = LocalUserInfo();
    localUserInfoBean.uid = map['uid'];
    localUserInfoBean.nickName = map['nickName'];
    localUserInfoBean.mobile = map['mobile'];
    localUserInfoBean.portrait = map['portrait'];
    localUserInfoBean.qr = map['qr'];
    localUserInfoBean.loginType = map['loginType'];
    return localUserInfoBean;
  }

  Map toJson() => {
        "uid": uid,
        "nickName": nickName,
        "mobile": mobile,
        "portrait": portrait,
        "qr": qr,
        "loginType": loginType,
      };

  static List<LocalUserInfo> toList(List<dynamic> mapList) {
    List<LocalUserInfo> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromMap(current));
    }
    return list;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalUserInfo &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
