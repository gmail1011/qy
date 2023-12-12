import 'package:fish_redux/fish_redux.dart';

enum MobileLoginAction {
  backAction,
  getSMSCodeAction,
  onGetSMSCodeAction,
  phoneLoginAction,
  onPhoneLoginAction,
  onShowArea,
}

class MobileLoginActionCreator {
  static Action getSMSCode(String phoneNum) {
    return Action(MobileLoginAction.getSMSCodeAction, payload: phoneNum);
  }

  static Action phoneLogin() {
    return Action(MobileLoginAction.phoneLoginAction);
  }

  static Action onGetSMSCode(bool smsSuccess) {
    return Action(MobileLoginAction.onGetSMSCodeAction, payload: smsSuccess);
  }

  static Action onPhoneLogin() {
    return Action(MobileLoginAction.onPhoneLoginAction);
  }

  static Action onShowArea(String areaCode) {
    return Action(MobileLoginAction.onPhoneLoginAction,payload: areaCode);
  }
}
