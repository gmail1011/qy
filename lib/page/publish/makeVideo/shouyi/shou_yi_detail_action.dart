import 'package:fish_redux/fish_redux.dart';

enum ShouYiDetailAction { refreshUI, }

class ShouYiDetailActionCreator {
  static Action refreshUI() {
    return const Action(ShouYiDetailAction.refreshUI);
  }

}
