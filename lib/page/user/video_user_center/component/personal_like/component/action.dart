import 'package:fish_redux/fish_redux.dart';

enum LikeItemAction { onTapItem }

class LikeItemActionCreator {
  static Action onTapItem(String uniqueId) {
    return Action(LikeItemAction.onTapItem, payload: uniqueId);
  }
}
