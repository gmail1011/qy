import 'package:fish_redux/fish_redux.dart';

enum RebindPhoneAction {
  backAction,
  getSMSCodeAction,
  onGetSMSCodeAction,
  bindPhoneAction,
  onBindPhoneAction,
  onRebindPhone,
  onRefreshState,
}

class RebindPhoneActionCreator {
  static Action getSMSCode(String phoneNum) {
    return Action(RebindPhoneAction.getSMSCodeAction, payload: phoneNum);
  }

  static Action bindPhone(Map<String, dynamic> params) {
    return Action(RebindPhoneAction.bindPhoneAction, payload: params);
  }

  static Action onGetSMSCode(bool smsSuccess) {
    return Action(RebindPhoneAction.onGetSMSCodeAction, payload: smsSuccess);
  }

  static Action onBindPhone() {
    return Action(RebindPhoneAction.onBindPhoneAction);
  }
  static Action onRebindPhone() {
    return Action(RebindPhoneAction.onRebindPhone);
  }
  static Action onRefreshState() {
    return Action(RebindPhoneAction.onRefreshState);
  }
}
