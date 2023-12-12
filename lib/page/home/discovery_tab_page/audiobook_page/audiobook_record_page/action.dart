import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AudiobookRecordAction { action }

class AudiobookRecordActionCreator {
  static Action onAction() {
    return const Action(AudiobookRecordAction.action);
  }
}
