import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum VoiceAnchorListAction { action }

class VoiceAnchorListActionCreator {
  static Action onAction() {
    return const Action(VoiceAnchorListAction.action);
  }
}
