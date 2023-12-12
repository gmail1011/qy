import 'package:fish_redux/fish_redux.dart';

enum MineLikeItemAction { onTapItem }

class MineLikeItemActionCreator {
  static Action onTapItem(String uniqueId) {
    return Action(MineLikeItemAction.onTapItem, payload: uniqueId);
  }
}
