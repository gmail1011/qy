import 'package:fish_redux/fish_redux.dart';

enum MineBilleItemAction { action }

class MineBilleItemActionCreator {
  static Action onAction() {
    return const Action(MineBilleItemAction.action);
  }
}
