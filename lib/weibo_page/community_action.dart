import 'package:fish_redux/fish_redux.dart';

enum CommunityAction { action, showNewPersonCutDownTime }

class CommunityActionCreator {
  static Action onAction() {
    return const Action(CommunityAction.action);
  }

  static Action showNewPersonCutDownTime(bool showCutDownTime) {
    return Action(CommunityAction.showNewPersonCutDownTime, payload: showCutDownTime);
  }
}
