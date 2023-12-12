import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PassionRecordingAction { action }

class PassionRecordingActionCreator {
  static Action onAction() {
    return const Action(PassionRecordingAction.action);
  }
}
