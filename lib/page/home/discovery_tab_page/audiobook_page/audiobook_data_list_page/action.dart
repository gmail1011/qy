import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';

enum AudiobookDataListAction {
  loadData,
  loadMoreData,
  setLoadData,
  setLoadMoreData,
  broadcastSearchAction,
}

class AudiobookDataListActionCreator {
  static Action loadData() {
    return const Action(AudiobookDataListAction.loadData);
  }

  static Action broadcastSearchAction(String keyword) {
    return Action(AudiobookDataListAction.broadcastSearchAction,
        payload: keyword);
  }

  static Action loadMoreData() {
    return const Action(AudiobookDataListAction.loadMoreData);
  }

  static Action setLoadData(List<AudioBook> list) {
    return Action(AudiobookDataListAction.setLoadData, payload: list);
  }

  static Action setLoadMoreData(List<AudioBook> list) {
    return Action(AudiobookDataListAction.setLoadMoreData, payload: list);
  }
}
