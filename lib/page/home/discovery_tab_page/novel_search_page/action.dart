import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/model/novel_model.dart';

enum NovelSearchAction {
  onSubmitted, //點擊搜索
  showAll, //全部搜索記錄
  refreshHistorys, //刷新历史
  deleteAll,
  delete,
  broadcastRefreshHistorys,
  onChangeNovelList,
  onChangePageNumber,
  moreData,
  refresh,
  initPageNumber,
  onChangeAudioBookList,
}

class NovelSearchActionCreator {
  static Action onChangeAudioBookList(List<AudioBook> list) {
    return Action(NovelSearchAction.onChangeAudioBookList, payload: list);
  }

  static Action broadcastRefreshHistorys(String text) {
    return Action(NovelSearchAction.broadcastRefreshHistorys, payload: text);
  }

  static Action initPageNumber() {
    return const Action(NovelSearchAction.initPageNumber);
  }

  static Action refresh() {
    return const Action(NovelSearchAction.refresh);
  }

  static Action moreData() {
    return const Action(NovelSearchAction.moreData);
  }

  static Action onChangePageNumber() {
    return const Action(NovelSearchAction.onChangePageNumber);
  }

  static Action onChangeNovelList(List<NoveItem> list) {
    return Action(NovelSearchAction.onChangeNovelList, payload: list);
  }

  static Action delete(int index) {
    return Action(NovelSearchAction.delete, payload: index);
  }

  static Action deleteAll() {
    return Action(NovelSearchAction.deleteAll);
  }

  static Action showAll() {
    return const Action(NovelSearchAction.showAll);
  }

  static Action onSubmitted(String text) {
    return Action(NovelSearchAction.onSubmitted, payload: text);
  }

  static Action onRefreshHistorys(List<String> list) {
    return Action(NovelSearchAction.refreshHistorys, payload: list);
  }
}
