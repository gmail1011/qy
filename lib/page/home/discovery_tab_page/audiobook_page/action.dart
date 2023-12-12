import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';

enum AudiobookAction {
  loadData, //获取数据
  setAllData, //设置数据
  changePush, //推荐换一换
  setChangePush, //设置换一换数据
  setLoading,
}

class AudiobookActionCreator {
  static Action setAllData(AudioBookHomeModel model) {
    return Action(AudiobookAction.setAllData, payload: model);
  }

  static Action setLoading(bool loading) {
    return Action(AudiobookAction.setLoading, payload: loading);
  }

  static Action loadData() {
    return const Action(AudiobookAction.loadData);
  }

  static Action changePush() {
    return const Action(AudiobookAction.changePush);
  }

  static Action setChangePush(List<AudioBook> list) {
    return Action(AudiobookAction.setChangePush, payload: list);
  }
}
