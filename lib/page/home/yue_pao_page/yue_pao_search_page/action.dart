import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/lou_feng_model.dart';

//TODO replace with your own action
enum YuePaoSearchAction {
  onInitList,
  loadMoedData,
  onAddList,
  onChangePageNumber,
  onSubmitted,
  onChangeItem,
}

class YuePaoSearchActionCreator {
  static Action onChangeItem(LouFengItem louFengItem) {
    return Action(YuePaoSearchAction.onChangeItem, payload: louFengItem);
  }
  static Action onInitList(List<LouFengItem> list) {
    return Action(YuePaoSearchAction.onInitList, payload: list);
  }
  static Action loadMoedData() {
    return Action(YuePaoSearchAction.loadMoedData);
  }
  static Action onAddList(List<LouFengItem> list) {
    return Action(YuePaoSearchAction.onAddList, payload: list);
  }
  static Action onChangePageNumber() {
    return Action(YuePaoSearchAction.onChangePageNumber);
  }
  static Action onSubmitted() {
    return Action(YuePaoSearchAction.onSubmitted);
  }
}
