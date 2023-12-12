import 'package:fish_redux/fish_redux.dart';

enum HomeAction { changeTab, changeTabOkay }

class HomeActionCreator {
  static Action changeTab(int index) {
    return Action(HomeAction.changeTab, payload: index);
  }

  static Action changeTabOkay(int index) {
    return Action(HomeAction.changeTabOkay, payload: index);
  }
}
