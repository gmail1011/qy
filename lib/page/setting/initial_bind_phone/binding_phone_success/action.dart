import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum BindingPhoneSuccessAction { action }

class BindingPhoneSuccessActionCreator {
  static Action onAction() {
    return const Action(BindingPhoneSuccessAction.action);
  }
}
