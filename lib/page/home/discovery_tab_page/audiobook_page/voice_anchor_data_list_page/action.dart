import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';

enum VoiceAnchorDataListAction {
  loadData,
  loadMoreData,
  setLoadData,
  setLoadMoreData,
}

class VoiceAnchorDataListActionCreator {
  static Action loadData() {
    return const Action(VoiceAnchorDataListAction.loadData);
  }

  static Action loadMoreData() {
    return const Action(VoiceAnchorDataListAction.loadMoreData);
  }

  static Action setLoadData(List<Anchor> list) {
    return Action(VoiceAnchorDataListAction.setLoadData, payload: list);
  }

  static Action setLoadMoreData(List<Anchor> list) {
    return Action(VoiceAnchorDataListAction.setLoadMoreData, payload: list);
  }
}
