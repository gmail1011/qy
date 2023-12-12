import 'package:fish_redux/fish_redux.dart';

enum RecoverMobileAction {
  action,
  updateMobileText,
}

class RecoverMobileActionCreator {
  static Action onAction() {
    return const Action(RecoverMobileAction.action);
  }

  static Action updateMobileText(String mobile) {
    return Action(RecoverMobileAction.updateMobileText, payload: mobile);
  }
}
