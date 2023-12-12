import 'package:fish_redux/fish_redux.dart';

class AboutAppState implements Cloneable<AboutAppState> {

  @override
  AboutAppState clone() {
    return AboutAppState();
  }
}

AboutAppState initState(Map<String, dynamic> args) {
  return AboutAppState();
}
