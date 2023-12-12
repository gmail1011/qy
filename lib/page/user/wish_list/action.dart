import 'package:fish_redux/fish_redux.dart';

enum WishlistAction { action }

class WishlistActionCreator {
  static Action onAction() {
    return const Action(WishlistAction.action);
  }
}
