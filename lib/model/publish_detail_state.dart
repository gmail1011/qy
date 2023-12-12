import 'package:fish_redux/fish_redux.dart';

class PublishDetailState implements Cloneable<PublishDetailState> {

  @override
  PublishDetailState clone() {
    return PublishDetailState();
  }
}

PublishDetailState initState(Map<String, dynamic> args) {
  return PublishDetailState();
}
