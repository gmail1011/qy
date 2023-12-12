import 'package:fish_redux/fish_redux.dart';

enum AccountSafeAction { backAction, refreshUI, qrLogin }

class AccountSafeActionCreator {
  static Action onBack() {
    return const Action(AccountSafeAction.backAction);
  }

  static Action refreshUI() {
    return const Action(AccountSafeAction.refreshUI);
  }

  static Action qrLogin(String qrCode) {
    return Action(AccountSafeAction.qrLogin, payload: qrCode);
  }
}
