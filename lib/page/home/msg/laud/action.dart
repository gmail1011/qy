import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/message/laud_model.dart';

enum LaudAction {
  loadLaudAction,
  onLoadLaudAction,
}

class LaudActionCreator {
  static Action loadLaudList() {
    return const Action(LaudAction.loadLaudAction);
  }

  static Action onLoadLaudList(List<LaudItem> laudList, bool hasNext) {
    return Action(LaudAction.onLoadLaudAction, payload: {'data': laudList, 'hasNext': hasNext});
  }
}
