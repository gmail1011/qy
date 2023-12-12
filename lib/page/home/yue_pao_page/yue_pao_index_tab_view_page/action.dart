import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/lou_feng_model.dart';

//TODO replace with your own action
enum YuePaoIndexTabViewAction {
  onChangeList,
  onChangePageNumber,
  initPageNumber,
  loadMoreData,
  onChangeAD,
  onSelectCity,
  onChangeCity,
  onChangeItem,
  loadRefresh
}

class YuePaoIndexTabViewActionCreator {
  static Action onChangeList(List<LouFengItem> list, int pageNumber) {
    return Action(YuePaoIndexTabViewAction.onChangeList, payload: {
      'list': list,
      'pageNumber': pageNumber,
    });
  }
  static Action onChangePageNumber() {
    return const Action(YuePaoIndexTabViewAction.onChangePageNumber);
  }
  static Action initPageNumber() {
    return const Action(YuePaoIndexTabViewAction.initPageNumber);
  }
  static Action onChangeItem(LouFengItem item) {
    return Action(YuePaoIndexTabViewAction.onChangeItem, payload: item);
  }
  static Action loadMoreData(bool hasAD) {
    return Action(YuePaoIndexTabViewAction.loadMoreData, payload: hasAD);
  }
  static Action loadRefresh(bool hasAD) {
    return Action(YuePaoIndexTabViewAction.loadRefresh);
  }
  static Action onChangeAD(bool hasAD) {
    return Action(YuePaoIndexTabViewAction.onChangeAD, payload: hasAD);
  }
  static Action onSelectCity(String city) {
    return Action(YuePaoIndexTabViewAction.onSelectCity, payload: city);
  }
  static Action onChangeCity(String city) {
    return Action(YuePaoIndexTabViewAction.onChangeCity, payload: city);
  }
}
