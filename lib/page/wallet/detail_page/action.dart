import 'package:fish_redux/fish_redux.dart';

enum DetailAction { action }

class DetailActionCreator {
  static Action onAction() {
    return const Action(DetailAction.action);
  }
}
