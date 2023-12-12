import 'package:flutter_app/model/user_info_model.dart';

///手机号登录响应模型
class MobileLoginModel {
  String token;
  UserInfoModel userInfo;

  static MobileLoginModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MobileLoginModel mobileLoginModelBean = MobileLoginModel();
    mobileLoginModelBean.token = map['token'];
    mobileLoginModelBean.userInfo = UserInfoModel.fromMap(map['userInfo']);
    return mobileLoginModelBean;
  }

  static MobileLoginModel fromJson(Map<String, dynamic> map) => fromMap(map);
  Map toJson() => {
        "token": token,
        "userInfo": userInfo,
      };
}
