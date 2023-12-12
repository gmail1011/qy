import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/novel_model.dart';

//TODO replace with your own action
enum PassionNovelViewAction {
  onChangeList,
  onChangePageNumber,
  moreData,
  refresh,
  initPageNumber,
  onChangeKeyWord,
  onSetKeyWord,
  replaceItem,
}

class PassionNovelViewActionCreator {
  static Action replaceItem(NoveItem item) {
    return Action(PassionNovelViewAction.replaceItem, payload: item);
  }
  static Action onSetKeyWord(String keyword) {
    return Action(PassionNovelViewAction.onSetKeyWord, payload: keyword);
  }
  static Action onChangeKeyWord(String keyword) {
    return Action(PassionNovelViewAction.onChangeKeyWord, payload: keyword);
  }
  static Action onChangeList(List<NoveItem> list) {
    return Action(PassionNovelViewAction.onChangeList, payload: list);
  }
  static Action onChangePageNumber() {
    return const Action(PassionNovelViewAction.onChangePageNumber);
  }
  static Action moreData() {
    return const Action(PassionNovelViewAction.moreData);
  }
  static Action refresh() {
    return const Action(PassionNovelViewAction.refresh);
  }
  static Action initPageNumber() {
    return const Action(PassionNovelViewAction.initPageNumber);
  }
}
