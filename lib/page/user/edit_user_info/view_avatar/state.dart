import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';

class ViewAvatarState extends GlobalBaseState
    implements Cloneable<ViewAvatarState> {
  @override
  ViewAvatarState clone() {
    return ViewAvatarState();
  }
}

ViewAvatarState initState(Map<String, dynamic> args) {
  return ViewAvatarState();
}
