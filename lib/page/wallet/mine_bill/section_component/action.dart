import 'package:fish_redux/fish_redux.dart';

enum SectionAction { action }

class SectionActionCreator {
  static Action onAction() {
    return const Action(SectionAction.action);
  }
}
