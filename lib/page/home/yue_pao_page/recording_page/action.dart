import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum RecordingAction { action }

class RecordingActionCreator {
  static Action onAction() {
    return const Action(RecordingAction.action);
  }
}
