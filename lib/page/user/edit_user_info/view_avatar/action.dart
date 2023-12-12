import 'package:fish_redux/fish_redux.dart';

enum ViewAvatarAction { backAction,loadViewAvatarAction }

class ViewAvatarActionCreator {
  static Action onBack() {
    return const Action(ViewAvatarAction.backAction);
  }

}
