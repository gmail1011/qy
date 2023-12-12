import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/liao_ba_history_entity.dart';

//TODO replace with your own action
enum HistoryAction { action , initData , loadMore ,}

class HistoryActionCreator {
  static Action onAction() {
    return const Action(HistoryAction.action);
  }

  static Action onInitData(LiaoBaHistoryData liaoBaHistoryData) {
    return  Action(HistoryAction.initData,payload: liaoBaHistoryData);
  }

  static Action onLoadMore(int pageMumber) {
    return  Action(HistoryAction.loadMore,payload: pageMumber);
  }
}
