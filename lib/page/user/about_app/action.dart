import 'package:fish_redux/fish_redux.dart';

enum AboutAppAction { copy }

class AboutAppActionCreator {
  static Action copyText(String content) {
    return const Action(AboutAppAction.copy);
  }
}
