import 'package:fish_redux/fish_redux.dart';

enum VoiceAction { action }

class VoiceActionCreator {
  static Action onAction() {
    return const Action(VoiceAction.action);
  }

}
