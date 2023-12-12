import 'package:fish_redux/fish_redux.dart';

enum MyCertificationAction {
  submit,
  updateUI,
}

class MyCertificationActionCreator {
  static Action submit() {
    return const Action(MyCertificationAction.submit);
  }

  static Action updateUI() {
    return const Action(MyCertificationAction.updateUI);
  }
}
