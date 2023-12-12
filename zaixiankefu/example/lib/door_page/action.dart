
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum DoorAction { action ,jumpAction , initAction}

class DoorActionCreator {
  static Action onAction() {
    return const Action(DoorAction.action);
  }
  static Action initAction() {
    return const Action(DoorAction.initAction);
  }
  static Action jumpAction() {
    return const Action(DoorAction.initAction);
  }
}
