import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_base/utils/log.dart';

class UserCertificationData {
  UserCertificationDataOfficialcer officialcer;
  ProductItemBean productInfo;
  DCModel daichong;

  static UserCertificationData fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    UserCertificationData rechargeTypeListModelBean = UserCertificationData();
    rechargeTypeListModelBean.officialcer =
        UserCertificationDataOfficialcer.fromJson(map["officialcer"]);

    if (map.containsKey("productInfo")) {
      rechargeTypeListModelBean.productInfo =
          ProductItemBean.fromJson(map["productInfo"]);

      try {
        rechargeTypeListModelBean.daichong =
            DCModel.fromJson(map["productInfo"]["daichong"]);
      } catch (e) {
        l.e("解析代充错误" , "$e");
      }
    }

    return rechargeTypeListModelBean;
  }
}

class UserCertificationDataOfficialcer {
  int processingStatus;

  static UserCertificationDataOfficialcer fromJson(Map<String, dynamic> map) {
    UserCertificationDataOfficialcer userCertificationDataOfficialcer =
        UserCertificationDataOfficialcer();
    userCertificationDataOfficialcer.processingStatus = map["processingStatus"];
    return userCertificationDataOfficialcer;
  }
}
