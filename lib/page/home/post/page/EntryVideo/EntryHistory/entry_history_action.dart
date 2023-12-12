import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/entry_history_entity.dart';

//TODO replace with your own action
enum EntryHistoryAction { action , initData , onLoadMore}

class EntryHistoryActionCreator {
  static Action onAction() {
    return const Action(EntryHistoryAction.action);
  }

  static Action onInitData(EntryHistoryData entryHistoryData) {
    return Action(EntryHistoryAction.initData,payload: entryHistoryData);
  }

  static Action onLoadMore(int pageNumber) {
    return Action(EntryHistoryAction.onLoadMore,payload: pageNumber);
  }
}
