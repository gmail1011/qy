import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum MyPurchasesAction { action }

class MyPurchasesActionCreator {
  static Action onAction() {
    return const Action(MyPurchasesAction.action);
  }
}
