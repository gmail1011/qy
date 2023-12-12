import 'package:fish_redux/fish_redux.dart';

enum EditNickNameAction {
  editNickName,
  updateUI,
}

class EditNickNameActionCreator {
  static Action editNickName() {
    return const Action(EditNickNameAction.editNickName);
  }

  static Action updateUI() {
    return const Action(EditNickNameAction.updateUI);
  }
}
