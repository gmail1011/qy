import 'package:fish_redux/fish_redux.dart';
import 'component/state.dart';

enum MineBuyPostAction {
  onLoadData,
  loadDataSuccess,
  loadDataFail,
  onDelBuyItem,
  onDelRefresh,
}

class MineBuyPostActionCreator {
  static Action onLoadData() {
    return Action(MineBuyPostAction.onLoadData);
  }

  static Action loadDataSuccess(List<MineBuyItemState> list) {
    return Action(MineBuyPostAction.loadDataSuccess, payload: list);
  }

  static Action loadDataFail() {
    return Action(MineBuyPostAction.loadDataFail);
  }

  static Action onDelBuyItem(MineBuyItemState item) {
    return Action(MineBuyPostAction.onDelBuyItem, payload: item);
  }

  static Action onDelRefresh(MineBuyItemState item) {
    return Action(MineBuyPostAction.onDelRefresh, payload: item);
  }
}
