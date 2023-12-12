import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/local_user_info.dart';

enum SwitchAccountAction {
  localUserGetOkay,
  loadSwitchAccountAction,
  devLoginAction,
  onService,
  qrLogin,
  onGetVersion,
  showLoading,
  clearAccount,
}

class SwitchAccountActionCreator {
  static Action devLogin() {
    return Action(SwitchAccountAction.devLoginAction);
  }

  static Action onShowLoading(bool show) {
    return Action(SwitchAccountAction.showLoading, payload: show);
  }

  static Action onClearAccount() {
    return Action(SwitchAccountAction.clearAccount);
  }

  static Action onLocalUserGetOkay(List<LocalUserInfo> localUserInfos) {
    return Action(SwitchAccountAction.localUserGetOkay,
        payload: localUserInfos);
  }

  ///点击客服
  static Action onService() {
    return Action(SwitchAccountAction.onService);
  }

  static Action qrLogin(String qrCode) {
    return Action(SwitchAccountAction.qrLogin, payload: qrCode);
  }

  static Action onGetVersion() {
    return Action(SwitchAccountAction.onGetVersion);
  }
}
