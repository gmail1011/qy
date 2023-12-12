import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';

enum GlobalAction {
  userUpdateOkay, // 用户信息获取成功，主要是登陆成功
  walletUpdateOkay, // 钱包获取成功
}

class GlobalActionCreator {
  /// 发送reducer给所以的AOP页面
  /// see register in [APP]
  static Action userUpdateOkay(UserInfoModel user) {
    return Action(GlobalAction.userUpdateOkay, payload: user);
  }

  /// 发送reducer给所以的AOP页面
  /// see register in [APP]
  static Action walletUpdateOkay(WalletModelEntity wallet) {
    return Action(GlobalAction.walletUpdateOkay, payload: wallet);
  }
}
