import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SelectTagsAction { action }

class SelectTagsActionCreator {
  static Action onAction() {
    return const Action(SelectTagsAction.action);
  }
}
