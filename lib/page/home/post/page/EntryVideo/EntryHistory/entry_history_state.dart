import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/entry_history_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EntryHistoryState implements Cloneable<EntryHistoryState> {
  int pageNumber = 1;
  int pageSize = 20;

  EntryHistoryData entryHistoryData;

  RefreshController refreshController = RefreshController();

  @override
  EntryHistoryState clone() {
    return EntryHistoryState()
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..entryHistoryData = entryHistoryData
      ..refreshController = refreshController;
  }
}

EntryHistoryState initState(Map<String, dynamic> args) {
  return EntryHistoryState();
}
