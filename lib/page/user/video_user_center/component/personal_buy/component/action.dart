import 'package:fish_redux/fish_redux.dart';

enum BuyItemAction { onTapItem }

class BuyItemActionCreator {
  static Action onTapItem(String uniqueId) {
    return  Action(BuyItemAction.onTapItem,payload: uniqueId);
  }
}
