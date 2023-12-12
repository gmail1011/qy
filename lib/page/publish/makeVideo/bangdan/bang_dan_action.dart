import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum BangDanAction { action }

class BangDanActionCreator {
  static Action onAction() {
    return const Action(BangDanAction.action);
  }
}
