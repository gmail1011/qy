import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PublishDetailAction { action }

class PublishDetailActionCreator {
  static Action onAction() {
    return const Action(PublishDetailAction.action);
  }
}
