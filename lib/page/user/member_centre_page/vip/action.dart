import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/product_item.dart';

enum VIPAction { updateUI, changeItem, retryLoadData }

class VIPActionCreator {
  static Action updateUI() {
    return const Action(VIPAction.updateUI);
  }

  static Action retryLoadData() {
    return const Action(VIPAction.retryLoadData);
  }

  static Action changeItem(int index, ProductItemBean vipItem) {
    return Action(VIPAction.changeItem, payload: {"index": index, "vipItem": vipItem});
  }
}
