import 'package:fish_redux/fish_redux.dart';

enum InitialBindPhoneAction {
  sendSMSCodeAction,
  onClickNextStep,
  onClickNextStepSuccess,
  onSendSMSCodeAction,
  onBindPhoneAction,
  updateUI,
  showCountryCodeUI,
}

class InitialBindPhoneActionCreator {
  static Action sendNotificationSMSCode() {
    return Action(InitialBindPhoneAction.sendSMSCodeAction);
  }

  static Action onSendSMSCode(bool smsSuccess) {
    return Action(InitialBindPhoneAction.onSendSMSCodeAction,
        payload: smsSuccess);
  }

  static Action onBindPhone() {
    return Action(InitialBindPhoneAction.onBindPhoneAction);
  }

  static Action onClickNextStep() {
    return Action(InitialBindPhoneAction.onClickNextStep);
  }

  static Action onClickNextStepSuccess() {
    return Action(InitialBindPhoneAction.onClickNextStepSuccess);
  }

  static Action updateUI() {
    return Action(InitialBindPhoneAction.updateUI);
  }

  static Action showCountryCodeUI() {
    return Action(InitialBindPhoneAction.showCountryCodeUI);
  }
}
