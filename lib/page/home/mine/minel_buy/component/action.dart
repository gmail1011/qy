import 'package:fish_redux/fish_redux.dart';

enum MineBuyItemAction { onTapItem }

class MineBuyItemActionCreator {
  static Action onTapItem(String uniqueId) {
    return  Action(MineBuyItemAction.onTapItem,payload: uniqueId);
  }
}
