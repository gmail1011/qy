import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PublishHelpAction { action }

class PublishHelpActionCreator {
  static Action onAction() {
    return const Action(PublishHelpAction.action);
  }
}
