import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AgentRecordAction { action }

class AgentRecordActionCreator {
  static Action onAction() {
    return const Action(AgentRecordAction.action);
  }
}
