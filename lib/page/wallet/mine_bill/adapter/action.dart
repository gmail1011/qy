import 'package:fish_redux/fish_redux.dart';

enum MineBillAdapterAction { action }

class MineBillActionCreator {
  static Action onAction() {
    return const Action(MineBillAdapterAction.action);
  }
}
